//
//  MemberVoucherController.swift
//  HeeraERP
//
//  Created by Suvan on 12/22/17.
//  Copyright © 2017 Suvan. All rights reserved.
//

import UIKit

class MemberVoucherController: UIViewController {
    
    @IBOutlet weak var img_barcode: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var voucher_view: UIView!
    @IBOutlet weak var lbl_voucherAmount: UILabel!
    @IBOutlet weak var lbl_voucherName: UILabel!
    @IBOutlet weak var lbl_memberName: UILabel!
    @IBOutlet weak var lbl_ibgCode: UILabel!
    @IBOutlet weak var lbl_today_date: UILabel!
    @IBOutlet weak var lbl_barcode: UILabel!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    var voucher_original_height: CGFloat?
    
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
       // UIDevice.current.setValue(Int(UIInterfaceOrientation.landscapeRight.rawValue), forKey: "orientation")
        //**** generating barcode using a string and return it as image
            let img = Barcode.fromString(string: "FREI-IBG0098651GV")
            img_barcode.image = img
        //**** setting voucher boarders
            BasicProperties.viewBorderStyle(view: voucher_view)
        //**** get current date
            lbl_today_date.text = BasicProperties.getCurrentDate()
        //**** assign voucher height to a variable
            voucher_original_height = voucher_view.frame.size.height
        //**** barcode String to a label
            lbl_barcode.text = "FREI-IBG0098651GV"
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //**** extending scroll view
            scrollView.contentSize = CGSize(width: view.frame.size.width, height: voucher_view.frame.size.height)
        //**** adjusting voucher border with respect to orientation
            if(self.view.frame.width > self.view.frame.height){
                //voucher_view.frame.size.height = scrollView.frame.size.height + 100
                BasicProperties.viewBorderStyle(view: voucher_view)
            }
            else{
                BasicProperties.viewBorderStyle(view: voucher_view)
            }
    }    //**** adjusting voucher border with respect to orientation
    //**** extending height of voucher view
    override func willRotate(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        if toInterfaceOrientation == .landscapeLeft || toInterfaceOrientation == .landscapeRight {
           voucher_view.frame.size.height = scrollView.frame.size.height + 100
           BasicProperties.viewBorderStyle(view: voucher_view)
        }
        else {
            BasicProperties.viewBorderStyle(view: voucher_view)
        }
    }
}
