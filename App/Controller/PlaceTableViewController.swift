//
//  PlaceTableViewController.swift
//  App
//
//  Created by Đừng xóa on 9/22/18.
//  Copyright © 2018 Đừng xóa. All rights reserved.
//

import UIKit

class PlaceTableViewController: UITableViewController {

    var mien: String?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if mien != nil {
            DataService.shared.getDataPlist(place: mien!)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataService.shared.my4mien.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell2", for: indexPath)
        cell.textLabel?.text = DataService.shared.my4mien[indexPath.row].name
        return cell
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = tableView.indexPathForSelectedRow {
            let showPlaceViewController = segue.destination as? ShowPlaceViewController
            showPlaceViewController?.place = DataService.shared.my4mien[indexPath.row]
        }
    }
}
