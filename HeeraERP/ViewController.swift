//
//  ViewController.swift
//  HeeraERP
//
//  Created by Suvan on 12/14/17.
//  Copyright © 2017 Suvan. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
//**** connecting input variables to controller 
    @IBOutlet weak var txt_username: UITextField!
    @IBOutlet weak var txt_password: UITextField!
    @IBOutlet weak var btn_userTypeSelection: UIButton!
    @IBOutlet weak var btn_login: UIButton!
    @IBOutlet weak var btn_forgotPassword: UIButton!
    @IBOutlet weak var picker_view_userType: UIPickerView!
    @IBOutlet weak var picker_view: UIView!
    @IBOutlet weak var picker_bar: UIToolbar!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var lbl_usertype: UILabel!
    //globaly declared variables
    var data = NSMutableData()
    var usertype_value :String?
    var pickerData:String?
    var userTypeSelected :String?
    var pickerDataSource = ["-- select --","Member","Administrative", "Office Incharge", "Marketing Executive", "Direct Selling Agent","Employee"]

    override func viewDidLoad() {
        super.viewDidLoad()
        //**** only portrait orientation
        UIDevice.current.setValue(Int(UIInterfaceOrientation.portrait.rawValue), forKey: "orientation")
        //**** Override username and password events.
            txt_username.delegate = self
            txt_password.delegate = self
        //**** username text border line
            BasicProperties.textBorderStyle(textField: txt_username)
        //**** password text border line
            BasicProperties.textBorderStyle(textField: txt_password)
        //**** login button border
            BasicProperties.buttonBorderStyle(button: btn_login)
        //**** user type button border
            BasicProperties.buttonBorderStyle(button: btn_userTypeSelection)
        //**** usertype selection picker hidden
            picker_view.isHidden = true
        //**** set default values for username and password
            txt_username.text = nil
            txt_password.text = nil
            self.lbl_usertype?.text = "-- select --"
    }
    //**** setting scroll view and orientation
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        //**** portrait oreintation
            UIDevice.current.setValue(Int(UIInterfaceOrientation.portrait.rawValue), forKey: "orientation")
        //**** scroll view
            scrollView.contentSize = CGSize(width: view.frame.size.width, height: mainView.frame.size.height)
        //**** set default values for username and password
        txt_username.text = nil
        txt_password.text = nil
        self.lbl_usertype?.text = "-- select --"
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
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //**** user type selection click
    @IBAction func actn_userType(_ sender: Any) {
        self.view.endEditing(true)
        picker_view.isHidden = false
    }
    //**** get input datas and login process
    @IBAction func actn_login(_ sender: Any) {
         //**** hide keyboard
        view.endEditing(true)
        //**** hide picker view
        picker_view.isHidden = true
        //**** checking login  credentials
        if((txt_username.text?.isEmpty)! || (txt_password.text?.isEmpty)!){
            //**** stop animating
            UIApplication.shared.endIgnoringInteractionEvents()
            let alertController = UIAlertController(title: "Login Failed", message:
                "Enter login credentials properly!", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: { action in
                self.txt_username.text = nil
                self.txt_password.text = nil
                self.lbl_usertype?.text = "-- select --"
            }))
           // alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
        else{
            if(lbl_usertype?.text == "-- select --"){
                
                let alertController = UIAlertController(title: "Login Failed", message:
                    "Select user type!", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: { action in
                }))
               // alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
                self.present(alertController, animated: true, completion: nil)
            }
            else{
                //**** starting loading indicator/ preloader
                ActivityIndicator.startAnimating_LoadingIndicator(view: self.view)
                let userType = lbl_usertype?.text ?? " "
                switch (userType){
                case "Member":
                    usertype_value = "MEMBER"
                case "Administrative":
                    usertype_value = "Administrative"
                case "Office Incharge":
                    usertype_value = "OI"
                case "Marketing Executive":
                    usertype_value = "ME"
                case "Direct Selling Agent":
                    usertype_value = "DSA"
                case "Employee":
                    usertype_value = "EMP"
                default:
                    break
                }
                let string = "pageKey=login&userName="+txt_username.text!+"&password="+txt_password.text!+"&userType="+usertype_value!
                urlConnection(postString: string, usertype: userType)
            }
        }
    }
    //connecting to remote server and get response
    func urlConnection(postString: String, usertype : String){
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
                        //**** stoping loading indicator/ preloader
                        ActivityIndicator.stopAnimating_LoadingIndicator()
                        if(status?.isEqual(1))!{
                            //**** assign values to GlobalValues.swift
                            switch (usertype){
                            case "MEMBER":
                                let photo_name = json["userPhoto"]?.components(separatedBy: "member_photos/")
                                let userPhoto = BasicProperties.getMemberPhoto_Url() + photo_name![1]
                                GlobalValues.MyVariables.userName = json["userName"] as? String
                                GlobalValues.MyVariables.userPhoto = userPhoto
                                GlobalValues.MyVariables.userCode = json["userCode"] as? String
                                GlobalValues.MyVariables.empId = json["empId"]  as? String
                                let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                                let initController: UIViewController = storyboard.instantiateViewController(withIdentifier: "SWRevealViewMemberController")
                                self.present(initController,animated: false, completion: nil)
                            case "Office Incharge":
                                GlobalValues.MyVariables.userName = json["userName"] as? String
                                GlobalValues.MyVariables.empId = json["empId"]  as? String
                                let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                                let initController: UIViewController = storyboard.instantiateViewController(withIdentifier: "SWRevealViewOfficeController")
                                self.present(initController,animated: false, completion: nil)
                            default:
                                break
                            }
                        }
                        else{
                            let alertController = UIAlertController(title: "Login Failed", message:
                                "Worng Username and password!", preferredStyle: UIAlertControllerStyle.alert)
                            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: { action in
                                self.txt_username.text = nil
                                self.txt_password.text = nil
                                self.lbl_usertype?.text = "-- select --"
                            }))
                            // alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
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
        lbl_usertype?.text = userTypeSelected
    }
    //**** clicked picker view button
    @IBAction func pickerView_selection(_ sender: Any) {
        lbl_usertype?.text = userTypeSelected
        picker_view.isHidden = true
    }
    //**** cancel picker view action
    @IBAction func pickerView_cancel(_ sender: Any) {
        lbl_usertype?.text = "-- Select --"
        picker_view.isHidden = true
    }
    //**** keyboard activities
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txt_username {
            txt_username.resignFirstResponder()
            txt_password.becomeFirstResponder()
            return true
        }
        else if textField == txt_password {
            txt_password.resignFirstResponder()
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
    //navigate to ForgotPassword controller for restting password
    @IBAction func actn_forgotPassword(_ sender: Any) {
        self.view.endEditing(true)
        var viewController = UIViewController()
        viewController = self.storyboard?.instantiateViewController(withIdentifier: "ForgotPassword") as! ForgotPassword
        viewController.title = "Forgot Password"
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        self.navigationController?.present(viewController, animated: true)
    }
}
