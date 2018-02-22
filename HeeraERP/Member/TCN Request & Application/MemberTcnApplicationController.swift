//
//  MemberTcnApplicationController.swift
//  HeeraERP
//
//  Created by Suvan on 12/15/17.
//  Copyright © 2017 Suvan. All rights reserved.
//

import UIKit

class MemberTcnApplicationController : UIViewController,UITextFieldDelegate {
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var txt_tcnRequestCode: UITextField!
    @IBOutlet weak var btn_requestCodeSubmit: UIButton!
    @IBOutlet weak var lbl_today_date: UILabel!
    @IBAction func myButtonTapped(_ sender: Any) {
        //**** Check if value from myTextField is not empty
        if txt_tcnRequestCode.text?.isEmpty == true
        {
            let alertController = UIAlertController(title: "Invaild entry", message:
                "Please enter TCN Request code!", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: { action in
            }))
            self.present(alertController, animated: true, completion: nil)
            return
        }
        else{
            //**** loading indicator/ preloader
            ActivityIndicator.startAnimating_LoadingIndicator(view: self.view)
            //**** create a connection to submit tcn request code
            let value = GlobalValues.MyVariables.userCode!+"&requestCode="+txt_tcnRequestCode.text!
            let postString = "pageKey=tcnRequestCodeSubmit&memberId="+GlobalValues.MyVariables.empId!+"&memberCode="+value
            urlConnection(postString: postString)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //****** side menu toggle ******//
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            //**** Faster slide animation
            revealViewController().toggleAnimationDuration = 0.2
            //****** to change the width of the menu ******//
            self.revealViewController().rearViewRevealWidth = view.frame.width - 70
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        //**** text line border
            BasicProperties.textBorderStyle(textField: txt_tcnRequestCode)
            BasicProperties.buttonBorderStyle(button: btn_requestCodeSubmit)
        //**** get current date
            lbl_today_date.text = BasicProperties.getCurrentDate()
        //**** Override textfields events.
            txt_tcnRequestCode.delegate = self
        //**** only portrait orientation
            UIDevice.current.setValue(Int(UIInterfaceOrientation.portrait.rawValue), forKey: "orientation")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        //**** only portrait orientation
            UIDevice.current.setValue(Int(UIInterfaceOrientation.portrait.rawValue), forKey: "orientation")
    }
    //****    keyboard activities
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txt_tcnRequestCode {
            txt_tcnRequestCode.resignFirstResponder()
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
    func urlConnection(postString: String){
        let url = URL(string: BasicProperties.getMember_Url())!
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
                        //**** loading indicator/ preloader
                        ActivityIndicator.stopAnimating_LoadingIndicator()
                        if(status?.isEqual(1))!{
                            let tcnArray = json["tcnDetails"]
                            var TCN: String?
                            var currency: String?
                            var units: String?
                            var amount: String?
                            var applyingFrom: String?
                            var tcnId: String?
                            for anItem in tcnArray as! [Dictionary<String, AnyObject>] {
                                //**** removing "SCHEME " FROM "SCHEME E"
                                let tcn = anItem["scheme"] as? String
                                let tcn_name = tcn?.components(separatedBy: " ")
                                TCN = "TCN " + tcn_name![1]
                                currency = anItem["currency"] as? String
                                units = anItem["units"] as? String
                                amount = anItem["amount"] as? String
                                applyingFrom = anItem["apply_country"] as? String
                                tcnId = anItem["id"] as? String
                            }
                            self.txt_tcnRequestCode.text = ""
                            //**** Instantiate SecondViewController
                            let heeraPaymentController = self.storyboard?.instantiateViewController(withIdentifier: "MemberHeeraPaymentController") as! MemberHeeraPaymentController
                            //**** Set value to myStringValue
                            heeraPaymentController.tcnValue = TCN!
                            heeraPaymentController.unitsValue = units!
                            heeraPaymentController.currencyValue = currency!
                            heeraPaymentController.amountValue = amount!
                            heeraPaymentController.applyingFromValue = applyingFrom!
                            heeraPaymentController.tcnId = tcnId!
                            //**** Take ctrl to heeraPaymentController
                            heeraPaymentController.title = "TCN Application Form"
                            self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
                            self.navigationController?.pushViewController(heeraPaymentController, animated: true)
                        }
                        else if(status?.isEqual(0))!{
                            let alertController = UIAlertController(title: "Invalid Code", message:
                                "Invalid request code. Please try again!", preferredStyle: UIAlertControllerStyle.alert)
                            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: { action in
                            }))
                            self.present(alertController, animated: true, completion: nil)
                        }
                        else{
                            let alertController = UIAlertController(title: "Somthing went wrong", message:
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
