//
//  MemberContactAdminController.swift
//  HeeraERP
//
//  Created by Suvan on 12/15/17.
//  Copyright © 2017 Suvan. All rights reserved.
//

import UIKit

class MemberContactAdminController : UIViewController {
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var txt_subject: UITextField!
    @IBOutlet weak var txt_message: UITextView!
    @IBOutlet weak var btn_sendMessage: UIButton!
    @IBOutlet weak var lbl_today_date: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var mainView: UIView!
    
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
        //**** text and border style
            BasicProperties.textBorderStyle(textField: txt_subject)
            BasicProperties.buttonBorderStyle(button: btn_sendMessage)
            BasicProperties.textViewBorderStyle(textView: txt_message)
        //**** get current date
            lbl_today_date.text = BasicProperties.getCurrentDate()
            txt_message.delegate = self as? UITextViewDelegate
            txt_subject.delegate = self as? UITextFieldDelegate
        UIDevice.current.setValue(Int(UIInterfaceOrientation.portrait.rawValue), forKey: "orientation")
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    @objc func keyboardWillShow(notification:NSNotification) {
       scrollView.contentSize = CGSize(width: view.frame.size.width, height: mainView.frame.size.height + 70)
    }
    @objc func keyboardWillHide(notification:NSNotification) {
        scrollView.contentSize = CGSize(width: view.frame.size.width, height: mainView.frame.size.height - 70)
    }
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIDevice.current.setValue(Int(UIInterfaceOrientation.portrait.rawValue), forKey: "orientation")
        //**** extend scroll view
            scrollView.contentSize = CGSize(width: view.frame.size.width, height: mainView.frame.size.height)
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
    @IBAction func actn_sendMessage(_ sender: Any) {
            if(self.txt_subject.text?.isEmpty == false && self.txt_message.text.isEmpty == false){
                //**** loading indicator/ preloader
                ActivityIndicator.startAnimating_LoadingIndicator(view: self.view)
                let url = URL(string: BasicProperties.getMember_Url())!
                var request = URLRequest(url: url)
                request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                request.httpMethod = "POST"
                let memberId = GlobalValues.MyVariables.empId
                let postString = "pageKey=contactAdmin&memberId="+memberId!+"&subject="+self.txt_subject.text!+"&message="+self.txt_message.text!
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
                                    let alertController = UIAlertController(title: "Message send successfully", message: mainMessage, preferredStyle: UIAlertControllerStyle.alert)
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
                txt_subject.text = ""
                txt_message.text = ""
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
        if textField == txt_subject {
            txt_subject.resignFirstResponder()
            txt_message.becomeFirstResponder()
            return true
        }
        else if textField == txt_message {
            txt_message.resignFirstResponder()
            self.view.endEditing(true)
            return true
        }
        return true
    }
    //**** hide keyboard when toches the background
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
}
