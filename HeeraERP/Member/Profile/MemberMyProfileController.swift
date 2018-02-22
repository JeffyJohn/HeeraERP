//
//  MemberMyProfileController.swift
//  HeeraERP
//
//  Created by Suvan on 12/15/17.
//  Copyright © 2017 Suvan. All rights reserved.
//

import UIKit

class MemberMyProfileController : UIViewController, UITableViewDataSource, UITableViewDelegate{
    //linking nib outlets/fields with controller
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var lbl_today_date: UILabel!
    @IBOutlet weak var tbl_profileDetails: UITableView!
    @IBOutlet weak var tableView: UITableView!
    //globaly declared variables
    var tableCells = ["Main Info","Personal Details", "Official Details", "Passport Details", "ID Proof and Signature"]
    var name: String?
    var personalDetailsKey = ["Date of Birth", "Father's /Husband's Name", "Applied Date", "Marital Status", "No. of Children", "Gender", "Region", "Caste", "Nationality", "Education", "Occupation", "Permanent Address", "City", "Pin", "Telephone", "Mobile", "Email"]
    var OfficialDetailsKey = ["Office Address", "Pin", "Office Phone", "Total Family Income"]
    var passportDetailsKey = ["Passport Number", "Passport Issued At", "Passport Issued Date", "Passport Expires On"]
    var personalDetails = [String?]()
    var officialDetails = [String?] ()
    var passportDetails = [String?]()
    var userPhoto: String?
    var signature: String?
    var id_proof: String?
    
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
        //**** remove blank spaces after table view
        tbl_profileDetails.tableFooterView = UIView(frame: CGRect.zero)
        let memberCode = GlobalValues.MyVariables.empId ?? " "
        //****  starting loading indicator/ preloader
        ActivityIndicator.startAnimating_LoadingIndicator(view: self.view)
        //getting profile details
        let url = URL(string: BasicProperties.getMember_Url())!
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let postString = "pageKey=memberProfile&memberId="+memberCode
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
                    // handle json result...
                    let status = json["status"]
                    DispatchQueue.main.async {
                        //**** stopping loading indicator/ preloader
                        ActivityIndicator.stopAnimating_LoadingIndicator()
                    }
                        if(status?.isEqual(1))!{
                            //**** formation of passport details array
                            self.passportDetails.append(json["passportNo"] as? String)
                            self.passportDetails.append(json["passportIssuedAt"] as? String)
                            self.passportDetails.append(json["passportIssueDate"] as? String)
                            self.passportDetails.append(json["passportExpiry"] as? String)
                            //**** formation of official details array
                            self.officialDetails.append(json["officeAddress"] as? String)
                            self.officialDetails.append(json["officePin"] as? String)
                            self.officialDetails.append(json["officePhone"] as? String)
                            self.officialDetails.append(json["familyIncome"] as? String)
                            //**** formation of personal details array
                            self.personalDetails.append(json["dateOfBirth"] as? String)
                            self.personalDetails.append(json["guardiansName"] as? String)
                            self.personalDetails.append(json["appliedDate"] as? String)
                            self.personalDetails.append(json["maritalStatus"] as? String)
                            self.personalDetails.append(json["noOfChildren"] as? String)
                            self.personalDetails.append(json["gender"] as? String)
                            self.personalDetails.append(json["religion"] as? String)
                            self.personalDetails.append(json["caste"] as? String)
                            self.personalDetails.append(json["nationality"] as? String)
                            self.personalDetails.append(json["education"] as? String)
                            self.personalDetails.append(json["occupation"] as? String)
                            self.personalDetails.append(json["permanentAddress"] as? String)
                            self.personalDetails.append(json["city"] as? String)
                            self.personalDetails.append(json["pin"] as? String)
                            self.personalDetails.append(json["tel"] as? String)
                            self.personalDetails.append(json["mobile"] as? String)
                            self.personalDetails.append(json["email"] as? String)
                            //get user photo, sign and ID proof
                            let photo_name = json["image"]?.components(separatedBy: "member_photos/")
                            self.userPhoto = BasicProperties.getMemberPhoto_Url() + photo_name![1]
                            let sign = json["sign"]?.components(separatedBy: "member_signatures/")
                            self.signature = BasicProperties.getMemberSignature_Url() + sign![1]
                            let id = json["idProof"]?.components(separatedBy: "member_id_proof/")
                            self.id_proof = BasicProperties.getMember_idproof_Url() + id![1]
                        }
                        else{
                            //connection lost or somthething went wrong!!!! login again
                        }
                }
            } catch let error {
                print(error.localizedDescription)
            }
        }
        task.resume() 
    }
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return tableCells.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch section {
        case 0:
            return 1
        case 1:
            return personalDetailsKey.count
        case 2:
            return OfficialDetailsKey.count
        case 3:
            return passportDetailsKey.count
        case 4:
            return 1
        default:
            break
        }
        return 1
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return tableCells[section]
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44.0
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.section == 0){
            return 100
        }
        else if(indexPath.section == 4){
            return 200
        }
        else{
            return 44
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.separatorStyle = .none
        let cell = Bundle.main.loadNibNamed("TwoLabelTableViewCell", owner: self, options: nil)?.first as! TwoLabelTableViewCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        switch indexPath.section {
        case 1:
            cell.lbl_key.text = personalDetailsKey[indexPath.row]
            if(personalDetails.isEmpty == false){
               cell.lbl_value.text = personalDetails[indexPath.row]
            }
            return cell
        case 2:
            cell.lbl_key.text = OfficialDetailsKey[indexPath.row]
            if(officialDetails.isEmpty == false){
                cell.lbl_value.text = officialDetails[indexPath.row]
            }
            return cell
        case 3:
            cell.lbl_key.text = passportDetailsKey[indexPath.row]
            if(passportDetails.isEmpty == false){
                cell.lbl_value.text = passportDetails[indexPath.row]
            }
            return cell
        default:
            break
        }
        if(indexPath.section == 0){
            let cell = Bundle.main.loadNibNamed("MemberProfileMainInfoCell", owner: self, options: nil)?.first as! MemberProfileMainInfoCell
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            cell.lbl_memberName.text = GlobalValues.MyVariables.userName
            cell.lbl_memberCode.text = GlobalValues.MyVariables.userCode
            if(userPhoto == nil){
                cell.img_memberPhoto.image = UIImage(named: "IBG0000010")
            }
            else{
                cell.img_memberPhoto.image = UIImage(named: userPhoto!)
            }
            cell.img_memberPhoto.layer.cornerRadius = cell.img_memberPhoto.frame.size.height / 2
            return cell
        }
        else{
            let cell = Bundle.main.loadNibNamed("MemberProfileIDproofsCell", owner: self, options: nil)?.first as! MemberProfileIDproofsCell
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            cell.img_idProof.image = UIImage(named: signature!)
            cell.img_signature.image = UIImage(named: id_proof!)
            return cell
        }
    }
}
