//
//  MienTableViewController.swift
//  App
//
//  Created by Đừng xóa on 9/22/18.
//  Copyright © 2018 Đừng xóa. All rights reserved.
//

import UIKit

class MienTableViewController: UITableViewController {

    let vungMien = ["Địa điểm phượt ở miền Bắc", "Địa điểm phượt ở miền Trung", "Địa điểm phượt miền Nam", "Địa điểm phượt miền Tây"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vungMien.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell1", for: indexPath)
        cell.textLabel?.text = vungMien[indexPath.row]
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = tableView.indexPathForSelectedRow {
            let placeTableViewController = segue.destination as? PlaceTableViewController
            placeTableViewController?.mien = vungMien[indexPath.row]
        }
    }
}
