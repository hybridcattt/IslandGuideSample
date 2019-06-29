//
//  FunActivityCollectionViewCell.swift
//  IslandGuide
//
//  Created by Marina Gornostaeva on 29/06/2019.
//  Copyright © 2019 SwiftIsland. All rights reserved.
//

import UIKit

class FunActivityCollectionViewCell: UICollectionViewCell {
    
    let titleLabel: UILabel = UILabel()
    let descriptionLabel: UILabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.configureUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Data -

extension FunActivityCollectionViewCell {
    
    func fillWithData(_ data: Activity) {
        titleLabel.text = data.title
        descriptionLabel.text = data.description
    }
}

// MARK: - UI -

private extension FunActivityCollectionViewCell {
    
    func configureUI() {
        
        // Styling
        
        titleLabel.textAlignment = .natural
        titleLabel.font = UIFont(descriptor: UIFont.preferredFont(forTextStyle: .title3).fontDescriptor.withSymbolicTraits(.traitBold)!, size: 0)
        titleLabel.textColor = .systemPurple
        
        descriptionLabel.textAlignment = .natural
        descriptionLabel.font = .preferredFont(forTextStyle: .subheadline)
        descriptionLabel.numberOfLines = 0
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, descriptionLabel])
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 5
                
        // Layout
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        let container = self.contentView
        
        container.addSubview(stackView)
        
        stackView.leadingAnchor.constraint(equalTo: container.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: container.trailingAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: container.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(lessThanOrEqualTo: container.bottomAnchor).isActive = true
    }
}
