//
//  FavouritesViewController.swift
//  PhytoBast
//
//  Created by Роман Елфимов on 23.04.2022.
//

import UIKit
import RealmSwift

class FavouritesViewController: UITableViewController {
    
    
    private let realm = try! Realm()
    private var favouritesArray: Results<TemplatesModel>!
    private var favouritesDataSourceArray: [TemplatesModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        favouritesArray = realm.objects(TemplatesModel.self)
        favouritesDataSourceArray = favouritesArray.filter({ $0.isFavourite == true })

    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return favouritesDataSourceArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        cell.textLabel?.text = favouritesDataSourceArray[indexPath.row].title

        return cell
    }
    
    

}
