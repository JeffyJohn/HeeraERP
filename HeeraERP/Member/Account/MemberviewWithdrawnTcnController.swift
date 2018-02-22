//
//  MemberviewWithdrawnTcnController.swift
//  HeeraERP
//
//  Created by Suvan on 1/5/18.
//  Copyright © 2018 Suvan. All rights reserved.
//

import UIKit

class MemberviewWithdrawnTcnController: UIViewController , UITableViewDelegate, UITableViewDataSource {
    
    static fileprivate let kTableViewCellReuseIdentifier = "TableViewCellReuseIdentifier"
    @IBOutlet fileprivate weak var tableView: FZAccordionTableView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var lbl_paymentNo_ofUnits: UILabel!
    @IBOutlet weak var lbl_payment_amount: UILabel!
    @IBOutlet weak var lbl_payment_payMode: UILabel!
    @IBOutlet weak var lbl_payment_date: UILabel!
    @IBOutlet weak var lbl_payment_bankName: UILabel!
    @IBOutlet weak var lbl_tcn_currency: UILabel!
    @IBOutlet weak var lbl_tcn_no_ofUnits: UILabel!
    @IBOutlet weak var lbl_tcn_amount: UILabel!
    @IBOutlet weak var lbl_tcn_payMode: UILabel!
    @IBOutlet weak var lbl_tcn_date: UILabel!
    @IBOutlet weak var lbl_tcn_dd_cheque: UILabel!
    @IBOutlet weak var lbl_tcn_bank: UILabel!
    @IBOutlet weak var lbl_tcn_branchName: UILabel!
    
    var myStringValue:String?
    var tableHeader = ["Nominee Details"]
    var nomineeNameArrary = [String?]()
    var dobArrary = [String?]()
    var relationArrary = [String?]()
    var residentialArrary = [String?]()
    var cityArrary = [String?]()
    var pinArrary = [String?]()
    var mobileArrary = [String?]()
    var telArrary = [String?]()
    var emailArrary = [String?]()
    var genderArrary = [String?]()
    var photoNameArrary = [String?]()
    var signatureNameArrary = [String?]()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        //**** loading indicator/ preloader
        ActivityIndicator.startAnimating_LoadingIndicator(view: self.view)
        let postString = "pageKey=viewWithdrawnTcn&tcnId="+myStringValue!+"&memberCode="+GlobalValues.MyVariables.userCode!
        urlConnection(postString: postString)
        //**** disable scroll view indicator
        scrollView.showsVerticalScrollIndicator = false
        //**** remove blank spaces after table view
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        //**** accordion view
        tableView.allowMultipleSectionsOpen = false
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: MemberviewWithdrawnTcnController.kTableViewCellReuseIdentifier)
        tableView.register(UINib(nibName: "MemberMyAccountCell", bundle: nil), forHeaderFooterViewReuseIdentifier: MemberMyAccountCell.kAccordionHeaderViewReuseIdentifier)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //**** extending scroll view
        scrollView.contentSize = CGSize(width: view.frame.size.width, height: mainView.frame.size.height)
        //        if view_nomineeDetails.frame.size.height > view.frame.size.height {
        //            scrollView.contentSize = CGSize(width: view.frame.size.width, height: view_nomineeDetails.frame.size.height)
        //        }
    }
    // MARK: - <UITableViewDataSource> / <UITableViewDelegate> -
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return nomineeNameArrary.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 700
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return String(section+1) + "            " + nomineeNameArrary[section]!
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
        let cells = Bundle.main.loadNibNamed("MemberNomineeDetailsCell", owner: self, options: nil)?.first as! MemberNomineeDetailsCell
        cells.selectionStyle = UITableViewCellSelectionStyle.none
        cells.lbl_name.text = nomineeNameArrary[indexPath.section]
        cells.lbl_DOB.text = dobArrary[indexPath.section]
        cells.lbl_relation.text = relationArrary[indexPath.section]
        cells.lbl_residential.text = residentialArrary[indexPath.section]
        cells.lbl_city.text = cityArrary[indexPath.section]
        cells.lbl_pin.text = pinArrary[indexPath.section]
        cells.lbl_mobile.text = mobileArrary[indexPath.section]
        cells.lbl_tel.text = telArrary[indexPath.section]
        cells.lbl_email.text = emailArrary[indexPath.section]
        cells.lbl_gender.text = genderArrary[indexPath.section]
        let nomineePhoto = BasicProperties.getMemberPhoto_Url() + photoNameArrary[indexPath.section]!
        cells.lbl_nominee.image = UIImage(named: nomineePhoto)
        let nomineeSign = BasicProperties.getMemberSignature_Url() + signatureNameArrary[indexPath.section]!
        cells.lbl_signature.image = UIImage(named: nomineeSign)
        return cells
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return tableView.dequeueReusableHeaderFooterView(withIdentifier: MemberMyAccountCell.kAccordionHeaderViewReuseIdentifier)
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
                            let activeTcn = json["tcnDetails"]
                            for anItem in activeTcn as! [Dictionary<String, AnyObject>] { // or [[String:AnyObject]]
                                self.lbl_paymentNo_ofUnits.text = anItem["units"] as? String
                                self.lbl_payment_amount.text = anItem["amount"] as? String
                                self.lbl_payment_payMode.text = anItem["paymode"] as? String
                                self.lbl_payment_date.text = anItem["date"] as? String
                                self.lbl_payment_bankName.text = anItem["bank_name"] as? String
                                self.lbl_tcn_currency.text = anItem["currency"] as? String
                                self.lbl_tcn_no_ofUnits.text = anItem["units"] as? String
                                self.lbl_tcn_amount.text = anItem["amount"] as? String
                                self.lbl_tcn_payMode.text = anItem["paymode"] as? String
                                self.lbl_tcn_date.text = anItem["date"] as? String
                                self.lbl_tcn_dd_cheque.text = anItem["cheq_no"] as? String
                                self.lbl_tcn_bank.text = anItem["bank_name"] as? String
                                self.lbl_tcn_branchName.text = anItem["branch_name"] as? String
                            }
                            let nominees = json["nominees"]
                            for anItem in nominees as! [Dictionary<String, AnyObject>] { // or [[String:AnyObject]]
                                self.nomineeNameArrary.append(anItem["nominee_name"] as? String)
                                self.dobArrary.append(anItem["nominee_dob"] as? String)
                                self.relationArrary.append(anItem["nominee_relation"] as? String)
                                self.residentialArrary.append(anItem["nominee_addrs"] as? String)
                                self.cityArrary.append(anItem["nominee_city"] as? String)
                                self.pinArrary.append(anItem["nominee_pin"] as? String)
                                self.mobileArrary.append(anItem["nominee_mobile"] as? String)
                                self.telArrary.append(anItem["nominee_phone"] as? String)
                                self.emailArrary.append(anItem["nominee_email"] as? String)
                                self.genderArrary.append(anItem["nominee_gender"] as? String)
                                self.photoNameArrary.append(anItem["nominee_photo"] as? String)
                                self.signatureNameArrary.append(anItem["nominee_sign"] as? String)
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
}
