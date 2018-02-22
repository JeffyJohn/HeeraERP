//
//  MemberSideMenuController.swift
//  HeeraERP
//
//  Created by Suvan on 12/15/17.
//  Copyright © 2017 Suvan. All rights reserved.
//

import UIKit

class MemberSideMenuController: UITableViewController {
    //linking nib outlets/fields with controller
    @IBOutlet weak var lbl_memberName: UILabel!
    @IBOutlet weak var img_userphoto: UIImageView!
    //globaly declared variables
    var sideLabels = ["Dashboard","My Profile","My Account","TCN Request","TCN Application","Redeem Details", "Change Password", "Contact Admin", "Logout","blankCell"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //**** assign member name and photo
        lbl_memberName.text = GlobalValues.MyVariables.userName
        img_userphoto.image = UIImage(named: GlobalValues.MyVariables.userPhoto!)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return sideLabels.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //**** Configure the cell
        let CellIdentifier =  sideLabels[indexPath.row]
        let cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier, for: indexPath)
        tableView.separatorStyle = .none
//        //**** new label for redeem details
//        if(indexPath.row == 5){
//            //**** Create label
//                let fontSize: CGFloat = 14
//                let label = UILabel()
//                label.font = UIFont.systemFont(ofSize: fontSize)
//                label.textAlignment = .center
//                label.textColor = UIColor.white
//                label.backgroundColor = UIColor.red
//            //**** Add count to label and size to fit
//                label.text = "New"
//                label.sizeToFit()
//            //**** Adjust frame to be square or eliptical
//                label.frame = CGRect.init(x: 170, y: 15, width: 50, height: 20)
//            //**** Set radius and clip to bounds
//                label.layer.cornerRadius = label.frame.size.height / 2.0
//                label.clipsToBounds = true
//            //**** Show label in accessory view and remove disclosure
//            //**** cell.accessoryView = label
//                cell.accessoryType = .none
//                cell.addSubview(label)
//        }
//        else{
//            cell.accessoryView = nil
//        }
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        
        //**** navigating to another controller according to selected row
        var controller: UIViewController?
        switch (indexPath as NSIndexPath).row {
        case 0:
            //**** switch view to MemberDashboardController
            controller = self.storyboard?.instantiateViewController(withIdentifier: "MemberDashboardController")
        case 1:
            //**** switch view to MemberMyProfileController
             controller = self.storyboard?.instantiateViewController(withIdentifier: "MemberMyProfileController")            
        case 2:
            //**** switch view to MemberMyAccountController
            controller = self.storyboard?.instantiateViewController(withIdentifier: "MemberMyAccountController")
        case 3:
            //**** switch view to MemberTcnRequestController
            controller = self.storyboard?.instantiateViewController(withIdentifier: "MemberTcnRequestController")
        case 4:
            //**** switch view to MemberTcnApplicationController
            controller = self.storyboard?.instantiateViewController(withIdentifier: "MemberTcnApplicationController")
        case 5:
            //**** switch view to MemberRedeemDetailsController
            controller = self.storyboard?.instantiateViewController(withIdentifier: "MemberVoucherController")
        case 6:
            //**** switch view to MemberChangePasswordController
            controller = self.storyboard?.instantiateViewController(withIdentifier: "MemberChangePasswordController")
        case 7:
            //**** switch view to MemberContactAdminController
            controller = self.storyboard?.instantiateViewController(withIdentifier: "MemberContactAdminController")
        case 8:
            //**** actionsheet with alertController for dismiss login action
            let alert = UIAlertController(title: "", message: "Are you sure you want to quit?", preferredStyle: UIAlertControllerStyle.actionSheet)
            let libButton = UIAlertAction(title: "Yes", style: UIAlertActionStyle.default) { (alert) -> Void in
                //**** dissmiss view to login
                self.dismiss(animated: true, completion: nil)
            }
            let cancelButton = UIAlertAction(title: "No", style: UIAlertActionStyle.cancel) { (alert) -> Void in
                print("Cancel Pressed")
            }
            alert.addAction(libButton)
            alert.addAction(cancelButton)
            self.present(alert, animated: true, completion: nil)
            break
        default: break
        }
        //**** setting realview navigations in each controller transaction
        if (controller != nil) {
            let cell = tableView.cellForRow(at: indexPath)
            controller!.title = cell?.textLabel?.text
            let navController = UINavigationController(rootViewController: controller!)
            revealViewController().pushFrontViewController(navController, animated:true)
        }
    }
}
