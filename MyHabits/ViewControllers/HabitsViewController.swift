//
//  ViewController.swift
//  MyHabits
//
//  Created by Dima Shikhalev on 09.08.2022.
//

import UIKit

class HabitsViewController: UIViewController {

    private lazy var layout = UICollectionViewFlowLayout()
    private lazy var habitsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    lazy var habits = HabitsStore.shared
    
    weak var delegate: ProgressCollectionCell?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemGray5
        setupViews()
        configure()
        setConstraints()
    }
    
    private func setupViews() {
        
        navigationItem.title = "Сегодня"
        navigationController?.navigationBar.prefersLargeTitles = true
        view.addSubview(habitsCollectionView)
        
        // navigationItem
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(pushToVCNavItem))
        navigationItem.rightBarButtonItem?.tintColor = .purple
    }
    
    private func configure() {
        
        layout.scrollDirection = .vertical
        habitsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        habitsCollectionView.delegate = self
        habitsCollectionView.dataSource = self
        habitsCollectionView.register(HabitCollectionCell.self, forCellWithReuseIdentifier: "habitsCell")
        habitsCollectionView.register(ProgressCollectionCell.self, forCellWithReuseIdentifier: "habitsCellZero")
        habitsCollectionView.backgroundColor = .systemGray5
    }
    
    //перезагрузка коллекции при добавлении новых привычек
    func reload() {
        habitsCollectionView.reloadData()
        delegate?.setProgress(habits: HabitsStore.shared.todayProgress)
    }
}

//MARK: tableView delegate and dataSourse
extension HabitsViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch section {
        case 0: return 1
        case 1: return habits.habits.count
        default: break
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 1 {
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "habitsCell", for: indexPath) as? HabitCollectionCell else {return UICollectionViewCell()}
            let dataSource = habits.habits[indexPath.row]
            cell.setViews(name: dataSource.name, nameColor: dataSource.color, date: dataSource.dateString, image: nil, imageColor: dataSource.color)
            cell.tag = indexPath.row
            cell.checkHabit()
            cell.setText(int: dataSource.trackDates.count)
            cell.layoutSubviews()
            cell.delegateHabit = self
            return cell
        } else if indexPath.section == 0 {
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "habitsCellZero", for: indexPath) as? ProgressCollectionCell else {return UICollectionViewCell()}
            delegate = cell
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        switch indexPath.section {
        case 0:
            // такое умножение идет, потому что такое соотношению в макетах в фигме длины ячейки к длине экрана и ширины к высоте. надо ведь адаптивную верстку
            let heightToWidth = habitsCollectionView.bounds.width * 1749 / 10000
            return CGSize(width: habitsCollectionView.bounds.width, height: heightToWidth)
        case 1:
            let heightToWidth = habitsCollectionView.bounds.width * 379 / 1000
           return CGSize(width: habitsCollectionView.bounds.width, height: heightToWidth)
        default: break
        }
        return CGSize(width: 0, height: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        if section == 0 {
            return 18
        } else {
            return 12
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 0 {
            return UIEdgeInsets(top: 0, left: 0, bottom: 18, right: 0)
        }
        return UIEdgeInsets()
    }
    
    // didSelect
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section > 0 {
            let newVC = HabitDetailsViewController()
            
            navigationController?.pushViewController(newVC, animated: true)
            newVC.setIndexPath(index: indexPath)
            newVC.habitsVCDelegate = self
        }
    }
}

//MARK: selectors
extension HabitsViewController {
    
    @objc private func pushToVCNavItem() {
        
        let newVC = HabitViewController()
        let navVC = UINavigationController(rootViewController: newVC)
        newVC.habitsDelegate = self
        //navigationController?.pushViewController(newVC, animated: true)
        navVC.title = "Create"
        self.navigationController?.present(navVC, animated: true)
    }
}

//MARK: constraints
extension HabitsViewController {
    
    private func setConstraints() {
        
        NSLayoutConstraint.activate([
        
            habitsCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            habitsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            habitsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -17),
            habitsCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

// обновление прогресса при добавлении новой привычки и трекирование действующей привычки
extension HabitsViewController {
    
    func setProgressNew(number: Float) {
        
        delegate?.setProgress(habits: number)
    }
}
