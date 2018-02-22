//
//  MemberTcnRequestController.swift
//  HeeraERP
//
//  Created by Suvan on 12/15/17.
//  Copyright © 2017 Suvan. All rights reserved.
//

import UIKit

class MemberTcnRequestController: UIViewController, UITableViewDelegate, UITableViewDataSource,DropDownMenuControllerDelegate{
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var btn_submit: UIButton!
    @IBOutlet weak var tbl_tcnRequest: UITableView!
    @IBOutlet weak var lbl_today_date: UILabel!
    
    var tableCells = ["TCN","Applying From","Currency","No. of Units"]
    var selectedValue: String = " ";
    var AccessoryDetailValue: String?
    var selectedIndex: Int?
    var tcn: String?
    var applyingFrom: String?
    var currency: String?
    var no_ofUnits: String?
    var tcnValues = [String]()
    var country = [String]()
    var amount = [String?]()
    
    func acceptData(data: AnyObject!) {
        AccessoryDetailValue = data as? String
        switch(selectedIndex){
        case 0?:
            tcn = AccessoryDetailValue
        case 1?:
            applyingFrom = AccessoryDetailValue
        case 2?:
            currency = AccessoryDetailValue
        case 3?:
            no_ofUnits = AccessoryDetailValue
        default:
            break
        }
        if(tcn?.isEmpty == false || currency?.isEmpty == false || no_ofUnits?.isEmpty == false){
            if((currency) == nil){
                currency = "0"
            }
            if((no_ofUnits) == nil){
                no_ofUnits = "0"
            }
            if((tcn) == nil){
                tcn = "0"
            }
            if((tcn) != nil){
                let value = tcn?.components(separatedBy: " ")
                tcn = "Scheme "+value![1]
            }
            //**** create a connection to calculate amount
            let postString = "pageKey=tcnAmount&tcn="+tcn!+"&currency="+currency!+"&units="+no_ofUnits!
            urlConnection(postString: postString, connection: "calculateAmount")
        }
        self.tbl_tcnRequest.reloadData()
    }
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
            //**** button border
        BasicProperties.buttonBorderStyle(button: btn_submit)
            //**** get current date
        lbl_today_date.text = BasicProperties.getCurrentDate()
        //txt_amount.isUserInteractionEnabled = false
        //**** loading indicator/ preloader
        ActivityIndicator.startAnimating_LoadingIndicator(view: self.view)
         //**** create a connection to get countires and tcn
        let postString = "pageKey=tcnRequestSelect"
        urlConnection(postString: postString, connection: "defaultLoad")
    }
    // MARK: - Table view data source
     func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        let count = tableCells.count + 1
        return count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //**** Configure the cell
        let CellIdentifier =  "cells"
        let cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier, for: indexPath)
        tableView.separatorStyle = .none
        if(indexPath.row == 4){
            let cells = Bundle.main.loadNibNamed("TwoLabelTableViewCell", owner: self, options: nil)?.first as! TwoLabelTableViewCell
            cells.selectionStyle = UITableViewCellSelectionStyle.none
            cells.lbl_key.font = UIFont(name: "System - System", size: CGFloat(17))
            cells.lbl_value.font = UIFont(name: "System - System", size: CGFloat(17))
            cells.lbl_value.textAlignment = .right
            cells.lbl_key.text = "Amount"
            cells.isUserInteractionEnabled = false
            if(amount.isEmpty == false){
               cells.lbl_value.text = amount[indexPath.section]
            }
            return cells
        }
        else{
           cell.textLabel?.text = tableCells[indexPath.row]
        }
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
        switch (indexPath.row) {
        case 0:
            initController.title = "TCN"
            initController.cellArray = self.tcnValues
        case 1:
            initController.title = "Applying From"
            initController.cellArray = self.country
        case 2:
            initController.title = "Currency"
            initController.cellArray = ["INR","SAR","CAD","USD"]
        case 3:
            initController.title = "No Of Units"
            var integerArray = [Int]()
            for i in 0...1000 {
                integerArray.append(i)
            }
            let stringArray = integerArray.map
            {
                String($0)
            }
            initController.cellArray = stringArray
        default:
            break
        }
        selectedIndex = indexPath.row
        initController.delegate = self
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        self.navigationController?.pushViewController(initController, animated: true )
    }
    @IBAction func actn_tcnRequest(_ sender: Any) {
        if(tcn?.isEmpty == false || currency?.isEmpty == false || no_ofUnits?.isEmpty == false || applyingFrom?.isEmpty == false){
            let empid = GlobalValues.MyVariables.empId
            let userCode = GlobalValues.MyVariables.userCode
            print(self.amount[0] ?? " ")
            var amountValue :String?
            if(amount.isEmpty == false){
                amountValue = amount[0]
            }
            else{
                amountValue = "0"
            }
            let string = empid!+"&memberCode="+userCode!+"&amount="+amountValue!
            //**** loading indicator/ preloader
            ActivityIndicator.startAnimating_LoadingIndicator(view: self.view)
            //**** create a connection to submit tcn request 
            let postString = "pageKey=tcnRequestSubmit&tcn="+tcn!+"&currency="+currency!+"&units="+no_ofUnits!+"&memberId="+string
            urlConnection(postString: postString, connection: "tcnSubmit")
        }
        else{
            let alertController = UIAlertController(title: "Invalid inputs", message: "Please enter all fields!", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: { action in
            }))
            self.present(alertController, animated: true, completion: nil)
        }
    }
    func urlConnection(postString: String, connection: String){
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
                       if(connection == "tcnSubmit"){
                            if(status?.isEqual(1))!{
                                let requedstCode = json["requestCode"] as? String
                                var tcn = json["tcn"] as? String
                                if((tcn) != nil){
                                    let value = tcn?.components(separatedBy: " ")
                                    tcn = "TCN "+value![1]
                                }
                                let bank = json["bank"] as? String
                                let branch = json["branch"] as? String
                                let account = json["account"] as? String
                                let ifsc = json["ifsc"] as? String
                                // **** actionsheet with alertController for dismiss login action
                                let tcnMessage_heading = "Successfullt Submit TCN Request"
                                let tcnMessage_requestCode = "\nTCN Request Code: "+requedstCode!+" \n\n"
                                let tcnMessage_tcn = tcn!+"\n"
                                let tcnMessage_bank = "Bank Name: "+bank!+" \n"
                                let tcnMessage_branch = "Branch Name: "+branch!+" \n"
                                let tcnMessage_accountNo = "Account Number: "+account!+" \n"
                                let tcnMessage_ifscCode = "IFSC Code: "+ifsc!+"\n\n"
                                let mainMessage = tcnMessage_requestCode + tcnMessage_tcn + tcnMessage_bank + tcnMessage_branch + tcnMessage_accountNo + tcnMessage_ifscCode
                                let alertController = UIAlertController(title: tcnMessage_heading, message: mainMessage, preferredStyle: UIAlertControllerStyle.alert)
                                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: { action in
                                }))
                                self.present(alertController, animated: true, completion: nil)
                            }
                            else if(status?.isEqual(2))!{
                                let mainMessage = json["msg"] as? String
                                let alertController = UIAlertController(title: "Already applied", message: mainMessage, preferredStyle: UIAlertControllerStyle.alert)
                                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: { action in
                                }))
                                self.present(alertController, animated: true, completion: nil)
                            }
                            else{
                                //connection lost or somthething went wrong!!!! login again
                                let alertController = UIAlertController(title: "Something went wrong", message: "Please try again!", preferredStyle: UIAlertControllerStyle.alert)
                                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: { action in
                                }))
                                self.present(alertController, animated: true, completion: nil)
                            }
                        }
                       else if(connection == "defaultLoad"){
                            if(status?.isEqual(1))!{
                                let tcnArray = json["getTcn"]
                                let countries = json["countries"]
                                //**** removing "SCHEME " FROM "SCHEME E"
                                for anItem in tcnArray as! [Dictionary<String, AnyObject>] {
                                    let tcn = anItem["scheme"] as? String
                                    let tcn_name = tcn?.components(separatedBy: " ")
                                    let TCN = "TCN " + tcn_name![1]
                                    self.tcnValues.append(TCN)
                                }
                                for anItem in countries as! [Dictionary<String, AnyObject>] {
                                    self.country.append(anItem["value"]! as! String)
                                }
                            }
                            else{
                                //connection lost or somthething went wrong!!!! login again
                                let alertController = UIAlertController(title: "Something went wrong", message: "Please try again!", preferredStyle: UIAlertControllerStyle.alert)
                                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: { action in
                                }))
                                self.present(alertController, animated: true, completion: nil)
                            }
                        }
                        else if(connection == "calculateAmount"){
                        self.amount = []
                            if(status?.isEqual(1))!{
                                let amountValue = json["amount"]
                                self.amount.append(String(describing: amountValue!))
                                self.tbl_tcnRequest.reloadData()
                            }
                            else if(status?.isEqual(0))!{
                                self.amount = ["0"]
                                self.tbl_tcnRequest.reloadData()
                            }
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
