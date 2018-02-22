//
//  MemberChangePasswordController.swift
//  HeeraERP
//
//  Created by Suvan on 12/15/17.
//  Copyright © 2017 Suvan. All rights reserved.
//

import UIKit

class MemberChangePasswordController: UIViewController, UITextFieldDelegate{
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var txt_currentPassword: UITextField!
    @IBOutlet weak var txt_newPassword: UITextField!
    @IBOutlet weak var txt_retypeNewPassword: UITextField!
    @IBOutlet weak var lbl_today_date: UILabel!
    @IBOutlet weak var btn_submit: UIButton!
    @IBOutlet weak var main_view: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
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
        //**** text border and button border
            BasicProperties.textBorderStyle(textField: txt_currentPassword)
            BasicProperties.textBorderStyle(textField: txt_newPassword)
            BasicProperties.textBorderStyle(textField: txt_retypeNewPassword)
            BasicProperties.buttonBorderStyle(button: btn_submit)
        //**** get current date
            lbl_today_date.text = BasicProperties.getCurrentDate()
            txt_currentPassword.delegate = self
            txt_newPassword.delegate = self
            txt_retypeNewPassword.delegate = self
        UIDevice.current.setValue(Int(UIInterfaceOrientation.portrait.rawValue), forKey: "orientation")
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    @objc func keyboardWillShow(notification:NSNotification) {
        scrollView.contentSize = CGSize(width: view.frame.size.width, height: main_view.frame.size.height + 70)
    }
    @objc func keyboardWillHide(notification:NSNotification) {
        scrollView.contentSize = CGSize(width: view.frame.size.width, height: main_view.frame.size.height - 70)
    }
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIDevice.current.setValue(Int(UIInterfaceOrientation.portrait.rawValue), forKey: "orientation")
        //**** extend scroll view
            scrollView.contentSize = CGSize(width: view.frame.size.width, height: main_view.frame.size.height)
    }
    //**** handling device rotation
    override func willRotate(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        if toInterfaceOrientation == .landscapeLeft || toInterfaceOrientation == .landscapeRight {
            UIDevice.current.setValue(Int(UIInterfaceOrientation.portrait.rawValue), forKey: "orientation")
        }
        else {
            UIDevice.current.setValue(Int(UIInterfaceOrientation.portrait.rawValue), forKey: "orientation")
        }
    }
    @IBAction func actn_changePassword(_ sender: Any) {
        if(txt_currentPassword.text?.isEmpty == false && txt_newPassword.text?.isEmpty == false && txt_retypeNewPassword.text?.isEmpty == false){
            if(txt_newPassword.text == txt_retypeNewPassword.text){
                //**** loading indicator/ preloader
                ActivityIndicator.startAnimating_LoadingIndicator(view: self.view)
                let url = URL(string: BasicProperties.getMember_Url())!
                var request = URLRequest(url: url)
                request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                request.httpMethod = "POST"
                let memberId = GlobalValues.MyVariables.empId
                let postString = "pageKey=changePassword&memberId="+memberId!+"&currentPassword="+txt_currentPassword.text!+"&newPassword="+txt_newPassword.text!
                request.httpBody = postString.data(using: .utf8)
                let task = URLSession.shared.dataTask(with: request) { data, response, error in
                    guard let data = data, error == nil else {               // check for fundamental networking error
                        print("error= ", error ?? " ")
                        return
                    }
                    do {
                        //create json object from data
                        if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: AnyObject] {
                            print(json)
                            // handle json...
                            let status = json["status"]
                             //to overcome main thread return & firebase auth
                            DispatchQueue.main.async {
                                //**** loading indicator/ preloader
                                ActivityIndicator.stopAnimating_LoadingIndicator()
                                if(status?.isEqual(1))!{
                                    let mainMessage = json["msg"] as? String
                                    let alertController = UIAlertController(title: "Success!", message: mainMessage, preferredStyle: UIAlertControllerStyle.alert)
                                    alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: { action in
                                    }))
                                    self.present(alertController, animated: true, completion: nil)
                                }
                                else if(status?.isEqual(0))!{
                                    let mainMessage = json["msg"] as? String
                                    let alertController = UIAlertController(title: "Invalid password!", message: mainMessage, preferredStyle: UIAlertControllerStyle.alert)
                                    alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: { action in
                                        
                                    }))
                                    self.present(alertController, animated: true, completion: nil)
                                }
                                else{
                                    //connection failed
                                    let alertController = UIAlertController(title: "Error", message: "Something went wrong! Please try again!", preferredStyle: UIAlertControllerStyle.alert)
                                    alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: { action in
                                    }))
                                    self.present(alertController, animated: true, completion: nil)
                                }
                            }
                        }
                    } catch let error {
                        print(error.localizedDescription)
                    }
                }
                task.resume()
            }
            else{
                let alertController = UIAlertController(title: "Password Mismatching", message: "New password & Retype password must be same!", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: { action in
                }))
                self.present(alertController, animated: true, completion: nil)
            }
            txt_currentPassword.text = ""
            txt_newPassword.text = ""
            txt_retypeNewPassword.text = ""
        }
        else{
            let alertController = UIAlertController(title: "Invaild inputs", message: "Fill all fields!", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: { action in
            }))
            self.present(alertController, animated: true, completion: nil)
        }
    }
    //****    keyboard activities
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txt_currentPassword {
            txt_currentPassword.resignFirstResponder()
            txt_newPassword.becomeFirstResponder()
            return true
        }
        else if textField == txt_newPassword {
            txt_newPassword.resignFirstResponder()
            txt_retypeNewPassword.becomeFirstResponder()
            return true
        }
        else if textField == txt_retypeNewPassword {
            txt_retypeNewPassword.resignFirstResponder()
            self.view.endEditing(true)
            return true
        }
        return true
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    //**** hide keyboard when toches the background
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
}
