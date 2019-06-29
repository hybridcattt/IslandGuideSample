//
//  StarSupplementaryView.swift
//  IslandGuide
//
//  Created by Marina Gornostaeva on 03/07/2019.
//  Copyright © 2019 SwiftIsland. All rights reserved.
//

import UIKit

class StarSupplementaryView: UICollectionReusableView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.configureUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI() {
        let imageView = UIImageView(image: UIImage(systemName: "star.circle"))
        addSubview(imageView)
        imageView.frame = bounds
        imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        imageView.tintColor = .systemYellow
    }
}

class CheckmarkSupplementaryView: UICollectionReusableView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.configureUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI() {
        let imageView = UIImageView(image: UIImage(systemName: "checkmark.circle"))
        addSubview(imageView)
        imageView.frame = bounds
        imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        imageView.tintColor = .systemPink
    }
}
