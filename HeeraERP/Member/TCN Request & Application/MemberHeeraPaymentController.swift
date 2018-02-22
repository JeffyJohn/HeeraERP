//
//  MemberHeeraPaymentController.swift
//  HeeraERP
//
//  Created by Suvan on 12/20/17.
//  Copyright © 2017 Suvan. All rights reserved.
//

import UIKit

class MemberHeeraPaymentController: UIViewController, UITableViewDataSource, UITableViewDelegate,DropDownMenuControllerDelegate,UITextFieldDelegate {
    
    @IBOutlet weak var txt_tcn: UITextField!
    @IBOutlet weak var txt_currency: UITextField!
    @IBOutlet weak var txt_noOfUnits: UITextField!
    @IBOutlet weak var txt_amount: UITextField!
    @IBOutlet weak var txt_applyingFrom: UITextField!
    @IBOutlet weak var txt_depositDate: UITextField!
    @IBOutlet weak var txt_dd_cheque: UITextField!
    @IBOutlet weak var tct_heeraAccountNo: UITextField!
    @IBOutlet weak var btn_heeraPaymentSave: UIButton!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tbl_paymode: UITableView!
    
    var tcnValue:String?
    var unitsValue:String?
    var currencyValue:String?
    var amountValue:String?
    var applyingFromValue:String?
    var tcnId: String?
    var tableCells = ["Pay Mode"]
    var AccessoryDetailValue: String?
    var selectedIndex: Int?
    
    //Uidate picker
    let datePicker = UIDatePicker()
    func acceptData(data: AnyObject!) {
        AccessoryDetailValue = data as? String
        tbl_paymode.reloadData()
    }
    func showDatePicker(){
        //Formate Date
        datePicker.datePickerMode = .date
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        //done button & cancel button
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(MemberHeeraPaymentController.cancelDatePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(MemberHeeraPaymentController.doneDatePicker))
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        // add toolbar to textField
        txt_depositDate.inputAccessoryView = toolbar
        // add datepicker to textField
        txt_depositDate.inputView = datePicker
        datePicker.maximumDate = datePicker.date
    }
    @objc func doneDatePicker(){
        //For date formate
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        txt_depositDate.text = formatter.string(from: datePicker.date)
        //dismiss date picker dialog
        self.view.endEditing(true)
    }
    @objc func cancelDatePicker(){
        //cancel button dismiss datepicker dialog
        self.view.endEditing(true)
    }
    @IBAction func depositeDateEditing(_ sender: Any) {
        //show date picker
        showDatePicker()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //**** text border lines
            BasicProperties.textBorderStyle(textField: txt_tcn)
            BasicProperties.textBorderStyle(textField: txt_currency)
            BasicProperties.textBorderStyle(textField: txt_noOfUnits)
            BasicProperties.textBorderStyle(textField: txt_amount)
            BasicProperties.textBorderStyle(textField: txt_applyingFrom)
            BasicProperties.textBorderStyle(textField: txt_depositDate)
            BasicProperties.textBorderStyle(textField: txt_dd_cheque)
            BasicProperties.textBorderStyle(textField: tct_heeraAccountNo)
            BasicProperties.buttonBorderStyle(button: btn_heeraPaymentSave)
        //**** Override textfields events.
            txt_depositDate.delegate = self
            txt_dd_cheque.delegate = self
            tct_heeraAccountNo.delegate = self
        //**** only portrait orientation
            UIDevice.current.setValue(Int(UIInterfaceOrientation.portrait.rawValue), forKey: "orientation")
        //remove blank spaces after table view
        //tbl_profileDetails.tableFooterView = UIView(frame: CGRect.zero)
        txt_tcn.text = tcnValue!
        txt_currency.text = currencyValue!
        txt_noOfUnits.text = unitsValue!
        txt_amount.text = amountValue!
        txt_applyingFrom.text = applyingFromValue!
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    @objc func keyboardWillShow(notification:NSNotification) {
        scrollView.contentSize = CGSize(width: view.frame.size.width, height: mainView.frame.size.height + 150)
    }
    @objc func keyboardWillHide(notification:NSNotification) {
        scrollView.contentSize = CGSize(width: view.frame.size.width, height: mainView.frame.size.height - 150)
    }
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //**** extending scroll view
            scrollView.contentSize = CGSize(width: view.frame.size.width, height: mainView.frame.size.height)
        //**** only portrait orientation
            UIDevice.current.setValue(Int(UIInterfaceOrientation.portrait.rawValue), forKey: "orientation")
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
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tableCells.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //**** Configure the cell
        let CellIdentifier =  "cells"
        let cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier, for: indexPath)
       // tableView.separatorStyle = .none
        cell.textLabel?.text = tableCells[indexPath.row]
        if((AccessoryDetailValue) != nil){
            if(selectedIndex == indexPath.row){
                cell.detailTextLabel?.text = AccessoryDetailValue
            }
        }
        else{
            cell.detailTextLabel?.text = " "
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        let initController = self.storyboard?.instantiateViewController(withIdentifier: "DropDownMenuController") as! DropDownMenuController
        initController.title = tableCells[indexPath.row]
        initController.cellArray = ["Cheque","DD","Online Transfer","Others"]
        initController.delegate = self
        selectedIndex = indexPath.row
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        self.navigationController?.pushViewController(initController, animated: true )
    }
    @IBAction func actn_savePaymentDetails(_ sender: Any) {
        //**** hide keyboard
        self.view.endEditing(true)
        if (txt_depositDate.text?.isEmpty == true && txt_dd_cheque.text?.isEmpty == true && tct_heeraAccountNo.text?.isEmpty == true)
        {
            let alertController = UIAlertController(title: "Invalid inputs", message:
                "Please fill all the fields!", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: { action in
            }))
            self.present(alertController, animated: true, completion: nil)
        }
        else{
            if(AccessoryDetailValue == nil){
                let alertController = UIAlertController(title: "Invalid inputs", message:
                    "Select Paymode!", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: { action in
                }))
                self.present(alertController, animated: true, completion: nil)
            }
            else{
                //**** loading indicator/ preloader
                ActivityIndicator.startAnimating_LoadingIndicator(view: self.view)
                //**** create a connection to submit tcn request code
                let string = txt_depositDate.text!+"&chequeNo="+txt_dd_cheque.text!+"&heeraAccount="+tct_heeraAccountNo.text!
                let value = self.tcnId!+"&payMode="+AccessoryDetailValue!+"&depositDate="+string
                let postString = "pageKey=tcnApplicationFirstSave&memberId="+GlobalValues.MyVariables.empId!+"&tcnId="+value
                urlConnection(postString: postString)
            }
        }
    }
    //****    keyboard activities
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txt_dd_cheque {
            txt_dd_cheque.resignFirstResponder()
            tct_heeraAccountNo.becomeFirstResponder()
            return true
        }
        else if textField == tct_heeraAccountNo {
            tct_heeraAccountNo.resignFirstResponder()
            view.endEditing(true)
            return true
        }
        return true
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        scrollView.contentSize = CGSize(width: view.frame.size.width, height: mainView.frame.size.height + 10)
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
                            let tcnID = json["tcnId"] as? String
                           // let msg = json["msg"] as? String
                            self.txt_depositDate.text = ""
                            self.txt_dd_cheque.text = ""
                            self.tct_heeraAccountNo.text = ""
                            self.AccessoryDetailValue = "Detail"
                            self.tbl_paymode.reloadData()
                            //**** Instantiate SecondViewController
                            let benefitRemittanceController = self.storyboard?.instantiateViewController(withIdentifier: "MemberBenefitRemittanceController") as! MemberBenefitRemittanceController
                            //**** Take ctrl to next view
                            benefitRemittanceController.tcnID = tcnID!
                            benefitRemittanceController.title = "TCN Application Form"
                            self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
                            self.navigationController?.pushViewController(benefitRemittanceController, animated: true)
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
