//
//  TemplatesViewController.swift
//  PhytoBast
//
//  Created by Роман Елфимов on 12.04.2022.
//

import UIKit
import RealmSwift

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
    
    var startTimerAciton: ((TemplatesModel) -> ())?
    
    // MARK: - Properties
    
    private let realm = try! Realm()
    
    private var defaultTemplatesDataSourceArray: [TemplatesModel] = []
    private var manualTemplatesDataSourceArray: [TemplatesModel] = []
    
    
    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<SectionType, TemplatesModel>?
    
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        fetchDataFromRealm()
        
        if defaultTemplatesDataSourceArray.isEmpty {
            saveDefaultTemplates()
            fetchDataFromRealm()
        }
        
        setupNavigationBar()
        setupCollectionView()
        createDataSource()
        reloadData()
    }
    
    
    // MARK: - Private Methods
    
    func fetchDataFromRealm() {
        defaultTemplatesDataSourceArray = realm.objects(TemplatesModel.self).map({ $0 }).filter({ $0.modelDescripiton != "" })
        manualTemplatesDataSourceArray = realm.objects(TemplatesModel.self)
            .sorted(byKeyPath: "createdAt", ascending: false)
            .map({ $0 })
            .filter({ $0.modelDescripiton == "" })
    }
    
    
    private func saveDefaultTemplates() {
        
        let bicolorTemplate = TemplatesModel(imageName: "BicolorImage",
                                             title: "Биколор",
                                             modelDescripiton: "Красно-синий спектр подходит для освещения рассады, в первый месяц, после всходов. Так же биколор стимулирует цветение",
                                             red: 255,
                                             green: 0,
                                             blue: 255,
                                             isFavourite: false,
                                             stopTime: 2)
        
        let whiteBlueTemplate = TemplatesModel(imageName: "WhiteBlueImage",
                                               title: "Бело-Синий",
                                               modelDescripiton: "Преобладание синего спектра подходит для рассады, зелени, салатов, а также декоративно-лиственных, нецветущих домашних растений",
                                               red: 0,
                                               green: 0,
                                               blue: 255,
                                               isFavourite: false,
                                               stopTime: 4)
        
        let whiteRedTemplate = TemplatesModel(imageName: "WhiteRedImage",
                                              title: "Бело-Красный",
                                              modelDescripiton: "Преобладание красного спектра стимулирует укоренение, цветение, под ним можно выращивать овощные культуры, а также, декоративно-лиственные, цветущие растения",
                                              red: 255,
                                              green: 0,
                                              blue: 0,
                                              isFavourite: false,
                                              stopTime: 5)
        
        
        
        try! realm.write {
            realm.add(bicolorTemplate)
            realm.add(whiteBlueTemplate)
            realm.add(whiteRedTemplate)
        }
    }
    
    private func setupCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionalLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .white
        collectionView.contentInset = UIEdgeInsets(top: 32, left: 0, bottom: 0, right: 0)
        view.addSubview(collectionView)
        
        collectionView.register(TemplatesHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TemplatesHeader.reuseId)
        collectionView.register(DefaultTemplatesCell.self, forCellWithReuseIdentifier: DefaultTemplatesCell.reuseId)
        collectionView.register(ManualTemplatesCell.self, forCellWithReuseIdentifier: ManualTemplatesCell.reuseId)
    }
    
    private func setupNavigationBar() {
        title = "Шаблоны"
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        // background color
        appearance.backgroundColor = UIColor(named: "LightGreenColor")
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationItem.scrollEdgeAppearance = appearance
        navigationItem.compactAppearance = appearance
        navigationItem.standardAppearance = appearance
        
        // Dismiss button
        let arrowImage = UIImage(systemName: "chevron.backward")?.withRenderingMode(.alwaysOriginal).withTintColor(.white)
        let dismissButton = UIBarButtonItem(image: arrowImage, style: .plain, target: self, action: #selector(dismissButtonTapped))
        dismissButton.tintColor = .white
        navigationItem.leftBarButtonItem = dismissButton
        
    }
    
    
    @objc func dismissButtonTapped() {
        dismiss(animated: true)
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
                    
                    self?.startTimerAciton?(self!.defaultTemplatesDataSourceArray[indexPath.row])
                    self?.dismiss(animated: true)
                }
                
                cell.favouritesButtonAction = { [weak self] in
                    guard let self = self else { return }
                    let template = self.defaultTemplatesDataSourceArray[indexPath.row]
                    let titleForButton = !template.isFavourite ? "Удалить из избранного" : "В избранное"
                    cell.favouritesButton.setTitle(titleForButton, for: .normal)
                    
                    try! self.realm.write {
                        template.isFavourite = !template.isFavourite
                    }
                }
                
                return cell
                
            case .manualTemplates:
                
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ManualTemplatesCell.reuseId, for: indexPath) as? ManualTemplatesCell else { return nil }
                cell.configure(with: template)
                cell.startButtonAction = { [weak self] in
                    guard let self = self else { return }
                    self.startTimerAciton?(self.manualTemplatesDataSourceArray[indexPath.row])
                    self.dismiss(animated: true)
                }
                
                cell.favouritesButtonAction = { [weak self] in
                    guard let self = self else { return }
                    let template = self.manualTemplatesDataSourceArray[indexPath.row]
                    let titleForButton = !template.isFavourite ? "Удалить из избранного" : "В избранное"
                    cell.favouritesButton.setTitle(titleForButton, for: .normal)
                    
                    try! self.realm.write {
                        template.isFavourite = !template.isFavourite
                    }
                }
                
                cell.deleteButtonAction = { [weak self] in
                    guard let self = self else { return }
                    
                
                    try! self.realm.write {
                        self.realm.delete(self.manualTemplatesDataSourceArray[indexPath.row])
                        
                    }
                    self.fetchDataFromRealm()
                    self.reloadData()
                }
                
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
        config.interSectionSpacing = 44
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
                                               heightDimension: .absolute(UIScreen.main.bounds.height / 2.1))
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
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(240))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
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


