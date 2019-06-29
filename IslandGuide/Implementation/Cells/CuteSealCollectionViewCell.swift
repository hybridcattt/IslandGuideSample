//
//  FunActivityCollectionViewCell.swift
//  IslandGuide
//
//  Created by Marina Gornostaeva on 29/06/2019.
//  Copyright © 2019 SwiftIsland. All rights reserved.
//

import UIKit

class CuteSealCollectionViewCell: UICollectionViewCell {

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

extension CuteSealCollectionViewCell {
    
    func fillWithData(_ data: Seal) {
        titleLabel.text = data.name
        imageView.image = UIImage(named: data.imageName)
    }
}

// MARK: - UI -

private extension CuteSealCollectionViewCell {
    
    func configureUI() {
        
        // Styling
        
        titleLabel.textAlignment = .natural
        titleLabel.font = .preferredFont(forTextStyle: .body)
        
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .systemPink
        imageView.layer.cornerRadius = 5
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        
        let stackView = UIStackView(arrangedSubviews: [imageView, titleLabel])
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.spacing = 10

        // Layout
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        let container = self.contentView
        
        container.addSubview(stackView)
        
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
        imageView.heightAnchor.constraint(equalTo: stackView.heightAnchor).isActive = true
        
        stackView.leadingAnchor.constraint(equalTo: container.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: container.trailingAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: container.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: container.bottomAnchor).isActive = true
    }
}
