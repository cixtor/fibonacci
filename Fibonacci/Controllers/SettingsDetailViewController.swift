//
//  SettingsDetailViewController.swift
//  Fibonacci
//
//  Created by Yorman on 7/1/18.
//  Copyright © 2018 yorman. All rights reserved.
//

import UIKit

class SettingsDetailViewController: UITableViewController {
    var footer = ""
    var options: [String] = []

    convenience override init(style: UITableViewStyle) {
        self.init(style: style)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = GSTATE.scoreBoardColor()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.options.count
    }

    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return self.footer
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "Settings Detail Cell", for: indexPath)

        cell.textLabel?.text = options[indexPath.row]
        cell.tintColor = GSTATE.scoreBoardColor()
        cell.accessoryType = .none

        if let uititle = self.title {
            if Settings.integer(forKey: uititle) == indexPath.row {
                cell.accessoryType = .checkmark
            }
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Settings.set(indexPath.row, forKey: self.title ?? "")
        self.tableView.reloadData()
        GSTATE.needRefresh = true
    }
}
