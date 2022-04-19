//
//  TemplatesViewController.swift
//  PhytoBast
//
//  Created by Роман Елфимов on 12.04.2022.
//

import UIKit

// MARK: - Section Type Enum

enum SectionType: Int, CaseIterable {
    case defaultTemplates
    case manualTemplates
    
    func description() -> String {
        switch self {
        case .defaultTemplates:
            return "Стандартные шаблоны"
        case .manualTemplates:
            return "Мои шаблоны"
        }
    }
}


// MARK: - ViewController

class TemplatesViewController: UIViewController {
    
    // MARK: - Properties
    
    private var defaultTemplatesDataSourceArray: [TemplatesModel] = [TemplatesModel(title: "df"), TemplatesModel(title: "dfss"), TemplatesModel(title: "2"), TemplatesModel(title: "1")]
    private var manualTemplatesDataSourceArray: [TemplatesModel] = [TemplatesModel(title: "dfqq"), TemplatesModel(title: "dfccv"), TemplatesModel(title: "3"), TemplatesModel(title: "4"), TemplatesModel(title: "5"), TemplatesModel(title: "6")]
    
    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<SectionType, TemplatesModel>?

    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupCollectionView()
        createDataSource()
        reloadData()
    }
    
    
    // MARK: - Private Methods
    
    private func setupCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionalLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .white
        view.addSubview(collectionView)
        
        collectionView.register(TemplatesHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TemplatesHeader.reuseId)
        collectionView.register(DefaultTemplatesCell.self, forCellWithReuseIdentifier: DefaultTemplatesCell.reuseId)
        collectionView.register(ManualTemplatesCell.self, forCellWithReuseIdentifier: ManualTemplatesCell.reuseId)
    }
}



// MARK: - Setup DiffableDataSource

extension TemplatesViewController {
    
    private func createDataSource() {
        dataSource = UICollectionViewDiffableDataSource<SectionType, TemplatesModel>(collectionView: collectionView, cellProvider: { collectionView, indexPath, template in
            
            guard let section = SectionType(rawValue: indexPath.section) else { return nil }
            
            switch section {
            case .defaultTemplates:
                
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DefaultTemplatesCell.reuseId, for: indexPath) as? DefaultTemplatesCell else { return nil }
                cell.configure(with: template)
                cell.startButtonAction = { [weak self] in
                    print("Start \(self?.defaultTemplatesDataSourceArray[indexPath.row].title)")
                    //delegate
                    self?.dismiss(animated: true)
                }
                return cell
                
            case .manualTemplates:
                
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ManualTemplatesCell.reuseId, for: indexPath) as? ManualTemplatesCell else { return nil }
                cell.configure(with: template)
                return cell
            }
        })
        
        dataSource?.supplementaryViewProvider = {
            collectionView, kind, indexPath in
            guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TemplatesHeader.reuseId, for: indexPath) as? TemplatesHeader else { fatalError("Can not create new section header") }

            guard let section = SectionType(rawValue: indexPath.section) else { fatalError("Unknown section kind") }

            sectionHeader.configurate(text: section.description())
            
            return sectionHeader
        }
    }
    
    
    private func reloadData() {
        var snapshot = NSDiffableDataSourceSnapshot<SectionType, TemplatesModel>()
        
        snapshot.appendSections([.defaultTemplates, .manualTemplates])
        
        snapshot.appendItems(defaultTemplatesDataSourceArray, toSection: .defaultTemplates)
        snapshot.appendItems(manualTemplatesDataSourceArray, toSection: .manualTemplates)
        
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
    
}



// MARK: - Setup Compositional Layout

extension TemplatesViewController {
    
    private func createCompositionalLayout() -> UICollectionViewLayout {
        
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnviroment in
            
            guard let section = SectionType(rawValue: sectionIndex) else { return nil }
            
            switch section {
            case .defaultTemplates:
                return self.createDefaultTemplates()
            case .manualTemplates:
                return self.createManualTemplates()
            }
        }
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20
        layout.configuration = config
        
        return layout
    }
    
    
    
    private func createDefaultTemplates() -> NSCollectionLayoutSection {
        
        // item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        // group
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(UIScreen.main.bounds.width / 1.2),
                                               heightDimension: .absolute(UIScreen.main.bounds.height / 2.3))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        // section
        let section = NSCollectionLayoutSection(group: group)
        
        // Отступы
        section.interGroupSpacing = 16 // Между группами
        section.contentInsets = NSDirectionalEdgeInsets.init(top: 16, leading: 20, bottom: 0, trailing: 20)
        
        // Тип прокрутки
        section.orthogonalScrollingBehavior = .continuous
        
        // header
        let sectionHeader = createSectionHeader()
        section.boundarySupplementaryItems = [sectionHeader]

        return section
    }
    
    
    private func createManualTemplates() -> NSCollectionLayoutSection {

        // item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        
        // groups
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(200))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
//        group.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        
        
        // section
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10) // отступы
        section.interGroupSpacing = 8
        section.contentInsets = NSDirectionalEdgeInsets.init(top: 16, leading: 20, bottom: 9, trailing: 16)
        
        
        //  header
        let sectionHeader = createSectionHeader()
        section.boundarySupplementaryItems = [sectionHeader]
        
        return section
    }
    
    // Делаем header
    private func createSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let sectionHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(1))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: sectionHeaderSize,
                                                                        elementKind: UICollectionView.elementKindSectionHeader,
                                                                        alignment: .top)
        
        return sectionHeader
    }
}


