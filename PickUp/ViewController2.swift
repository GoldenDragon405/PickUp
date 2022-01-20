//
//  ViewController2.swift
//  PickUp
//
//  Created by Krish Mody on 11/4/21.
//

import UIKit

class ViewController2: UIViewController, UITableViewDataSource {
    
    let tableViewData = Array(repeating: "Item", count: 5)

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableViewData.count

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell",
                                                     for: indexPath)
            cell.textLabel?.text = self.tableViewData[indexPath.row]
            return cell
    }

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        title = "Nav-Bar"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TableViewCell")
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
}
