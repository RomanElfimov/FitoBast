//
//  Temps.swift
//  PhytoBast
//
//  Created by Роман Елфимов on 18.04.2022.
//

import Foundation
import UIKit
/*

class TempsViewController: UIViewController {
    
    enum SectionKind: Int, CaseIterable {
        case list, grid
        var columnCount: Int {
            switch self {
            case .list:
                return 2
            case .grid:
                return 3
            }
        }
    }
    
    var dataSource: UICollectionViewDiffableDataSource<SectionKind, Int>! = nil
    private var collectionView: UICollectionView! = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        setupCollectionView()
        title = "Templates"
    }
    

    private func setupCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .white
        view.addSubview(collectionView)
        
        collectionView.register(UserCell.self, forCellWithReuseIdentifier: "UserCell")
        collectionView.register(GridCell.self, forCellWithReuseIdentifier: "GridCell")
        
        setupDataSource()
        reloadData()
    }
    
    
    private func setupDataSource() {
        dataSource = UICollectionViewDiffableDataSource<SectionKind, Int>(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let section = SectionKind(rawValue: indexPath.section)!
            switch section {
            case .list:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserCell", for: indexPath) as! UserCell
                return cell
            case .grid:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GridCell", for: indexPath) as! GridCell
                return cell
            }
        })
    }
    
    func reloadData() {
        var snapshot = NSDiffableDataSourceSnapshot<SectionKind, Int>()
        let itemsPerSection = 50
        SectionKind.allCases.forEach { sectionKind in
            let itemOffSet = sectionKind.columnCount * itemsPerSection
            let itemUpperbound = itemOffSet + itemsPerSection
            snapshot.appendSections([sectionKind])
            snapshot.appendItems(Array(itemOffSet..<itemUpperbound))
        }
        
        dataSource.apply(snapshot, animatingDifferences: false)
    }
  
    
    private func createListSection() -> NSCollectionLayoutSection {
        
        // item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1.0)) // 0.2 от всей ширины группы, высота как группа
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        
        // groups
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.1))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        group.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
//        group.interItemSpacing = .fixed(10)
        
        
        // section
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10) // отступы
           
        return section
    }
    
    
    private func createGridSection() -> NSCollectionLayoutSection {
        
        // item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(144)) // 0.2 от всей ширины группы, высота как группа
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        
        // groups
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        group.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
//        group.interItemSpacing = .fixed(10)
        
        
        // section
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10) // отступы
        section.orthogonalScrollingBehavior = .continuous
           
        return section
    }
    
    
    private func createLayout() -> UICollectionViewLayout {
        
        
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            let section = SectionKind(rawValue: sectionIndex)!
            switch section {
            case .list:
                return self.createListSection()
            case .grid:
                return self.createGridSection()
            }
        }
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 100
        layout.configuration = config
        
        return layout
    }

}



extension TemplatesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        cell.backgroundColor = .green
        cell.layer.borderWidth = 1
        return cell
    }
}

*/
