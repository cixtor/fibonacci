//
//  SettingsViewController.swift
//  Fibonacci
//
//  Created by Yorman on 7/1/18.
//  Copyright © 2018 yorman. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var tableView: UITableView!
    
    private var options: [String] = []
    private var optionSelections: [[String]] = []
    private var optionsNotes: [String] = []
    
    // MARK: - Set up
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        options = ["Game Type", "Board Size", "Theme"]
        optionSelections = [["Powers of 2", "Powers of 3", "Fibonacci"], ["3 x 3", "4 x 4", "5 x 5"], ["Default", "Vibrant", "Joyful"]]
        optionsNotes = ["For Fibonacci games, a tile can be joined with a tile that is one level above or below it, but not to one equal to it. For Powers of 3, you need 3 consecutive tiles to be the same to trigger a merge!", "The smaller the board is, the harder! For 5 x 5 board, two tiles will be added every round if you are playing Powers of 2.", "Choose your favorite appearance and get your own feeling of 2048! More (and higher quality) themes are in the works so check back regularly!"]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = GSTATE.scoreBoardColor()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "Settings Detail Segue") {
            let sdvc = segue.destination as? SettingsDetailViewController
            let index: Int? = tableView.indexPathForSelectedRow?.row
            sdvc?.title = options[index ?? 0]
            sdvc?.options = [optionSelections[index ?? 0]]
            sdvc?.footer = optionsNotes[index ?? 0]
        }
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section != 0 ? 1 : options.count
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if section != 0 {
            return ""
        }
        return "Please note: Changing the settings above would restart the game."
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "Settings Cell")
        if indexPath.section != 0 {
            cell?.textLabel?.text = "About 2048"
            cell?.detailTextLabel?.text = ""
        } else {
            cell?.textLabel?.text = options[indexPath.row]
            let index: Int = Settings.integer(forKey: options[indexPath.row])
            cell?.detailTextLabel?.text = optionSelections[indexPath.row][index]
            cell?.detailTextLabel?.textColor = GSTATE.scoreBoardColor()
        }
        if let aCell = cell {
            return aCell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section != 0 {
            performSegue(withIdentifier: "About Segue", sender: nil)
        } else {
            performSegue(withIdentifier: "Settings Detail Segue", sender: nil)
        }
    }
}
