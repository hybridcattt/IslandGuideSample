//
//  GuideViewController.swift
//  IslandGuide
//
//  Created by Marina Gornostaeva on 29/06/2019.
//  Copyright © 2019 SwiftIsland. All rights reserved.
//

import UIKit

// MARK: - View Controller Lifecycle -

class GuideViewController: UIViewController {

    enum GuideSection: Int, CaseIterable {
        case coolSpots = 0
        case funActivities = 1
        case cuteSeals = 2
    }
    
    private(set) var collectionView: UICollectionView!

    private(set) var appData: AppData = AppData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addCollectionView()
        configureCollectionView()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        collectionView.collectionViewLayout.invalidateLayout()
        collectionView.layoutIfNeeded()
    }
    
    @IBAction func shuffleButtonPressed(_ sender: Any) {
        appData.cuteSeals.shuffle()
        collectionView.reloadData()
    }
    
    @IBAction func aButtonPressed(_ sender: Any) {
    }
}

// MARK: - Collection View DataSource -

extension GuideViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return GuideSection.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        guard let guideSection = GuideSection(rawValue: section) else {
            fatalError("Unexpected section \(section)")
        }
        
        switch guideSection {
        case .coolSpots:
            return appData.coolSpots.count
        case .funActivities:
            return appData.funActivities.count
        case .cuteSeals:
            return appData.cuteSeals.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let guideSection = GuideSection(rawValue: indexPath.section) else {
            fatalError("Unexpected section in index path \(indexPath)")
        }
        
        switch guideSection {
        case .coolSpots:
            let cell = collectionView.dequeueCell(ofType: CoolSpotCollectionViewCell.self, for: indexPath)
            cell.fillWithData(appData.coolSpots[indexPath.row])
            return cell
            
        case .funActivities:
            let cell = collectionView.dequeueCell(ofType: FunActivityCollectionViewCell.self, for: indexPath)
            cell.fillWithData(appData.funActivities[indexPath.row])
            return cell
            
        case .cuteSeals:
            let cell = collectionView.dequeueCell(ofType: CuteSealCollectionViewCell.self, for: indexPath)
            cell.fillWithData(appData.cuteSeals[indexPath.row])
            return cell
        }
    }
}

// MARK: - Collection View Layout -

private extension GuideViewController {
    
    func makeCollectionViewLayout() -> UICollectionViewLayout {
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 10
        flowLayout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 20, right: 10)
        flowLayout.minimumInteritemSpacing = 10
        return flowLayout
    }
}

// MARK: - Collection View Delegate -

extension GuideViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        guard let guideSection = GuideSection(rawValue: indexPath.section) else {
            fatalError("Unexpected section in index path \(indexPath)")
        }

        guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else {
            fatalError("Wrong layout, got \(collectionViewLayout)")
        }

        let width = (collectionView.bounds.size.width - flowLayout.sectionInset.left - flowLayout.sectionInset.right - flowLayout.minimumInteritemSpacing) / 2
        switch guideSection {
        case .coolSpots:
            return CGSize(width: width, height: 50)
        case .funActivities:
            return CGSize(width: width, height: 130)
        case .cuteSeals:
            return CGSize(width: width, height: 70)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cell.contentView.backgroundColor = UIColor.systemGray6
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
    }
}

// MARK: - Basic UI -

private extension GuideViewController {
    
    func addCollectionView() {
        
        let layout = makeCollectionViewLayout()
        
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.alwaysBounceVertical = true
        collectionView.contentInset.top = 20
        
        view.addSubview(collectionView)
        
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    func configureCollectionView() {
        
        collectionView.registerCell(ofType: CoolSpotCollectionViewCell.self)
        collectionView.registerCell(ofType: FunActivityCollectionViewCell.self)
        collectionView.registerCell(ofType: CuteSealCollectionViewCell.self)
        
        collectionView.dataSource = self
        collectionView.delegate = self
    }
}
