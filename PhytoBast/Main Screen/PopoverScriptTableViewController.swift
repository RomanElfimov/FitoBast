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
    
    private lazy var isEmptyLabel: UILabel = {
        let label = UILabel()
        label.text = "Сценарии пока не добавлены"
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.textColor = UIColor.secondaryLabel
        return label
    }()
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataArray = realm.objects(TemplatesModel.self)
        dataSourceArray = dataArray.filter({ $0.isFavourite == true })

        if dataSourceArray.isEmpty {
            dataSourceArray = realm.objects(TemplatesModel.self).map({ $0 }).filter({ $0.modelDescripiton != "" })
        }
        checkIsEmpty()
    }
    
    override func viewWillLayoutSubviews() {
        if dataSourceArray.count == 0 {
            preferredContentSize = CGSize(width: 0, height: 0)
        } else {
            preferredContentSize = CGSize(width: 200, height: tableView.contentSize.height)
        }
    }
    
    // MARK: - Private Method
    
    private func checkIsEmpty() {
        if dataSourceArray.isEmpty {
            view.addSubview(isEmptyLabel)
            isEmptyLabel.anchor(left: view.leftAnchor, right: view.rightAnchor, paddingLeft: 24, paddingRight: 24, height: 150)
            isEmptyLabel.centerY(inView: view)
            isEmptyLabel.centerX(inView: view)
        } else {
            isEmptyLabel.removeFromSuperview()
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
