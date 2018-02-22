//
//  MemberMyAccountController.swift
//  HeeraERP
//
//  Created by Suvan on 12/15/17.
//  Copyright © 2017 Suvan. All rights reserved.
//

import UIKit

class MemberMyAccountController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    //linking nib outlets/fields with controller
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var lbl_today_date: UILabel!
    @IBOutlet weak var lbl_segmentlabel: UILabel!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    var selectedSegment: String?
    var empId: String = ""
    var tcnArray = [String?]()
    var unitsArray = [String?]()
    var amountArray = [String?]()
    var currencyArray = [String?]()
    var approved_dateArray = [String?]()
    var recieved_dateArray = [String?]()
    var withdrawal_requestArray = [String?]()
    var office_dateArray = [String?]()
    var tcnIdArrary = [String?]()
    
    static fileprivate let kTableViewCellReuseIdentifier = "TableViewCellReuseIdentifier"
    @IBOutlet fileprivate weak var tableView: FZAccordionTableView!
   
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
        //**** get current date
            lbl_today_date.text = BasicProperties.getCurrentDate()
        //**** default value
        selectedSegment = "Pending Approvals"
        empId  = GlobalValues.MyVariables.empId!
        //**** starting loading indicator/ preloader
        ActivityIndicator.startAnimating_LoadingIndicator(view: self.view)
        let string = "pageKey=pendingTcn&memberId="+empId
        urlConnection(postString: string, connection: "pendingApprovals")
        //**** remove blank spaces after table view
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        //**** accordion view
        tableView.allowMultipleSectionsOpen = false
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: MemberMyAccountController.kTableViewCellReuseIdentifier)
        tableView.register(UINib(nibName: "MemberMyAccountCell", bundle: nil), forHeaderFooterViewReuseIdentifier: MemberMyAccountCell.kAccordionHeaderViewReuseIdentifier)
    } 
    @IBAction func actn_myAccountSegment(_ sender: Any) {
        //**** loading indicator/ preloader
        ActivityIndicator.startAnimating_LoadingIndicator(view: self.view)
        switch segmentedControl.selectedSegmentIndex
        {
        case 0:
            lbl_segmentlabel.text = "Pending Approvals"
            let string = "pageKey=pendingTcn&memberId="+empId
            urlConnection(postString: string, connection: "pendingApprovals")
        case 1:
            lbl_segmentlabel.text = "Active TCN"
            let string = "pageKey=activeTcn&memberId="+empId
            urlConnection(postString: string, connection: "activeTcn")
        case 2:
            lbl_segmentlabel.text = "Withdrawn TCN"
            let string = "pageKey=withdrawnTcn&memberId="+empId
            urlConnection(postString: string, connection: "withdrawnTcn")
        default:
            break
        }
        selectedSegment = lbl_segmentlabel.text
        tableView.reloadData()
    }
    // MARK: - <UITableViewDataSource> / <UITableViewDelegate> -
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
         return tcnArray.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(selectedSegment == "Withdrawn TCN"){
            return 300
        }
        return 200
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var value: String
        if(selectedSegment == "Pending Approvals"){
             value = tcnArray[section]! + "         " + unitsArray[section]!
        }
        else if(selectedSegment == "Active TCN"){
             value = tcnArray[section]! + "         " + unitsArray[section]!
        }
        else if(selectedSegment == "Withdrawn TCN"){
             value = tcnArray[section]! + "         " + unitsArray[section]!
        }
        else{
             value = tcnArray[section]! + "         " + unitsArray[section]!
        }
        let headerValue = String(section+1) + "         "+value
        return headerValue
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return MemberMyAccountCell.kDefaultAccordionHeaderViewHeight
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.tableView(tableView, heightForRowAt: indexPath)
    }
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return self.tableView(tableView, heightForHeaderInSection:section)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.separatorStyle = .none
        if(selectedSegment == "Active TCN"){
            let cell = Bundle.main.loadNibNamed("MemberActiveTcnCell", owner: self, options: nil)?.first as! MemberActiveTcnCell
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            cell.txt_tcn.text = tcnArray[indexPath.section]
            cell.txt_units.text = unitsArray[indexPath.section]
            cell.txt_amount.text = amountArray[indexPath.section]
            cell.txt_currency.text = currencyArray[indexPath.section]
            cell.txt_approvedDate.text = approved_dateArray[indexPath.section]
            cell.btn_withdraw.isHidden = true
            //cell.btn_withdraw.addTarget(self, action: #selector(actn_withdrawActiveTcn(sender:)), for: UIControlEvents.touchUpInside)
            return cell
        }
        else if(selectedSegment == "Withdrawn TCN"){
            let cell = Bundle.main.loadNibNamed("MemberWithdrawnTcnCell", owner: self, options: nil)?.first as! MemberWithdrawnTcnCell
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            cell.txt_tcn.text = tcnArray[indexPath.section]
            cell.txt_units.text = unitsArray[indexPath.section]
            cell.txt_amount.text = amountArray[indexPath.section]
            cell.txt_currency.text = currencyArray[indexPath.section]
            cell.txt_approvedDate.text = approved_dateArray[indexPath.section]
            cell.btn_view.tag = Int(tcnIdArrary[indexPath.section]!)!
            cell.btn_view.addTarget(self, action: #selector(actn_viewWithdrawnTcn(sender:)), for: UIControlEvents.touchUpInside)
            return cell
        }
        else{
            let cell = Bundle.main.loadNibNamed("MemberPendingApprovalsCell", owner: self, options: nil)?.first as! MemberPendingApprovalsCell
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            cell.txt_tcn.text = tcnArray[indexPath.section]
            cell.txt_units.text = unitsArray[indexPath.section]
            cell.txt_amount.text = amountArray[indexPath.section]
            cell.txt_currency.text = currencyArray[indexPath.section]
            cell.btn_addPaymentDetails.isHidden = true
            //cell.btn_addPaymentDetails.addTarget(self, action: #selector(actn_addPaymentDetails(sender:)),for: UIControlEvents.touchUpInside)
            return cell
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return tableView.dequeueReusableHeaderFooterView(withIdentifier: MemberMyAccountCell.kAccordionHeaderViewReuseIdentifier)
    }
    func urlConnection(postString: String, connection: String){
        self.tcnArray = []
        self.unitsArray = []
        self.amountArray =  []
        self.currencyArray = []
        self.approved_dateArray = []
        self.recieved_dateArray = []
        self.withdrawal_requestArray = []
        self.tcnIdArrary = []
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
                        //**** stopping loading indicator/ preloader
                        ActivityIndicator.stopAnimating_LoadingIndicator()
                        if(status?.isEqual(1))!{
                            switch (connection){
                                case "pendingApprovals":
                                    let pendingTcn = json["pendingTcn"]
                                    for anItem in pendingTcn as! [Dictionary<String, AnyObject>] { // or [[String:AnyObject]]
                                        var scheme = anItem["scheme"] as? String
                                        let value = scheme?.components(separatedBy: " ")
                                        scheme = "TCN "+value![1]
                                        self.tcnArray.append(scheme)
                                        self.unitsArray.append(anItem["units"] as? String)
                                        self.amountArray.append(anItem["amount"] as? String)
                                        self.currencyArray.append(anItem["currency"] as? String)
                                    }
                                case "activeTcn":
                                    let activeTcn = json["activeTcn"]
                                    for anItem in activeTcn as! [Dictionary<String, AnyObject>] { // or [[String:AnyObject]]
                                        var scheme = anItem["scheme"] as? String
                                        let value = scheme?.components(separatedBy: " ")
                                        scheme = "TCN "+value![1]
                                        self.tcnArray.append(scheme)
                                        self.unitsArray.append(anItem["units"] as? String)
                                        self.amountArray.append(anItem["amount"] as? String)
                                        self.currencyArray.append(anItem["currency"] as? String)
                                        self.approved_dateArray.append(anItem["approved_date"] as? String)
                                        self.recieved_dateArray.append(anItem["recieved_date"] as? String)
                                        self.withdrawal_requestArray.append(anItem["withdrawal_request"] as? String)
                                    }
                                case "withdrawnTcn":
                                    let withdrawnTcn = json["withdrawnTcn"]
                                    for anItem in withdrawnTcn as! [Dictionary<String, AnyObject>] { // or [[String:AnyObject]]
                                        var scheme = anItem["scheme"] as? String
                                        let value = scheme?.components(separatedBy: " ")
                                        scheme = "TCN "+value![1]
                                        self.tcnArray.append(scheme)
                                        self.unitsArray.append(anItem["units"] as? String)
                                        self.amountArray.append(anItem["amount"] as? String)
                                        self.currencyArray.append(anItem["currency"] as? String)
                                        self.approved_dateArray.append(anItem["approved_date"] as? String)
                                        self.tcnIdArrary.append(anItem["id"] as? String)
                                    }
                                default:
                                    break
                            }
                            self.tableView.reloadData()
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
    @objc func actn_addPaymentDetails(sender:UIButton!){
        //**** Instantiate SecondViewController
         let SecondViewController = self.storyboard?.instantiateViewController(withIdentifier: "MemberAccountPaymentDetailsController") as! MemberAccountPaymentDetailsController
        // SecondViewController.myStringValue = txt_tcnRequestCode.text
         SecondViewController.title = "My Account"
         navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
         self.navigationController?.pushViewController(SecondViewController, animated: true)
    }
    @objc func actn_withdrawActiveTcn(sender:UIButton){
        //**** Instantiate SecondViewController
        let SecondViewController = self.storyboard?.instantiateViewController(withIdentifier: "MemberAccountWithdrawnPaymentController") as! MemberAccountWithdrawnPaymentController
        // SecondViewController.myStringValue = txt_tcnRequestCode.text
        SecondViewController.title = "My Account"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        self.navigationController?.pushViewController(SecondViewController, animated: true)
    }
    @objc func actn_viewWithdrawnTcn(sender:UIButton){
        //**** Instantiate SecondViewController
        let SecondViewController = self.storyboard?.instantiateViewController(withIdentifier: "MemberviewWithdrawnTcnController") as! MemberviewWithdrawnTcnController
        // **** Set value to myStringValue
        let tcnId = sender.tag
         SecondViewController.myStringValue = String(tcnId)
        SecondViewController.title = "My Account"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        self.navigationController?.pushViewController(SecondViewController, animated: true)
    }
}
