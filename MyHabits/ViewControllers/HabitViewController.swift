//
//  CreateHabitViewController.swift
//  MyHabits
//
//  Created by Dima Shikhalev on 10.08.2022.
//

import UIKit

class HabitViewController: UIViewController {
    
    private lazy var titleLabel = Footnote()
    private lazy var titleTextField = UITextField()
    private lazy var colorLabel = Footnote()
    private lazy var colorView = UIView()
    private lazy var timeLabel = Footnote()
    private lazy var timeInLabel = Body()
    private lazy var datePicker = UIDatePicker()
    private lazy var store = HabitsStore.shared
    private lazy var deleteHabitButton = UIButton()
    private lazy var scrollView = UIScrollView()
    
    lazy var indexPathForChange = IndexPath()

    weak var habitsDelegate: HabitsViewController?
    weak var backToRootVC: HabitDetailsViewController?


    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        setupViews()
        configure()
        setConstraints()
        setColorPicker()
        changeDataPicker()
        setNavigationBar()
        setChange()
        addDeleteFunction()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Я сделал, чтобы контент поднимался, но считаю, что он тут не нужен, так как в таком случае поле текстфилда уезжает далеко наверх и не видно, что мы вводим. A без нотификации клавиатура перекрывает пикер, на который нам все равно при вводе текста.
        
       // registerNotification()
    }
    
    private func setupViews() {
        
        view.addSubview(scrollView)
        scrollView.addSubview(titleLabel)
        scrollView.addSubview(titleTextField)
        scrollView.addSubview(colorLabel)
        scrollView.addSubview(colorView)
        scrollView.addSubview(timeLabel)
        scrollView.addSubview(timeInLabel)
        scrollView.addSubview(datePicker)
        scrollView.addSubview(deleteHabitButton)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        colorView.layoutIfNeeded()
        colorView.layer.cornerRadius = colorView.frame.width / 2
    }
    
    private func configure() {
        
        titleLabel.text = "Название"
        titleTextField.placeholder = "Бегать по утрам, спать 8 часов и т.п."
        titleTextField.delegate = self
        colorLabel.text = "Цвет"
        timeLabel.text = "Время"
        deleteHabitButton.setTitle("Удалить привычку", for: .normal)
        deleteHabitButton.setTitleColor(.red, for: .normal)
        deleteHabitButton.titleLabel?.font = .systemFont(ofSize: 17)
        deleteHabitButton.titleLabel?.numberOfLines = 1
        
        // translatesAutoresizingMaskIntoConstraints
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        colorLabel.translatesAutoresizingMaskIntoConstraints = false
        colorView.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        timeInLabel.translatesAutoresizingMaskIntoConstraints = false
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        deleteHabitButton.translatesAutoresizingMaskIntoConstraints = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        // datePicker
        datePicker.datePickerMode = .time
        datePicker.preferredDatePickerStyle = .wheels
        
        // barButtonItem
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Сохранить", style: .done, target: self, action: #selector(createHabit))
        navigationItem.rightBarButtonItem?.tintColor = .systemPurple
    }
    
    private func setNavigationBar() {
        
        navigationItem.title = "Создать"
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Сохранить", style: .done, target: self, action: #selector(createHabit))
        navigationItem.rightBarButtonItem?.tintColor = .systemPurple
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Отменить", style: .done, target: self, action: #selector(cancel))
        navigationItem.leftBarButtonItem?.tintColor = .systemPurple
    }
    
    @objc private func createHabit() {
        
        guard let text = titleTextField.text else { return }
      //  let name = titleTextField.text ?? ""
        let date = datePicker.date
        let color = colorView.backgroundColor ?? .black
        let newHabit = Habit(name: text, date: date, color: color)
        store = HabitsStore.shared
        
        if text.isEmpty {
            
            let alertController = UIAlertController(title: "Ошибка", message: "Необходимо ввести название привычки", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ввести", style: .default) { _ in
                self.titleTextField.becomeFirstResponder()
            }
            alertController.addAction(action)
            present(alertController, animated: true, completion: nil)
      
        } else {
            if !isEditing {
                store.habits.append(newHabit)
                
                // вариант, если бы мы контроллеp пушили, а не презентили
        //        guard let VC = navigationController!.viewControllers.first as? HabitsViewController else {return}
        //        VC.reload()
                //navigationController?.popViewController(animated: true)
                
                habitsDelegate?.reload()
                dismiss(animated: true, completion: nil)
            } else {
                
                store.habits[indexPathForChange.row].name = text
                store.habits[indexPathForChange.row].date = date
                store.habits[indexPathForChange.row].color = color
                
                habitsDelegate?.reload()
                dismiss(animated: true) {
                    self.backToRootVC?.backToRootVC()
                }
            }
        }
    }
    
    @objc private func cancel() {
        
        dismiss(animated: true, completion: nil)
    }
}

//MARK: HabitDetailsViewControllerDelegate
extension HabitViewController {
    
    func setChange() {
        
        if isEditing {
            
            let habit = HabitsStore.shared.habits[indexPathForChange.row]
            titleTextField.text = habit.name
            datePicker.date = habit.date
            colorView.backgroundColor = habit.color
            deleteHabitButton.isHidden = false
            deleteHabitButton.isEnabled = true
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            timeInLabel.text = "Каждый день в \(formatter.string(from: datePicker.date))"
        } else {
            colorView.backgroundColor = .systemBlue
            timeInLabel.text = "Каждый день в "
            deleteHabitButton.isHidden = true
        }
    }
}

//MARK: colorPicker
extension HabitViewController: UIColorPickerViewControllerDelegate {
    
    private func setColorPicker() {
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(callColorPicker))
        
        colorView.addGestureRecognizer(gesture)
    }
    
    @objc private func callColorPicker() {
        
        let colorPickerVC = UIColorPickerViewController()
        colorPickerVC.title = "Выбери цвет"
        colorPickerVC.delegate = self
        present(colorPickerVC, animated: true, completion: nil)
    }
    
    func colorPickerViewController(_ viewController: UIColorPickerViewController, didSelect color: UIColor, continuously: Bool) {
        colorView.backgroundColor = viewController.selectedColor
    }
}

//MARK: datePicker
extension HabitViewController {
    
    private func changeDataPicker() {
        
        datePicker.addTarget(self, action: #selector(changeTimeInLabel(sender:)), for: .valueChanged)
    }
    
    @objc private func changeTimeInLabel(sender: UIDatePicker) {
        
        let formatter = DateFormatter()
        formatter.timeStyle = .short
         
        timeInLabel.text = "Каждый день в \(formatter.string(from: datePicker.date))"
        view.endEditing(true)
    }
}

//MARK: texfFieldDelegegate
extension HabitViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

//MARK: delete habit
extension HabitViewController {
    
    private func addDeleteFunction() {
        
        deleteHabitButton.addTarget(self, action: #selector(addDelete), for: .touchUpInside)
    }
    
    @objc private func addDelete() {
        
        let alertController = UIAlertController(title: "Удалить привычку?", message: "Вы хотите удалить привычку \(HabitsStore.shared.habits[indexPathForChange.row])?", preferredStyle: .alert)
        let cancelAlert = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        let deleteAlert = UIAlertAction(title: "Удалить", style: .destructive) { _ in
            HabitsStore.shared.habits.remove(at: self.indexPathForChange.row)
            self.habitsDelegate?.reload()
            self.dismiss(animated: true) {
                self.backToRootVC?.backToRootVC()
            }
        }
        
        alertController.addAction(cancelAlert)
        alertController.addAction(deleteAlert)
        present(alertController, animated: true, completion: nil)
    }
}

//MARK: notification
extension HabitViewController {
    
    private func registerNotification() {
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(kbWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(kbWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    @objc private func kbWillShow(_ notification: Notification) {
        let userInfo = notification.userInfo
        let kbFrame = (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        let loginButtonOriginY = datePicker.frame.origin.y + datePicker.frame.height
        let kbOriginY = scrollView.frame.height - kbFrame.height
        let offset = kbOriginY <= loginButtonOriginY ? loginButtonOriginY - kbOriginY + 16 : 0
        scrollView.contentOffset = CGPoint(x: 0, y: offset)
    }
    
    @objc private func kbWillHide() {
        
        scrollView.setContentOffset(.zero, animated: true)
    }
}
//MARK: Constraints
extension HabitViewController {
    
    private func setConstraints() {
        
        NSLayoutConstraint.activate([
        
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            titleLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 21),
            titleLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            titleLabel.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.297),

            titleTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 7),
            titleTextField.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 15),
            titleTextField.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -65),
            titleTextField.heightAnchor.constraint(equalToConstant: 22),

            colorLabel.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 15),
            colorLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            colorLabel.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.196),

            colorView.topAnchor.constraint(equalTo: colorLabel.bottomAnchor, constant: 7),
            colorView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 15),
            colorView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.08),
            colorView.heightAnchor.constraint(equalTo: colorView.widthAnchor),

            timeLabel.topAnchor.constraint(equalTo: colorView.bottomAnchor, constant: 15),
            timeLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            timeLabel.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.2253),

            timeInLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 7),
            timeInLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            timeInLabel.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.717),

            datePicker.topAnchor.constraint(equalTo: timeInLabel.bottomAnchor, constant: 15),
            datePicker.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 0),
            datePicker.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 1),
            datePicker.heightAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.576),
            
            deleteHabitButton.bottomAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.bottomAnchor, constant: -18),
            deleteHabitButton.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            deleteHabitButton.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.492),
            deleteHabitButton.heightAnchor.constraint(equalTo: deleteHabitButton.widthAnchor, multiplier: 0.149),
        ])
    }
}
