//
//  MemberDashboardController.swift
//  HeeraERP
//
//  Created by Suvan on 12/15/17.
//  Copyright © 2017 Suvan. All rights reserved.
//

import UIKit

class MemberDashboardController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    //linking nib outlets/fields with controller
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var header_view: UIView!
    @IBOutlet weak var lbl_today_date: UILabel!
    @IBOutlet weak var lbl_lastLoggedin: UILabel!
    @IBOutlet weak var lbl_underline: UILabel!
    @IBOutlet weak var lbl_memberName: UILabel!
    @IBOutlet weak var lbl_IBGNumber: UILabel!
    //globaly declared variables
    var cellImages = ["ic_my_profile","ic_my_account","ic_tcn_request","ic_tcn_application","ic_reset_password","ic_change_password","ic_contact_admin"]
    var sideLabels = ["My Profile","My Account","TCN Request","TCN Application","Redeem Details", "Change Password", "Contact Admin"]
    
    override func viewDidLoad() {
         super.viewDidLoad()
        //****** side menu toggle ******//
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            // Faster slide animation
            revealViewController().toggleAnimationDuration = 0.2
            //****** to change the width of the menu ******//
            self.revealViewController().rearViewRevealWidth = view.frame.width - 70
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        //**** shadow view for uiview: header_view
            header_view.layer.masksToBounds = false
            header_view.layer.shadowOffset = CGSize(width: 0.0 , height: 5.0)
            header_view.layer.shadowOpacity = 1.0
            header_view.layer.shadowRadius = 1.0
            header_view.layer.shadowColor = UIColor(red:0.59, green:0.56, blue:0.56, alpha:1.0).cgColor
        //**** get current date
            lbl_today_date.text = BasicProperties.getCurrentDate()
        //**** used only in landscape view
            lbl_underline.isHidden = true
        //**** get values from GlobalValues.swift
            lbl_memberName.text = GlobalValues.MyVariables.userName
            lbl_IBGNumber.text = GlobalValues.MyVariables.userCode
    }
    override func willRotate(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        //**** used only in landscape view
            lbl_underline.isHidden = false
        //**** shadow view for uiview: header_view
        header_view.layer.masksToBounds = false
        header_view.layer.shadowOffset = CGSize(width: 0.0 , height: 5.0)
        header_view.layer.shadowOpacity = 1.0
        header_view.layer.shadowRadius = 1.0
        header_view.layer.shadowColor = UIColor(red:1, green:1, blue:1, alpha:1.0).cgColor
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        if(self.view.frame.width > self.view.frame.height){
//            header_view.frame.size.height = header_view.frame.size.height + 100
//        }
//        else{
//            header_view.frame.size.height = header_view.frame.size.height - 100
//        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellImages.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemberCollectionCellDashboard", for: indexPath) as! MemberCollectionCellDashboard
        cell.img_icons?.image = UIImage(named: cellImages[indexPath.row])
        cell.lbl_iconNames?.text = sideLabels[indexPath.row]
        
        //**** layout sizeforitemAtIndexPath
            let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
            layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            //****** specify spacing between cell items ******//
            layout.minimumInteritemSpacing = 5
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //**** navigating to another controller according to selected row
        var viewController = UIViewController()
        switch (indexPath as NSIndexPath).row {
        case 0:
            //**** switch view to MemberMyProfileController
             viewController = self.storyboard?.instantiateViewController(withIdentifier: "MemberMyProfileController") as! MemberMyProfileController             
            break
        case 1:
            //**** switch view to MemberMyAccountController
             viewController = self.storyboard?.instantiateViewController(withIdentifier: "MemberMyAccountController") as! MemberMyAccountController
            break
        case 2:
            //**** switch view to MemberTcnRequestController
               viewController = self.storyboard?.instantiateViewController(withIdentifier: "MemberTcnRequestController") as! MemberTcnRequestController
            break
        case 3:
            //switch view to MemberTcnApplicationController
             viewController = self.storyboard?.instantiateViewController(withIdentifier: "MemberTcnApplicationController") as! MemberTcnApplicationController
            break
        case 4:
            //**** switch view to MemberRedeemDetailsController
             viewController = self.storyboard?.instantiateViewController(withIdentifier: "MemberVoucherController") as! MemberVoucherController
            break
        case 5:
            //**** switch view to MemberChangePasswordController
             viewController = self.storyboard?.instantiateViewController(withIdentifier: "MemberChangePasswordController") as! MemberChangePasswordController
            break
        case 6:
            //**** switch view to MemberContactAdminController
             viewController = self.storyboard?.instantiateViewController(withIdentifier: "MemberContactAdminController") as! MemberContactAdminController
            break
        default: break
        }
        self.navigationController?.pushViewController(viewController, animated: true)
    } 
}
