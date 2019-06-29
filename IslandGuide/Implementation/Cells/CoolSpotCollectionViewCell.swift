//
//  CoolSpotCollectionViewCell.swift
//  IslandGuide
//
//  Created by Marina Gornostaeva on 29/06/2019.
//  Copyright © 2019 SwiftIsland. All rights reserved.
//

import UIKit

class CoolSpotCollectionViewCell: UICollectionViewCell {

    let titleLabel: UILabel = UILabel()
    let imageView: UIImageView = UIImageView()

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

extension CoolSpotCollectionViewCell {
    
    func fillWithData(_ data: Spot) {
        titleLabel.text = data.title
        imageView.image = UIImage(named: data.imageName)
    }
}

// MARK: - UI -

private extension CoolSpotCollectionViewCell {
    
    func configureUI() {
        
        // Styling
        
        contentView.layer.cornerRadius = 5
        contentView.clipsToBounds = true
        
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 2
        titleLabel.font = UIFont(descriptor: UIFont.preferredFont(forTextStyle: .title2).fontDescriptor.withSymbolicTraits(.traitBold)!, size: 0)
        
        titleLabel.textColor = .white

        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .systemTeal
        
        // Layout
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        let container = self.contentView
        
        container.addSubview(imageView)
        container.addSubview(titleLabel)

        titleLabel.leadingAnchor.constraint(equalTo: container.layoutMarginsGuide.leadingAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: container.layoutMarginsGuide.trailingAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: container.layoutMarginsGuide.topAnchor).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: container.layoutMarginsGuide.bottomAnchor).isActive = true
        titleLabel.insetsLayoutMarginsFromSafeArea = false
        
        imageView.leadingAnchor.constraint(equalTo: container.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: container.trailingAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: container.topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: container.bottomAnchor).isActive = true
    }
}
