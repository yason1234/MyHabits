//
//  HabitCollectionCellSecond.swift
//  MyHabits
//
//  Created by Dima Shikhalev on 10.08.2022.
//

import UIKit

class ProgressCollectionCell: UICollectionViewCell, HabitCollectionCellDelegate {
    
    private lazy var dontGiveUpLabel = UILabel()
    private lazy var progressView = UIProgressView()
    private lazy var statusLabel = UILabel()
            
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
        setupViews()
        configure()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = 8
        progressView.layer.cornerRadius = 5
    }
    
    private func setupViews() {
        
        contentView.addSubview(dontGiveUpLabel)
        contentView.addSubview(statusLabel)
        contentView.addSubview(progressView)
        setProgress(habits: HabitsStore.shared.todayProgress)
    }
    
    private func configure() {
        
        dontGiveUpLabel.translatesAutoresizingMaskIntoConstraints = false
        dontGiveUpLabel.text = "Всё получится!"
        dontGiveUpLabel.font = .systemFont(ofSize: 13, weight: .semibold)
        dontGiveUpLabel.textColor = .systemGray
        
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        statusLabel.font = .systemFont(ofSize: 13, weight: .semibold)
        statusLabel.textColor = .systemGray
        statusLabel.textAlignment = .right
        
        progressView.trackTintColor = .systemGray
        progressView.progressTintColor = .systemPurple
        progressView.progressViewStyle = .bar
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.clipsToBounds = true
    }
    
    func setProgress(habits: Float) {
      
        progressView.setProgress(habits, animated: true)
        statusLabel.text = String(Int(habits * 100)) + "%"
    }
}

extension ProgressCollectionCell {
    
    private func setConstraints() {
        
        NSLayoutConstraint.activate([
        
            dontGiveUpLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            dontGiveUpLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 12),
            dontGiveUpLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.629),

            statusLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            statusLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -12),
            statusLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.2769),
            
            progressView.topAnchor.constraint(equalTo: dontGiveUpLabel.bottomAnchor, constant: 10),
            progressView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 12),
            progressView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -12),
            progressView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.1167)
        ])
    }
}
