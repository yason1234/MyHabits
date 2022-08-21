//
//  Title 3.swift
//  MyHabits
//
//  Created by Dima Shikhalev on 10.08.2022.
//

import UIKit

class title3Label: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        
        font = .systemFont(ofSize: 20, weight: .semibold)
        translatesAutoresizingMaskIntoConstraints = false
        textColor = .black
    }
}
