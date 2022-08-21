//
//  FOOTNOTE.swift
//  MyHabits
//
//  Created by Dima Shikhalev on 10.08.2022.
//

import UIKit

class Footnote: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        
        font = .systemFont(ofSize: 13, weight: .semibold)
        translatesAutoresizingMaskIntoConstraints = false
        textColor = .black
    }
}
