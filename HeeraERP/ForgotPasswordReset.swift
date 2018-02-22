//
//  ForgotPasswordReset.swift
//  HeeraERP
//
//  Created by Suvan on 2/2/18.
//  Copyright © 2018 Suvan. All rights reserved.
//

import UIKit

class ForgotPasswordReset: UIViewController, UITextFieldDelegate {
    //linking nib outlets/fields with controller
    @IBOutlet weak var txt_newPassword: UITextField!
    @IBOutlet weak var txt_retypePassword: UITextField!
    @IBOutlet weak var btn_submit: UIButton!
    //globaly declared variables
    var userName: String?
    var userType: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //**** only portrait orientation
        UIDevice.current.setValue(Int(UIInterfaceOrientation.portrait.rawValue), forKey: "orientation")
        BasicProperties.buttonBorderStyle(button: btn_submit)
        BasicProperties.textBorderStyle(textField: txt_newPassword)
        BasicProperties.textBorderStyle(textField: txt_retypePassword)
        txt_newPassword.delegate = self
        txt_retypePassword.delegate = self
    }
    //**** setting scroll view and orientation
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        //**** portrait oreintation
        UIDevice.current.setValue(Int(UIInterfaceOrientation.portrait.rawValue), forKey: "orientation")
        //**** scroll view
        //        scrollView.contentSize = CGSize(width: view.frame.size.width, height: mainView.frame.size.height)
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
    //**** keyboard activities
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txt_newPassword {
            txt_newPassword.resignFirstResponder()
            txt_retypePassword.becomeFirstResponder()
            return true
        }
        else if textField == txt_retypePassword{
            txt_retypePassword.resignFirstResponder()
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
    //resetting new password
    @IBAction func actn_submitNewPassword(_ sender: Any) {
        if(txt_newPassword.text! == txt_retypePassword.text!){
            //**** starting loading indicator/ preloader
            ActivityIndicator.startAnimating_LoadingIndicator(view: self.view)
            let string = "pageKey=resetPassword&userName="+userName!+"&userType="+userType!+"&password="+txt_newPassword.text!
            urlConnection(postString: string)
        }
        else{
            let alertController = UIAlertController(title: "Password mismatching", message:
                "New password and retype password are not matching!", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: { action in
                self.txt_newPassword.text = ""
                self.txt_retypePassword.text = ""
            }))
            self.present(alertController, animated: true, completion: nil)
        }
    }
    //connecting to remote server and get response
    func urlConnection(postString: String){
        let url = URL(string: BasicProperties.getLogin_Url())!
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        // let postString = "pageKey=login&userName="+txt_username.text!+"&password="+txt_password.text!+"&userType="+usertype_value
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
                    DispatchQueue.main.async {
                        //**** stopping loading indicator/ preloader
                        ActivityIndicator.stopAnimating_LoadingIndicator()
                        if(status?.isEqual(1))!{
//                            ["status": 1, "message": Your Password is resetted]
                            //**** assign values to GlobalValues.swift
                            let msg = json["message"]
                            self.txt_newPassword.text = ""
                            self.txt_retypePassword.text = ""
                           self.dismiss(animated: true, completion: nil)
                            let alertController = UIAlertController(title: msg as? String, message:
                                "Please login again!", preferredStyle: UIAlertControllerStyle.alert)
                            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: { action in
                            }))
                            self.present(alertController, animated: true, completion: nil)
                        }
                        else{
                            let alertController = UIAlertController(title: "Something went wrong", message:
                                "Please try again!", preferredStyle: UIAlertControllerStyle.alert)
                            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: { action in
                                self.txt_newPassword.text = ""
                                self.txt_retypePassword.text = ""
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
}
