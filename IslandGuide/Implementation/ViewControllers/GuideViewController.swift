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
    private(set) var dataSource: UICollectionViewDiffableDataSource<GuideSection, UUID>! // retain data source!

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
        updateSnapshot()
    }
    
    @IBAction func aButtonPressed(_ sender: Any) {
    }
}

// MARK: - Collection View DataSource -

private extension GuideViewController {

    func configureDiffableDataSource() {
        
        let dataSource = UICollectionViewDiffableDataSource<GuideSection, UUID>(collectionView: collectionView) { [weak self] (collectionView: UICollectionView, indexPath: IndexPath, identifier: UUID) -> UICollectionViewCell? in

            guard let sself = self else {
                return nil // what to do? crash!
            }
            
            guard let guideSection = GuideSection(rawValue: indexPath.section) else {
                fatalError("Unexpected section in index path \(indexPath)")
            }
            
            switch guideSection {
            case .coolSpots:
                let cell = collectionView.dequeueCell(ofType: CoolSpotCollectionViewCell.self, for: indexPath)
                cell.fillWithData(sself.appData.coolSpots[indexPath.row])
                return cell
                
            case .funActivities:
                let cell = collectionView.dequeueCell(ofType: FunActivityCollectionViewCell.self, for: indexPath)
                cell.fillWithData(sself.appData.funActivities[indexPath.row])
                return cell
                
            case .cuteSeals:
                let cell = collectionView.dequeueCell(ofType: CuteSealCollectionViewCell.self, for: indexPath)
                cell.fillWithData(sself.appData.cuteSeals[indexPath.row])
                return cell
            }
        }
        
        self.dataSource = dataSource

        updateSnapshot()
    }
    
    func updateSnapshot() {
        
        let snapshot = NSDiffableDataSourceSnapshot<GuideSection, UUID>()

        snapshot.appendSections(GuideSection.allCases)
        snapshot.appendItems(appData.coolSpots.map({ $0.id }), toSection: .coolSpots)
        snapshot.appendItems(appData.funActivities.map({ $0.id }), toSection: .funActivities)
        snapshot.appendItems(appData.cuteSeals.map({ $0.id }), toSection: .cuteSeals)
        dataSource.apply(snapshot)
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
        
        collectionView.delegate = self // Set delegate before data source !!
        configureDiffableDataSource()
    }
}
