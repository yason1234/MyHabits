//
//  InfoViewController.swift
//  MyHabits
//
//  Created by Dima Shikhalev on 20.08.2022.
//

import UIKit

class InfoViewController: UIViewController {

    private lazy var titleLabel = title3Label()
    private lazy var infoLabel = Body()
    private lazy var scrollView = UIScrollView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        configure()
        setConstraints()
    }
    
    private func setupViews() {
        
        navigationController?.navigationBar.backgroundColor = UIColor(displayP3Red: 249, green: 249, blue: 249, alpha: 0.94)
        navigationItem.title = "Информация"
        view.addSubview(scrollView)
        scrollView.addSubview(titleLabel)
        scrollView.addSubview(infoLabel)
        view.backgroundColor = .white
    }
    
    private func configure() {
        
        // title
        titleLabel.text = "Привычка за 21 день"
        // info
        infoLabel.text = Text.text
        infoLabel.numberOfLines = 0
        //trans
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
    }
}

//MARK: constraints
extension InfoViewController {
    
    private func setConstraints() {
        
        NSLayoutConstraint.activate([
        
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.widthAnchor.constraint(equalTo: view.widthAnchor),

            titleLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 22),
            titleLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            titleLabel.heightAnchor.constraint(equalTo: titleLabel.widthAnchor, multiplier: 0.11),
            
            infoLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            infoLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            infoLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            infoLabel.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
    }
}
