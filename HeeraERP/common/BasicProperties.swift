//
//  BasicProperties.swift
//  HeeraERP
//
//  Created by Suvan on 1/2/18.
//  Copyright © 2018 Suvan. All rights reserved.
//

import UIKit

class BasicProperties {
    //**** common function to getlogin url
    class func getLogin_Url()-> String {
        return "http://192.168.1.59/heeraerp/heeraApi/HeeraController.php"
    }
    //**** common function to getMember url
    class func getMember_Url()-> String {
        return "http://192.168.1.59/heeraerp/heeraApi/MemberController.php"
    }
    //**** common function to getMemberPhoto_Url
    class func getMemberPhoto_Url()-> String {
        return "http://192.168.1.59/heeraerp/member_photos/"
    }
    //**** common function to getMemberSignature_Url
    class func getMemberSignature_Url()-> String {
        return "http://192.168.1.59/heeraerp/member_signatures/"
    }
    //**** common function to getMember_idproof_Url
    class func getMember_idproof_Url()-> String {
        return "http://192.168.1.59/heeraerp/member_id_proof/"
    }
    //**** common function to draw a single line under text field
    class func textBorderStyle(textField: UITextField){
        let border = CALayer()
        let width = CGFloat(1.0)
        textField.borderStyle = UITextBorderStyle.none
        border.borderColor = UIColor(red:0.17, green:0.14, blue:0.14, alpha:1.0).cgColor
        border.frame = CGRect(x: 0, y: textField.frame.size.height - width, width:  textField.frame.size.width, height: textField.frame.size.height)
        border.borderWidth = width
        textField.layer.addSublayer(border)
        textField.layer.masksToBounds = true
    }
    //**** common function to draw a single line under label
    class func labelBorderStyle(label: UILabel){
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor(red:0.17, green:0.14, blue:0.14, alpha:1.0).cgColor
        border.frame = CGRect(x: 0, y: label.frame.size.height - width, width:  label.frame.size.width, height: label.frame.size.height)
        border.borderWidth = width
        label.layer.addSublayer(border)
        label.layer.masksToBounds = true
    }
    //**** common function to draw a border line to buttons
    class func buttonBorderStyle(button: UIButton){
        let cornerRadius : CGFloat = 10.0
        button.frame = CGRect.init(origin: button.frame.origin, size: button.frame.size)
        button.backgroundColor = UIColor.clear
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor(red: 0.9294, green: 0.6196, blue: 0, alpha: 1.0).cgColor
        button.layer.cornerRadius = cornerRadius
    }
    //**** common function to get current date
    class func getCurrentDate()-> String {
        let currentDate = NSDate()
        //**** Set date format
        let dateFmt = DateFormatter()
        dateFmt.timeZone = NSTimeZone.default
        dateFmt.dateFormat =  "yyyy-MM-dd"
        //**** Get NSDate for the given string
        let date = dateFmt.string(from: currentDate as Date)
        return date;
    }
    //**** common function to draw a single line for textview border
    class func textViewBorderStyle(textView: UITextView){
        textView.layer.borderColor = UIColor(red:0.17, green:0.14, blue:0.14, alpha:1.0).cgColor
        textView.layer.borderWidth = 1.0
        textView.layer.cornerRadius = 5.0
    }
    //**** common function to draw a border line to view
    class func viewBorderStyle(view: UIView) {
        let cornerRadius : CGFloat = 10.0
        view.frame =  CGRect.init(origin: view.frame.origin, size: view.frame.size)
        view.backgroundColor = UIColor.clear
        view.layer.borderWidth = 1.0
        view.layer.borderColor = UIColor(red: 0.9294, green: 0.6196, blue: 0, alpha: 1.0).cgColor
        view.layer.cornerRadius = cornerRadius
    }
    //**** common function to add shadow view 
    class func view_shadowView(view: UIView){
        view.layer.masksToBounds = false
        view.layer.shadowOffset = CGSize(width: 0.0 , height: 5.0)
        view.layer.shadowOpacity = 1.0
        view.layer.shadowRadius = 1.0
        view.layer.shadowColor = UIColor(red:1, green:1, blue:1, alpha:1.0).cgColor
    }
}
