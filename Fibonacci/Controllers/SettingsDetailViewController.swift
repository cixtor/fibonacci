//
//  SettingsDetailViewController.swift
//  Fibonacci
//
//  Created by Yorman on 7/1/18.
//  Copyright © 2018 yorman. All rights reserved.
//

import UIKit

class SettingsDetailViewController: UITableViewController {
    var options: [Any] = []
    var footer = ""
    
    override init(style: UITableViewStyle) {
        super.init(style: style)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = GSTATE.scoreBoardColor()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return footer
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "Settings Detail Cell")
        cell?.textLabel?.text = options[indexPath.row] as? String
        cell?.accessoryType = (Settings.integer(forKey: title!) == indexPath.row) ? .checkmark : .none
        cell?.tintColor = GSTATE.scoreBoardColor()
        if let aCell = cell {
            return aCell
        }
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Settings.set(indexPath.row, forKey: title!)
        self.tableView.reloadData()
        GSTATE.needRefresh = true
    }
}
