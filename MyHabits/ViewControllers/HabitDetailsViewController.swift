//
//  HabitDetailsViewController.swift
//  MyHabits
//
//  Created by Dima Shikhalev on 15.08.2022.
//

import UIKit

class HabitDetailsViewController: UIViewController {
    
    private lazy var tableView = UITableView(frame: .zero, style: .grouped)
    private var indexPathForCell: IndexPath = IndexPath()
    private lazy var habitStore = HabitsStore.shared
    
    weak var setDataDelegate: HabitViewController?
    weak var habitsVCDelegate: HabitsViewController?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        configure()
        setConstraints()
    }
    
    private func setupViews() {
        
        view.backgroundColor = .systemBackground
        navigationItem.title = habitStore.habits[indexPathForCell.row].name
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Править", style: .done, target: self, action: #selector(editHabit))
        navigationItem.rightBarButtonItem?.tintColor = .purple
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    private func configure() {
        
        view.addSubview(tableView)
        tableView.register(HabitDetailsTableCell.self, forCellReuseIdentifier: "cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    func setIndexPath(index: IndexPath) {
        
        indexPathForCell = index
    }
}

//MARK: tableViewDelegate and dataSource

extension HabitDetailsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return habitStore.dates.count
      }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? HabitDetailsTableCell else {
            return UITableViewCell()
        }
        cell.textLabel?.text = habitStore.trackDateString(forIndex: indexPath.row)
        cell.checkTracking(habit: habitStore.habits[indexPathForCell.row], date: habitStore.dates[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "Активность"
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

//MARK: Selectors
extension HabitDetailsViewController {
    
    @objc private func editHabit() {
        
        let newVC = HabitViewController()
        newVC.isEditing = true
        newVC.indexPathForChange = indexPathForCell
        newVC.backToRootVC = self
        newVC.habitsDelegate = habitsVCDelegate
        let navVC = UINavigationController(rootViewController: newVC)
        present(navVC, animated: true, completion: nil)
    }
}

extension HabitDetailsViewController {
    
    func backToRootVC() {
        
        navigationController?.popToRootViewController(animated: true)
    }
}

//MARK: constraints
extension HabitDetailsViewController {
    
    private func setConstraints() {
        
        NSLayoutConstraint.activate([
        
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            tableView.widthAnchor.constraint(equalTo: view.widthAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
