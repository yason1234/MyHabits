//
//  HabitDetailsTableCell.swift
//  MyHabits
//
//  Created by Dima Shikhalev on 17.08.2022.
//

import UIKit

class HabitDetailsTableCell: UITableViewCell {

    private lazy var checkImage = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configure()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        
        self.contentView.addSubview(checkImage)
        checkImage.translatesAutoresizingMaskIntoConstraints = false
        checkImage.contentMode = .scaleAspectFit
        checkImage.image = UIImage(named: "check")
        checkImage.isHidden = true
    }
    
    func checkTracking(habit: Habit, date: Date) {
        
//        HabitsStore.shared.habit(habit, isTrackedIn: date) ? checkImage.image = UIImage(named: "check") : print("Not Checked")
        if HabitsStore.shared.habit(habit, isTrackedIn: date) {
            checkImage.isHidden.toggle()
        }
    }
}

extension HabitDetailsTableCell {
    
    private func setConstraints() {
        
        NSLayoutConstraint.activate([
            checkImage.topAnchor.constraint(equalTo: self.topAnchor),
            checkImage.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            checkImage.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -14),
            checkImage.heightAnchor.constraint(equalTo: checkImage.widthAnchor, multiplier: 2)
        ])
    }
}
