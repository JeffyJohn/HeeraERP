//
//  DropDownMenuController.swift
//  HeeraERP
//
//  Created by Suvan on 12/18/17.
//  Copyright © 2017 Suvan. All rights reserved.
//

import UIKit

protocol DropDownMenuControllerDelegate {
    func acceptData(data: AnyObject!)
}

class DropDownMenuController: UIViewController, UITableViewDelegate ,UITableViewDataSource{
    var cellArray = [String]()
    
    // create a variable that will recieve / send messages
    // between the view controllers.
    var delegate : DropDownMenuControllerDelegate! = nil

    @IBOutlet weak var tbl_dropdown: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
         tbl_dropdown.tableFooterView = UIView(frame: CGRect.zero)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - Table view data source
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return cellArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cells", for: indexPath as IndexPath)
        cell.textLabel?.text = cellArray[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        // pass the data from the child's text field to the parent by setting is on a property of the parent.
        delegate.acceptData(data: cellArray[indexPath.row] as AnyObject)
        self.navigationController?.popViewController(animated: true)
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .none
    }
    //    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//       if tableView.cellForRow(at: indexPath as IndexPath)?.accessoryType == UITableViewCellAccessoryType.checkmark
//       {
//            tableView.cellForRow(at: indexPath as IndexPath)?.accessoryType = UITableViewCellAccessoryType.none
//        }
//       else{
//            tableView.cellForRow(at: indexPath as IndexPath)?.accessoryType = UITableViewCellAccessoryType.checkmark
//        }
//    }
}
