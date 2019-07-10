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
    
    enum SupplementaryItemKind: String {
        case star
        case checkmark
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
        
        dataSource.supplementaryViewProvider = { (collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView? in
            
            guard let supplementaryItemKind = SupplementaryItemKind(rawValue: kind) else {
                return nil
            }

            switch supplementaryItemKind {
            case .checkmark:
                let view = collectionView.dequeueReusableView(ofType: CheckmarkSupplementaryView.self, forKind: supplementaryItemKind.rawValue, for: indexPath)
                view.backgroundColor = .red
                return view
            case .star:
                let view = collectionView.dequeueReusableView(ofType: StarSupplementaryView.self, forKind: supplementaryItemKind.rawValue, for: indexPath)
                view.backgroundColor = .green
                return view
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
        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        configuration.interSectionSpacing = 20
        
        let layout = UICollectionViewCompositionalLayout(sectionProvider: { [weak self] (sectionIndex: Int, environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            guard let sself = self else {
                return nil
            }
            
            let guideSection = sself.shownSections[sectionIndex]
            
            let section: NSCollectionLayoutSection
            switch guideSection {
            case .coolSpots:
                section = sself.makeSpotsSectionDeclaration()
            case .funActivities:
                section = sself.makeActivitiesSectionDeclaration()
            case .cuteSeals:
                section = sself.makeSealsSectionDeclaration()
            }
            
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
            return section
            
        }, configuration: configuration)
        
        return layout
    }
    
    func makeSpotsSectionDeclaration() -> NSCollectionLayoutSection {
        
        let supplementaryItemSize = NSCollectionLayoutSize(
            widthDimension: .absolute(20),
            heightDimension: .absolute(20)
        )
        
        let leadingSupplementaryItem = NSCollectionLayoutSupplementaryItem(
            layoutSize: supplementaryItemSize,
            elementKind: SupplementaryItemKind.checkmark.rawValue,
            containerAnchor: .init(
                edges: [.top, .leading],
                fractionalOffset: CGPoint(x: 0.1, y: 0.1)
            )
        )
        
        let trailingSupplementaryItem = NSCollectionLayoutSupplementaryItem(
            layoutSize: supplementaryItemSize,
            elementKind: SupplementaryItemKind.star.rawValue,
            containerAnchor: .init(
                edges: [.top, .trailing],
                fractionalOffset: CGPoint(x: -0.1, y: 0.1)
            )
        )
        
        leadingSupplementaryItem.zIndex = 101 // has no effect on beta3?
        trailingSupplementaryItem.zIndex = 102 // has no effect on beta3?

        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))

        let item = NSCollectionLayoutItem(layoutSize: itemSize, supplementaryItems: [leadingSupplementaryItem, trailingSupplementaryItem])
        
        let largeItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.4),
                                                   heightDimension: .fractionalHeight(1.0))
        let largeItem = NSCollectionLayoutItem(layoutSize: largeItemSize, supplementaryItems: [])

        //        let largeItem = NSCollectionLayoutItem(layoutSize: largeItemSize, supplementaryItems: [leadingSupplementaryItem, trailingSupplementaryItem])
        // Specifying supplementary items with same identifiers is not allowed :'(
        
        let groupOf2Size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.58),
                                                  heightDimension: .fractionalHeight(1.0))
        let groupOf2 = NSCollectionLayoutGroup.vertical(layoutSize: groupOf2Size, subitem: item, count: 2)
        groupOf2.interItemSpacing = .fixed(10)
        
        let groupOf3Size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let groupOf3 = NSCollectionLayoutGroup.horizontal(layoutSize: groupOf3Size, subitems: [largeItem, groupOf2])
        groupOf3.interItemSpacing = .flexible(0)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.8),
                                               heightDimension: .absolute(200))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: groupOf3, count: 1)
        
        group.interItemSpacing = NSCollectionLayoutSpacing.fixed(10)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 10
        section.orthogonalScrollingBehavior = .groupPagingCentered
        
        return section
    }
    
    func makeActivitiesSectionDeclaration() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(100))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        
        group.interItemSpacing = NSCollectionLayoutSpacing.fixed(10)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 10

        return section
    }
    
    func makeSealsSectionDeclaration() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(150),
                                               heightDimension: .absolute(200))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 3)
        
        group.interItemSpacing = NSCollectionLayoutSpacing.fixed(10)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 10
        
        section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
        
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
        
        collectionView.registerReusableView(ofType: StarSupplementaryView.self, forKind: SupplementaryItemKind.star.rawValue)
        collectionView.registerReusableView(ofType: CheckmarkSupplementaryView.self, forKind: SupplementaryItemKind.checkmark.rawValue)

        collectionView.delegate = self // Set delegate before data source !!
        configureDiffableDataSource()
    }
}
