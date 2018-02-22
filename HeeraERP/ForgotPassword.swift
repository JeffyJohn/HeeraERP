//
//  ForgotPassword.swift
//  HeeraERP
//
//  Created by Suvan on 2/1/18.
//  Copyright © 2018 Suvan. All rights reserved.
//

import UIKit

class ForgotPassword :UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    //linking nib outlets/fields with controller
    @IBOutlet weak var lbl_userType: UILabel!
    @IBOutlet weak var btn_userType: UIButton!
    @IBOutlet weak var btn_submit: UIButton!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var pickerBar: UIToolbar!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var picker_view: UIView!
    @IBOutlet weak var txt_userName: UITextField!
    //globaly declared variables
    var usertype_value: String?
    var pickerData:String?
    var userTypeSelected :String?
    var pickerDataSource = ["-- select --","Member","Administrative", "Office Incharge", "Marketing Executive", "Direct Selling Agent","Employee"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //**** usertype selection picker hidden
        picker_view.isHidden = true
        lbl_userType?.text = "-- select --"
        txt_userName.delegate = self
        //applying basic properties
        BasicProperties.buttonBorderStyle(button: btn_submit)
        BasicProperties.buttonBorderStyle(button: btn_userType)
         BasicProperties.textBorderStyle(textField: txt_userName)
        //**** only portrait orientation
        UIDevice.current.setValue(Int(UIInterfaceOrientation.portrait.rawValue), forKey: "orientation")
        
    }
    
    //**** setting scroll view and orientation
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        //**** portrait oreintation
        UIDevice.current.setValue(Int(UIInterfaceOrientation.portrait.rawValue), forKey: "orientation")
        //**** scroll view
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
    //**** for the number of columns in the picker element.
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    //**** for the number of rows of data in the UIPickerView element so we return the array count.
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerDataSource.count;
    }
    //**** for the data for a specific row and specific component.
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerDataSource[row]
    }
    //**** assigning selected values as button label
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        userTypeSelected = pickerDataSource[row]
        lbl_userType?.text = userTypeSelected
    }
    //**** show picker view
    @IBAction func actn_userType(_ sender: Any) {
        self.view.endEditing(true)
        picker_view.isHidden = false
    }
    //**** submit forgot password and request OTP
    @IBAction func actn_submitForgotPassword(_ sender: Any) {
        if(txt_userName.text != nil && lbl_userType.text != "-- select --"){
            usertype_value = lbl_userType?.text ?? " "
            switch (usertype_value){
            case "Member"?:
                usertype_value = "MEMBER"
            case "Administrative"?:
                usertype_value = "Administrative"
            case "Office Incharge(OI)"?:
                usertype_value = "OI"
            case "Marketing Executive(ME)"?:
                usertype_value = "ME"
            case "Direct Selling Agent(DSA)"?:
                usertype_value = "DSA"
            case "Employee"?:
                usertype_value = "EMP"
            default:
                break
            }
            //**** start loading indicator/ preloader
            ActivityIndicator.startAnimating_LoadingIndicator(view: self.view)
            //get api call to pass usertype and username
            let string = "pageKey=forgotPassword&userName="+txt_userName.text!+"&userType="+usertype_value!
            urlConnection(postString: string)
        }
        else{
            //alert action for invaild entry
            let alertController = UIAlertController(title: "Invalid entry", message:
                "Enter username & user type!", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: { action in
                self.txt_userName.text = nil
                self.lbl_userType?.text = "-- select --"
            }))
            self.present(alertController, animated: true, completion: nil)
        }
    }
    //**** clicked back button
    @IBAction func actn_back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
     //**** clicked picker view button
    @IBAction func pickerView_selection(_ sender: Any) {
        lbl_userType?.text = userTypeSelected
        picker_view.isHidden = true
    }
    //**** cancel picker view action
    @IBAction func pickerView_cancel(_ sender: Any) {
        lbl_userType?.text = "-- Select --"
        picker_view.isHidden = true
    }
    //**** keyboard activities
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txt_userName {
            txt_userName.resignFirstResponder()
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
                            //clearing all fields
                            self.txt_userName.text = ""
                            self.lbl_userType?.text = "-- Select --"
                            self.picker_view.isHidden = true
                            //value passing to ForgotPassword_OTPChecking controller
                            //and navigating to ForgotPassword_OTPChecking
                            let forgotPassword = self.storyboard?.instantiateViewController(withIdentifier: "ForgotPassword_OTPChecking") as! ForgotPassword_OTPChecking
                            forgotPassword.userName = self.txt_userName.text!
                            forgotPassword.userType = self.usertype_value!
                            forgotPassword.otp = otpCode as? String
                            forgotPassword.title = "Forgot Password"
                            self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
                            self.navigationController?.pushViewController(forgotPassword, animated: true)
                            let alertController = UIAlertController(title: "OTP Verification", message:
                                msg as? String, preferredStyle: UIAlertControllerStyle.alert)
                            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: { action in
                                self.txt_userName.text = nil
                                self.lbl_userType?.text = "-- select --"
                            }))
                            self.present(alertController, animated: true, completion: nil)
                            
                        }
                        else{
                            let alertController = UIAlertController(title: "Something went wrong", message:
                                "Please try again!", preferredStyle: UIAlertControllerStyle.alert)
                            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: { action in
                                self.txt_userName.text = nil
                                self.lbl_userType?.text = "-- select --"
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
