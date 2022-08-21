//
//  HabitTableCell.swift
//  MyHabits
//
//  Created by Dima Shikhalev on 10.08.2022.
//

import UIKit

protocol HabitCollectionCellDelegate {
    func setProgress(habits: Float)
}

class HabitCollectionCell: UICollectionViewCell {
    
    private lazy var nameHabitLabel = UILabel()
    private lazy var dateHabitLabel = UILabel()
    private lazy var countHabitLabel = UILabel()
    private lazy var doneImage = UIImageView()
    
    weak var delegateHabit: HabitsViewController?

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
        setupViews()
        configure()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupViews() {
        
        contentView.addSubview(nameHabitLabel)
        contentView.addSubview(dateHabitLabel)
        contentView.addSubview(countHabitLabel)
        contentView.addSubview(doneImage)
    }
    
    private func configure() {
        
        // name
        nameHabitLabel.translatesAutoresizingMaskIntoConstraints = false
        nameHabitLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        nameHabitLabel.numberOfLines = 0
        
        // date
        dateHabitLabel.translatesAutoresizingMaskIntoConstraints = false
        dateHabitLabel.font = .systemFont(ofSize: 12, weight: .regular)
        dateHabitLabel.textColor = .systemGray2
        
        // count
        countHabitLabel.translatesAutoresizingMaskIntoConstraints = false
        countHabitLabel.font = .systemFont(ofSize: 13, weight: .regular)
        countHabitLabel.textColor = .systemGray
        countHabitLabel.text = "Счетчик: "
        
        // image
        doneImage.translatesAutoresizingMaskIntoConstraints = false
        doneImage.layer.borderWidth = 2
        doneImage.contentMode = .scaleToFill
        doneImage.clipsToBounds = true
    }
    
    func setViews(name: String?, nameColor: UIColor?, date: String?, image: String?, imageColor: UIColor) {
        
        nameHabitLabel.text = name
        nameHabitLabel.textColor = nameColor
        dateHabitLabel.text = date
        
        doneImage.layer.borderColor = imageColor.cgColor
        guard let image1 = image else { return }
        doneImage.image = UIImage(systemName: image1)
        
        if image != nil {
            doneImage.backgroundColor = imageColor
        }
    }
    
    func setText(int: Int) {
        countHabitLabel.text! = "Счетчик: \(int)"
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layoutIfNeeded()
        self.layer.cornerRadius = 8
        doneImage.layer.cornerRadius = doneImage.frame.width / 2
        
        let habit = HabitsStore.shared.habits[tag]
        if habit.isAlreadyTakenToday {
            doneImage.backgroundColor = nameHabitLabel.textColor
            doneImage.image = UIImage(systemName: "checkmark")
            doneImage.tintColor = .white
        } else {
            doneImage.backgroundColor = .white
        }
    }
}

//MARK: gesture
extension HabitCollectionCell {
    
    func checkHabit(    ) {
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(addGesture))
        doneImage.addGestureRecognizer(gesture)
        doneImage.isUserInteractionEnabled = true
    }
    
    @objc private func addGesture() {
        
        let habit = HabitsStore.shared.habits[tag]
        if !habit.isAlreadyTakenToday {
            HabitsStore.shared.track(habit)
            let progress = HabitsStore.shared.todayProgress
            doneImage.backgroundColor = nameHabitLabel.textColor
            doneImage.image = UIImage(systemName: "checkmark")
            doneImage.tintColor = .white
            doneImage.contentMode = .scaleAspectFit
            countHabitLabel.text = "Счётчик: \(habit.trackDates.count)"
            delegateHabit?.setProgressNew(number: progress)
        }
    }
}

extension HabitCollectionCell {
    
    private func setConstraints() {
        
        NSLayoutConstraint.activate([
        
            nameHabitLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            nameHabitLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            nameHabitLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.6413),
            
            dateHabitLabel.topAnchor.constraint(equalTo: nameHabitLabel.bottomAnchor, constant: 4),
            dateHabitLabel.leadingAnchor.constraint(equalTo: nameHabitLabel.leadingAnchor),

            countHabitLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20),
            countHabitLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),

            doneImage.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            doneImage.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -25),
            doneImage.widthAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.292),
            doneImage.heightAnchor.constraint(equalTo: doneImage.widthAnchor)
        ])
    }
}
