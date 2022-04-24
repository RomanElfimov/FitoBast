//
//  PopoverScriptTableViewController.swift
//  PhytoBast
//
//  Created by Роман Елфимов on 24.04.2022.
//

import UIKit
import RealmSwift

class PopoverScriptTableViewController: UITableViewController {
    
    // MARK: - Completion Handler
    
    public var completion: ((TemplatesModel) -> ())?
    
    // MARK: - Private Properties
    
    private var dataArray: Results<TemplatesModel>!
    private var dataSourceArray: [TemplatesModel] = []
    
    private let realm = try! Realm()
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataArray = realm.objects(TemplatesModel.self)
        dataSourceArray = dataArray.filter({ $0.isFavourite == true })
    }
    
    override func viewWillLayoutSubviews() {
        if dataSourceArray.count == 0 {
            preferredContentSize = CGSize(width: 0, height: 0)
        } else {
            preferredContentSize = CGSize(width: 200, height: tableView.contentSize.height)
        }
    }
    
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSourceArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = dataSourceArray[indexPath.row].title
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        completion?(dataSourceArray[indexPath.row])
        self.dismiss(animated: true, completion: nil)
    }
    
}
