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

    enum GuideSection: CaseIterable {
        case coolSpots
        case funActivities
        case cuteSeals
    }
    
    enum GuideItem: Hashable {
        case coolSpot(Spot)
        case funActivity(Activity)
        case cuteSeal(Seal)
    }
    
    private(set) var collectionView: UICollectionView!
    private(set) var dataSource: UICollectionViewDiffableDataSource<GuideSection, GuideItem>! // retain data source!

    private(set) var appData: AppData = AppData()
    
    private var showActivities: Bool = false
    private var shownSections: [GuideSection] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addCollectionView()
        configureCollectionView()
    }
    
    @IBAction func shuffleButtonPressed(_ sender: Any) {
        appData.cuteSeals.shuffle()
        updateSnapshot()
    }
    
    @IBAction func aButtonPressed(_ sender: Any) {
        showActivities.toggle()
        updateSnapshot()
    }
}

// MARK: - Collection View DataSource -

private extension GuideViewController {

    func configureDiffableDataSource() {
        
        let dataSource = UICollectionViewDiffableDataSource<GuideSection, GuideItem>(collectionView: collectionView) { (collectionView: UICollectionView, indexPath: IndexPath, item: GuideItem) -> UICollectionViewCell? in
            
            switch item {
            case .coolSpot(let spot):
                let cell = collectionView.dequeueCell(ofType: CoolSpotCollectionViewCell.self, for: indexPath)
                cell.fillWithData(spot)
                return cell
                
            case .funActivity(let activity):
                let cell = collectionView.dequeueCell(ofType: FunActivityCollectionViewCell.self, for: indexPath)
                cell.fillWithData(activity)
                return cell
                
            case .cuteSeal(let seal):
                let cell = collectionView.dequeueCell(ofType: CuteSealCollectionViewCell.self, for: indexPath)
                cell.fillWithData(seal)
                return cell
            }
        }
        
        self.dataSource = dataSource

        updateSnapshot(animated: false)
    }
    
    func updateSnapshot(animated: Bool = true) {
        
        let snapshot = NSDiffableDataSourceSnapshot<GuideSection, GuideItem>()

        snapshot.appendSections([.coolSpots])
        snapshot.appendItems(appData.coolSpots.map({ GuideItem.coolSpot($0) }))
        
        if showActivities {
            snapshot.appendSections([.funActivities])
            snapshot.appendItems(appData.funActivities.map({ GuideItem.funActivity($0) }))
        }
        
        snapshot.appendSections([.cuteSeals])
        snapshot.appendItems(appData.cuteSeals.map({ GuideItem.cuteSeal($0) }))
        
        shownSections = snapshot.sectionIdentifiers
        
        dataSource.apply(snapshot, animatingDifferences: animated)
    }
}

// MARK: - Collection View Layout -

private extension GuideViewController {

    func makeCompositionalLayout() -> UICollectionViewLayout {
        let section = makeSectionDeclaration()
        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        configuration.interSectionSpacing = 20
        
        let layout = UICollectionViewCompositionalLayout(section: section, configuration: configuration)
        return layout
    }
    
    func makeSectionDeclaration() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(100))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        
        group.interItemSpacing = NSCollectionLayoutSpacing.fixed(10)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 10
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
        
        return section
    }
}

// MARK: - Collection View Delegate -

extension GuideViewController: UICollectionViewDelegate {
    
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
        
        let layout = makeCompositionalLayout()
        
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
