//
//  ForgotPassword_OTPChecking.swift
//  HeeraERP
//
//  Created by Suvan on 2/2/18.
//  Copyright © 2018 Suvan. All rights reserved.
//

import UIKit

class ForgotPassword_OTPChecking: UIViewController, UITextFieldDelegate{
    //linking nib outlets/fields with controller
    @IBOutlet weak var txt_otp: UITextField!
    @IBOutlet weak var btn_submit: UIButton!
    //globaly declared variables
    var userName: String?
    var userType: String?
    var otp: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //**** only portrait orientation
        UIDevice.current.setValue(Int(UIInterfaceOrientation.portrait.rawValue), forKey: "orientation")
        //applying basic properties
        BasicProperties.buttonBorderStyle(button: btn_submit)
        BasicProperties.textBorderStyle(textField: txt_otp)
        txt_otp.delegate = self
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
        if textField == txt_otp {
            txt_otp.resignFirstResponder()
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
    //otp verfication
    //navigation to ForgotPasswordReset controller
    @IBAction func actn_submitOTP(_ sender: Any) {
       if(txt_otp.text! == otp!){
            let forgotPassword = self.storyboard?.instantiateViewController(withIdentifier: "ForgotPasswordReset") as! ForgotPasswordReset
            forgotPassword.userName = userName
            forgotPassword.userType = userType
            forgotPassword.title = "Forgot Password"
            self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
            self.navigationController?.pushViewController(forgotPassword, animated: true)
        }
        else{
            let alertController = UIAlertController(title: "Invalid OTP", message:
                "Please try again!", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: { action in
            }))
            self.present(alertController, animated: true, completion: nil)
        }
        txt_otp.text = ""
    }
    //resend otp request
    @IBAction func actn_resendOTP(_ sender: Any) {
        self.view.endEditing(true)
        //**** starting loading indicator/ preloader
        ActivityIndicator.startAnimating_LoadingIndicator(view: self.view)
        let string = "pageKey=forgotPassword&userName="+userName!+"&userType="+userType!
        urlConnection(postString: string)
    }
    //connecting to remote server and get response
    func urlConnection(postString: String){
        let url = URL(string: BasicProperties.getLogin_Url())!
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
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
                            let msg = json["message"]
                            let otpCode = json["otp_code"]
                            self.otp = otpCode as? String
                            self.txt_otp.text = ""
                            let alertController = UIAlertController(title: "OTP Verification", message:
                                msg as? String, preferredStyle: UIAlertControllerStyle.alert)
                            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: { action in
                            }))
                            self.present(alertController, animated: true, completion: nil)
                        }
                        else{
                            let alertController = UIAlertController(title: "Something went wrong", message:
                                "Please try again!", preferredStyle: UIAlertControllerStyle.alert)
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
}
