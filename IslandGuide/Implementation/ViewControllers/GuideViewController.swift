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
    
    private var showActivities: Bool = true
    private var shownSections: [GuideSection] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        
        addCollectionView()
        configureCollectionView()
    }
    
    @objc private func shuffleButtonPressed(_ sender: Any) {
        appData.cuteSeals.shuffle()
        updateSnapshot()
    }
    
    @objc private func aButtonPressed(_ sender: Any) {
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
        
        var snapshot = NSDiffableDataSourceSnapshot<GuideSection, GuideItem>()

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
                section = sself.makeSealsSectionDeclaration(environment: environment)
            }
            
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
            return section
            
        }, configuration: configuration)
        
        return layout
    }
    
    func makeSpotsSectionDeclaration() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let largeItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.4),
                                                   heightDimension: .fractionalHeight(1.0))
        let largeItem = NSCollectionLayoutItem(layoutSize: largeItemSize)
        
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
                                              heightDimension: .estimated(40))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .estimated(100)) // this value doesn't matter
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        group.interItemSpacing = NSCollectionLayoutSpacing.fixed(10)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 10
        
        return section
    }
    
    func makeSealsSectionDeclaration(environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let width: CGFloat = environment.traitCollection.horizontalSizeClass == .compact ? 150 : 250
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(width),
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
        
        collectionView.delegate = self // Set delegate before data source !!
        configureDiffableDataSource()
    }
    
    func configureNavigationBar() {
        title = "Island Guide"
        navigationItem.largeTitleDisplayMode = .always
        let shuffle = UIBarButtonItem(image: UIImage(systemName: "shuffle"), style: .plain, target: self, action: #selector(shuffleButtonPressed(_:)))
        let toggleActivities = UIBarButtonItem(image: UIImage(systemName: "a.circle"),  style: .plain, target: self, action: #selector(aButtonPressed(_:)))
        navigationItem.rightBarButtonItems = [shuffle, toggleActivities]
    }
}
