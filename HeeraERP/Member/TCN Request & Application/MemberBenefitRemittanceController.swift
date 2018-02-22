//
//  MemberBenefitRemittanceController.swift
//  HeeraERP
//
//  Created by Suvan on 12/20/17.
//  Copyright © 2017 Suvan. All rights reserved.
//

import UIKit

class MemberBenefitRemittanceController: UIViewController, UITableViewDataSource, UITableViewDelegate,DropDownMenuControllerDelegate, UITextFieldDelegate {
    @IBOutlet weak var tbl_bankAccount: UITableView!
    @IBOutlet weak var tbl_bankDetails: UITableView!
    @IBOutlet weak var view_bankDetails: UIView!
    @IBOutlet weak var txt_bankAccountNo: UITextField!
    @IBOutlet weak var txt_confirmBankAccount: UITextField!
    @IBOutlet weak var txt_bankName: UITextField!
    @IBOutlet weak var txt_branch: UITextField!
    @IBOutlet weak var txt_ifsc: UITextField!
    @IBOutlet weak var txt_confirmIfsc: UITextField!
    @IBOutlet weak var txt_accountHolderName: UITextField!
    @IBOutlet weak var btn_saveBenefitRemittance: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var tableCells = ["Bank Account Number"]
    var bankAccountNo : String?
    var bankAccounts = [String?]()
    var AccessoryDetailValue: String?
    var selectedIndex: Int?
    var tcnID:String?
    var bankAccountDetails = [String?]()
    var bankAccountDetailsKey = ["Bank Account Number", "Bank Name", "Branch", "IFSC Code", "Account Holder"]
    
    func acceptData(data: AnyObject!) {
        bankAccountNo = data as? String
        AccessoryDetailValue = data as? String
        tbl_bankAccount.reloadData()
        view_bankDetails.isHidden = false
        if(data.isEqual(to: "Others")){
            tbl_bankDetails.isHidden = true
        }
        else{
            //**** loading indicator/ preloader
            ActivityIndicator.startAnimating_LoadingIndicator(view: self.view)
            let postString = "pageKey=bankAccountDetails&memberId="+GlobalValues.MyVariables.empId!+"&accountNo="+bankAccountNo!
            urlConnection(postString: postString, connection: "getAccountDetails")
            tbl_bankDetails.isHidden = false
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //**** initially hiding views
            tbl_bankDetails.isHidden = true
            view_bankDetails.isHidden = true
        //**** text styling and button styling
            BasicProperties.textBorderStyle(textField: txt_bankName)
            BasicProperties.textBorderStyle(textField: txt_confirmBankAccount)
            BasicProperties.textBorderStyle(textField: txt_bankName)
            BasicProperties.textBorderStyle(textField: txt_confirmIfsc)
            BasicProperties.textBorderStyle(textField: txt_branch)
            BasicProperties.textBorderStyle(textField: txt_ifsc)
            BasicProperties.textBorderStyle(textField: txt_accountHolderName)
            BasicProperties.textBorderStyle(textField: txt_bankAccountNo)
            BasicProperties.buttonBorderStyle(button: btn_saveBenefitRemittance)
        //**** remove blank spaces after table view
            tbl_bankAccount.tableFooterView = UIView(frame: CGRect.zero)
            tbl_bankDetails.tableFooterView = UIView(frame: CGRect.zero)
        //**** override textfields events
            txt_bankAccountNo.delegate = self
            txt_confirmBankAccount.delegate = self
            txt_bankName.delegate = self
            txt_branch.delegate = self
            txt_ifsc.delegate = self
            txt_confirmIfsc.delegate = self
            txt_accountHolderName.delegate = self
        //**** only portrait orientation
            UIDevice.current.setValue(Int(UIInterfaceOrientation.portrait.rawValue), forKey: "orientation")
        self.bankAccounts = []
        //**** loading indicator/ preloader
        ActivityIndicator.startAnimating_LoadingIndicator(view: self.view)
        let postString = "pageKey=bankAccounts&memberId="+GlobalValues.MyVariables.empId!
        urlConnection(postString: postString, connection: "getBankAccountNumbers")
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    @objc func keyboardWillShow(notification:NSNotification) {
        scrollView.contentSize = CGSize(width: view.frame.size.width, height: view_bankDetails.frame.size.height + 150)
    }
    @objc func keyboardWillHide(notification:NSNotification) {
       scrollView.contentSize = CGSize(width: view.frame.size.width, height: view_bankDetails.frame.size.height - 150)
    }
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //**** extending scroll view
            scrollView.contentSize = CGSize(width: view.frame.size.width, height: view_bankDetails.frame.size.height)
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
        if(tableView == tbl_bankAccount){
            return tableCells.count
        }
        else{
            return bankAccountDetailsKey.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //**** Configure the cell
        if(tableView == tbl_bankAccount)
        {
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
        else{
            let cell = Bundle.main.loadNibNamed("TwoLabelTableViewCell", owner: self, options: nil)?.first as! TwoLabelTableViewCell
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            cell.lbl_key.text = bankAccountDetailsKey[indexPath.row]
            if(bankAccountDetails.isEmpty == false){
                cell.lbl_value.text = bankAccountDetails[indexPath.row]
            }
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        let initController = self.storyboard?.instantiateViewController(withIdentifier: "DropDownMenuController") as! DropDownMenuController
        if(tableView == tbl_bankAccount){
            initController.title = tableCells[indexPath.row]
            initController.cellArray = bankAccounts as! [String]
            selectedIndex = indexPath.row
        }
        initController.delegate = self
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        self.navigationController?.pushViewController(initController, animated: true )
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(tableView == tbl_bankDetails)
        {
            return 44
        }
        else{
            return 50
        }
    }
    @IBAction func actn_saveBenifitRemittance(_ sender: Any) {
        if(AccessoryDetailValue == "Others"){
             //add new bank account details
            if(txt_bankAccountNo.text?.isEmpty == false && txt_bankName.text?.isEmpty == false && txt_branch.text?.isEmpty == false && txt_accountHolderName.text?.isEmpty == false){
                if((txt_bankAccountNo.text! == txt_confirmBankAccount.text!) && (txt_ifsc.text! == txt_confirmIfsc.text!)){
                    //**** loading indicator/ preloader
                    ActivityIndicator.startAnimating_LoadingIndicator(view: self.view)
                    //add new bank account details
                    let value = "&bankName="+txt_bankName.text!+"&branchName="+txt_branch.text!+"&ifscCode="+txt_ifsc.text!+"&name="+txt_accountHolderName.text!
                    let postString = "pageKey=addBankAccount&memberId="+GlobalValues.MyVariables.empId!+"&accountNo="+AccessoryDetailValue!+"&tcnId="+tcnID!+value
                    urlConnection(postString: postString, connection: "addNewBankAccount")
                }
                else if(txt_bankAccountNo.text! == txt_confirmBankAccount.text!){
                    let alertController = UIAlertController(title: "Invalid inputs", message:
                        "Bank account number & confirm bank account number should be same.!", preferredStyle: UIAlertControllerStyle.alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: { action in
                    }))
                    self.present(alertController, animated: true, completion: nil)
                }
                else if(txt_ifsc.text! == txt_confirmIfsc.text!){
                    let alertController = UIAlertController(title: "Invalid inputs", message:
                        "IFSC code & confirm IFSC code should be same.!", preferredStyle: UIAlertControllerStyle.alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: { action in
                    }))
                    self.present(alertController, animated: true, completion: nil)
                }
            }
            else{
                let alertController = UIAlertController(title: "Invalid inputs", message:
                    "Please enter all fields!", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: { action in
                }))
                self.present(alertController, animated: true, completion: nil)
            }
        }
        else if(AccessoryDetailValue?.isEmpty == true){
            let alertController = UIAlertController(title: "Invalid input", message:
                "Please select bank account number or add new account!", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: { action in
            }))
            self.present(alertController, animated: true, completion: nil)
        }
        else{
            //**** loading indicator/ preloader
            ActivityIndicator.startAnimating_LoadingIndicator(view: self.view)
            //existing bank acount
            let postString = "pageKey=accountSubmit&memberId="+GlobalValues.MyVariables.empId!+"&accountNo="+AccessoryDetailValue!+"&tcnId="+tcnID!
            urlConnection(postString: postString, connection: "existingBankAccount")
        }
    }
    //****    keyboard activities
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txt_bankAccountNo {
            txt_bankAccountNo.resignFirstResponder()
            txt_confirmBankAccount.becomeFirstResponder()
            return true
        }
        else if textField == txt_confirmBankAccount {
            txt_confirmBankAccount.resignFirstResponder()
            txt_bankName.becomeFirstResponder()
            return true
        }
        else if textField == txt_bankName {
            txt_bankName.resignFirstResponder()
            txt_branch.becomeFirstResponder()
            return true
        }
        else if textField == txt_branch {
            txt_branch.resignFirstResponder()
            txt_ifsc.becomeFirstResponder()
            return true
        }
        else if textField == txt_ifsc{
            txt_ifsc.resignFirstResponder()
            txt_confirmIfsc.becomeFirstResponder()
            return true
        }
        else if textField == txt_confirmIfsc {
            txt_confirmIfsc.resignFirstResponder()
            txt_accountHolderName.becomeFirstResponder()
            return true
        }
        else if textField == txt_accountHolderName {
            txt_accountHolderName.resignFirstResponder()
            self.view.endEditing(true)
        }
        return true
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        scrollView.contentSize = CGSize(width: view.frame.size.width, height: view_bankDetails.frame.size.height - 10)
        return true
    }
    //**** hide keyboard when toches the background
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    func urlConnection(postString: String, connection: String){
        // self.bankAccounts = []
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
                            if(connection == "getBankAccountNumbers"){
                                let account = json["bankAccounts"]
                                for anItem in account as! [Dictionary<String, AnyObject>]{
                                    self.bankAccounts.append(anItem["profit_acc_no"] as? String)
                                }
                                self.bankAccounts.append("Others")
                            }
                            else if(connection == "getAccountDetails"){
                                let details = json["bankAccountDetails"]
                                for anItem in details as! [Dictionary<String, AnyObject>]{
                                    self.bankAccountDetails.append(anItem["profit_acc_no"] as? String)
                                    self.bankAccountDetails.append(anItem["profit_bank"] as? String)
                                    self.bankAccountDetails.append(anItem["profit_branch"] as? String)
                                    self.bankAccountDetails.append(anItem["profit_ifsc"] as? String)
                                    self.bankAccountDetails.append(anItem["acc_name"] as? String)
                                }
                                self.tbl_bankDetails.reloadData()
                            }
                            else if(connection == "existingBankAccount" || connection == "addNewBankAccount") {
                                let tcnId = json["tcnId"] as? String
                                self.AccessoryDetailValue = "Detail"
                                self.txt_bankAccountNo.text = ""
                                self.txt_confirmBankAccount.text = ""
                                self.txt_bankName.text = ""
                                self.txt_branch.text = ""
                                self.txt_ifsc.text = ""
                                self.txt_confirmIfsc.text = ""
                                self.txt_accountHolderName.text = ""
                                self.tbl_bankAccount.reloadData()
                                //**** initially hiding views
                                self.tbl_bankDetails.isHidden = true
                                self.view_bankDetails.isHidden = true
                                //**** Instantiate SecondViewController
                                let nomineeDetailsController = self.storyboard?.instantiateViewController(withIdentifier: "NomineeDetailsController") as! MemberNomineeDetailsController
                                //**** Take ctrl to next view
                                nomineeDetailsController.tcnId = tcnId!
                                nomineeDetailsController.nomineeNumber = "1"
                                nomineeDetailsController.title = "TCN Application Form"
                                self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
                                self.navigationController?.pushViewController(nomineeDetailsController, animated: true)
                            }
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
