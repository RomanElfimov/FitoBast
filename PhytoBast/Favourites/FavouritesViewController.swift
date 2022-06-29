//
//  FavouritesViewController.swift
//  PhytoBast
//
//  Created by Роман Елфимов on 23.04.2022.
//

import UIKit
import RealmSwift

class FavouritesViewController: UITableViewController {
    
    // MARK: - Private Properties
    
    private let realm = try! Realm()
    private var favouritesDataSourceArray: [TemplatesModel] = []

    private lazy var isEmptyLabel: UILabel = {
        let label = UILabel()
        label.text = "В избранном пока пусто"
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 19, weight: .regular)
        label.textColor = UIColor(named: "GreenWhite")
        return label
    }()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        
        tableView = UITableView(frame: view.bounds, style: .insetGrouped)
        tableView.allowsSelection = false
        tableView.register(FavouritesTableViewCell.self, forCellReuseIdentifier: "Cell")
        
        favouritesDataSourceArray = realm.objects(TemplatesModel.self)
            .map({ $0 })
            .filter({ $0.isFavourite == true })
        
        checkIsEmpty()
    }
    
    
    // MARK: - Private Method
    
    private func checkIsEmpty() {
        if favouritesDataSourceArray.isEmpty {
            view.addSubview(isEmptyLabel)
            isEmptyLabel.anchor(left: view.leftAnchor, right: view.rightAnchor, paddingLeft: 24, paddingRight: 24, height: 150)
            isEmptyLabel.centerY(inView: view)
            isEmptyLabel.centerX(inView: view)
        } else {
            isEmptyLabel.removeFromSuperview()
        }
    }
    
    private func setupNavigationBar() {
        title = "Избранные шаблоны"
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
    
    
    // MARK: - Selector
    
    @objc func dismissButtonTapped() {
        dismiss(animated: true)
    }
    
    

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favouritesDataSourceArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FavouritesTableViewCell

        cell.configure(with: favouritesDataSourceArray[indexPath.row])

        return cell
    }
    
    
    
    // Удаление из избранного
    
    override func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Удалить"
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            let template = favouritesDataSourceArray[indexPath.row]
            try! self.realm.write {
                            template.isFavourite = false
                        }
            
            favouritesDataSourceArray.remove(at: indexPath.row)
                        tableView.deleteRows(at: [indexPath], with: .automatic)
           checkIsEmpty()
        }
    }
    
    
}
