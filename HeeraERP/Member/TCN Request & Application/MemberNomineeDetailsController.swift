//
//  MemberNomineeDetailsController.swift
//  HeeraERP
//
//  Created by Suvan on 12/21/17.
//  Copyright © 2017 Suvan. All rights reserved.
//

import UIKit

class  MemberNomineeDetailsController: UIViewController, UITableViewDelegate,UITableViewDataSource,DropDownMenuControllerDelegate,UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
   
    @IBOutlet weak var tbl_nomineeNames: UITableView!
    @IBOutlet weak var view_nomineeDetails: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var btn_saveNomineeDetails: UIButton!
    @IBOutlet weak var txt_nomineeName: UITextField!
    @IBOutlet weak var txt_nomineeDOB: UITextField!
    @IBOutlet weak var tbl_relationWithApplicant: UITableView!
    @IBOutlet weak var txt_residentialAddress: UITextField!
    @IBOutlet weak var txt_city: UITextField!
    @IBOutlet weak var txt_pin: UITextField!
    @IBOutlet weak var txt_mobile: UITextField!
    @IBOutlet weak var txt_telNumber: UITextField!
    @IBOutlet weak var txt_email: UITextField!
    @IBOutlet weak var txt_gender: UITextField!
    @IBOutlet weak var btn_uploadPhoto: UIButton!
    @IBOutlet weak var btn_uploadSignature: UIButton!
    @IBOutlet weak var btn_uploadIdproof: UIButton!
    @IBOutlet weak var tbl_nomineeDetailsView: UITableView!
    @IBOutlet weak var img_photo: UIImageView!
    @IBOutlet weak var img_signature: UIImageView!
    @IBOutlet weak var img_id_proof: UIImageView!
    
    let imagePicker = UIImagePickerController()
    var uploadTagValue = Int()
    var AccessoryDetailValue: String?
    var selectedIndex: Int?
    var tableTagValue: Int?
    var tcnId: String?
    var nomineeNames = [String?]()
    var nomineeIds = [String?]()
    var nominee: AnyObject?
    var nomineeDetails = [String?]()
    
    var tableCells = ["Name Of Nominee"]
    var relationWithApplicantCells = ["Relation With Applicant"]
    var nomineeDetailskey = ["Name", "Date of Birth","Relation With Applicant", "Residential Address", "City", "Pin","Mobile Number", "Resi. Tel: Number","Email","Gender"]
    var nomineeId: String?
    var nomineeRelation: String?
    var nomineeNumber: String?
    var nomineeType: String?
    //**** passing data between controllers
    //**** get data from DropDownMenuControllerDelegate
    func acceptData(data: AnyObject!) {
        print("tableTagValue",tableTagValue ?? " ")
        if(tableTagValue == 600){
            AccessoryDetailValue = data as? String
            tbl_relationWithApplicant.reloadData()
            nomineeRelation = AccessoryDetailValue
        }
        else{
            AccessoryDetailValue = data as? String
            nomineeType = AccessoryDetailValue
            tbl_nomineeNames.reloadData()
            if(data.isEqual("New Nominee")){
                view_nomineeDetails.isHidden = false
                tbl_nomineeDetailsView.isHidden = true
            }
            else{
                for anItem in self.nominee as! [Dictionary<String, AnyObject>] {
                    let name = anItem["nominee_name"] as? String
                    if(data.isEqual(name)){
                        nomineeId = anItem["nominee_id"] as? String
                    }
                }
                print(nomineeId!)
                //**** loading indicator/ preloader
                ActivityIndicator.startAnimating_LoadingIndicator(view: self.view)
                //**** getNomineeDetails
                let postString = "pageKey=nomineeDetails&nomineeId="+nomineeId!
                urlConnection(postString: postString, connection: "getNomineeDetails")
                view_nomineeDetails.isHidden = true
                tbl_nomineeDetailsView.isHidden = false
                tbl_nomineeDetailsView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //**** disable scroll view indicator
            scrollView.showsVerticalScrollIndicator = false
        //**** initialise view_nomineeDetails & tbl_nomineeDetailsView
            view_nomineeDetails.isHidden = true
            tbl_nomineeDetailsView.isHidden = true
        //**** text styling
            BasicProperties.textBorderStyle(textField: txt_nomineeName)
            BasicProperties.textBorderStyle(textField: txt_nomineeDOB)
            BasicProperties.textBorderStyle(textField: txt_residentialAddress)
            BasicProperties.textBorderStyle(textField: txt_city)
            BasicProperties.textBorderStyle(textField: txt_pin)
            BasicProperties.textBorderStyle(textField: txt_mobile)
            BasicProperties.textBorderStyle(textField: txt_telNumber)
            BasicProperties.textBorderStyle(textField: txt_email)
            BasicProperties.textBorderStyle(textField: txt_gender)
        //**** button border styling
            BasicProperties.buttonBorderStyle(button: btn_saveNomineeDetails)
            BasicProperties.buttonBorderStyle(button: btn_uploadPhoto)
            BasicProperties.buttonBorderStyle(button: btn_uploadIdproof)
            BasicProperties.buttonBorderStyle(button: btn_uploadSignature)
        //**** removing unwanted table cells from table view
            tbl_nomineeNames.tableFooterView = UIView(frame: CGRect.zero)
            tbl_nomineeDetailsView.tableFooterView = UIView(frame: CGRect.zero)
        //**** override textfields events
            txt_nomineeName.delegate = self
            txt_nomineeDOB.delegate = self
            txt_residentialAddress.delegate = self
            txt_city.delegate = self
            txt_pin.delegate = self
            txt_mobile.delegate = self
            txt_telNumber.delegate = self
            txt_email.delegate = self
            txt_gender.delegate = self
        //**** imagePicker view
            imagePicker.delegate = self
        //**** get gallery access permision from user
            CheckAccess.checkPermission()
        //**** only portrait orientation
            UIDevice.current.setValue(Int(UIInterfaceOrientation.portrait.rawValue), forKey: "orientation")
        //**** loading indicator/ preloader
        ActivityIndicator.startAnimating_LoadingIndicator(view: self.view)
        //**** getNomineeNames
        let postString = "pageKey=getNomineeNames&memberCode="+GlobalValues.MyVariables.userCode!
        urlConnection(postString: postString, connection: "getNomineeNames")
//        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
//    @objc func keyboardWillShow(notification:NSNotification) {
//        // adjustingHeight(show: true, notification: notification)
//        self.view.frame.origin.y = -150 // Move view 150 points upward
//        scrollView.contentSize = CGSize(width: view.frame.size.width, height: view_nomineeDetails.frame.size.height + 150)
//    }
//    @objc func keyboardWillHide(notification:NSNotification) {
//        //adjustingHeight(show: false, notification: notification)
//        self.view.frame.origin.y = 0 // Move view to original position
//        scrollView.contentSize = CGSize(width: view.frame.size.width, height: view_nomineeDetails.frame.size.height - 150)
//    }
//    override func viewWillDisappear(_ animated: Bool) {
//        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
//        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
//    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //**** only portrait orientation
            UIDevice.current.setValue(Int(UIInterfaceOrientation.portrait.rawValue), forKey: "orientation")
        //**** extending scroll view
            scrollView.contentSize = CGSize(width: view.frame.size.width, height: view_nomineeDetails.frame.size.height)
//        if view_nomineeDetails.frame.size.height > view.frame.size.height {
//            scrollView.contentSize = CGSize(width: view.frame.size.width, height: view_nomineeDetails.frame.size.height)
//        }
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
        if(tableView == tbl_nomineeDetailsView){
            return 3
        }
        else{
          return 1
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if(tableView == tbl_nomineeNames){
            return tableCells.count
        }
        else if(tableView == tbl_relationWithApplicant){
            return relationWithApplicantCells.count
        }
        else if(tableView == tbl_nomineeDetailsView){
            if(section == 0){
                return nomineeDetailskey.count
            }
            else{
                return 1
            }
        }
        else{
            return 1
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //**** Configure the cell
        if(tableView == tbl_nomineeNames)
        {
            let CellIdentifier =  "cells"
            let cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier, for: indexPath)
            tableView.separatorStyle = .none
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
        else if(tableView == tbl_relationWithApplicant){
            let CellIdentifier =  "cells"
            let cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier, for: indexPath)
            //tableView.separatorStyle = .none
            cell.textLabel?.text = relationWithApplicantCells[indexPath.row]
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
        else if(tableView == tbl_nomineeDetailsView){
            if(indexPath.section == 0){
                let cells = Bundle.main.loadNibNamed("TwoLabelTableViewCell", owner: self, options: nil)?.first as! TwoLabelTableViewCell
                cells.lbl_key.text = nomineeDetailskey[indexPath.row]
                if(nomineeDetails.isEmpty == false){
                    cells.lbl_value.text = nomineeDetails[indexPath.row]
                }
                tableView.separatorStyle = .none
                cells.selectionStyle = UITableViewCellSelectionStyle.none
                cells.isUserInteractionEnabled = false
                return cells
            }
            else if(indexPath.section == 1){
                let cells = Bundle.main.loadNibNamed("TwoImagesViewCell", owner: self, options: nil)?.first as! TwoImagesViewCell
                cells.label1.text = "Photo"
                cells.label2.text = "Signature"
//                if(nomineeDetails.isEmpty == false){
//                    cells.lbl_value.text = nomineeDetails[indexPath.row]
//                }
                tableView.separatorStyle = .none
                cells.selectionStyle = UITableViewCellSelectionStyle.none
                cells.isUserInteractionEnabled = false
                return cells
            }
            else{
                let cells = Bundle.main.loadNibNamed("ImageLabelTableViewCell", owner: self, options: nil)?.first as! ImageLabelTableViewCell
                cells.lbl_image.text = "ID Proof"
                //                if(nomineeDetails.isEmpty == false){
                //                    cells.lbl_value.text = nomineeDetails[indexPath.row]
                //                }
                tableView.separatorStyle = .none
                cells.selectionStyle = UITableViewCellSelectionStyle.none
                cells.isUserInteractionEnabled = false
                return cells
            }
            //nominee images will display in section
        }
        else{
            let CellIdentifier =  "cells"
            let cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier, for: indexPath)
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        let initController = self.storyboard?.instantiateViewController(withIdentifier: "DropDownMenuController") as! DropDownMenuController
        if(tableView == tbl_nomineeNames){
            initController.title = tableCells[indexPath.row]
            initController.cellArray = nomineeNames as! [String]
            selectedIndex = indexPath.row
            tableTagValue = tbl_nomineeNames.tag
        }
        else if(tableView == tbl_relationWithApplicant){
            initController.title = relationWithApplicantCells[indexPath.row]
            initController.cellArray = ["Father","Mother","Husband","Wife","Sister","Brother","Son","Daughter","others"]
            selectedIndex = indexPath.row
            tableTagValue = tbl_relationWithApplicant.tag
        }
        initController.delegate = self
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        self.navigationController?.pushViewController(initController, animated: true )
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(tableView == tbl_nomineeDetailsView)
        {
            if(indexPath.section == 0){
                return 50
            }
            else if(indexPath.section == 1){
                return 200
            }
            else{
                return 150
            }
        }
        else{
            return 50
        }
//        return 50
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var newImage: UIImage
        if let possibleImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            newImage = possibleImage

        } else if let possibleImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            newImage = possibleImage
        } else {
            return
        }
        //**** getting image path
            let imageUrl = info["UIImagePickerControllerImageURL"] as? URL
            let imagePath: String = imageUrl!.path
        //**** getting extension
            let imagePathArray = imagePath.components(separatedBy: ".")
        print("extension ",imagePathArray[1])
        if(imagePathArray[1] == "jpeg" || imagePathArray[1] == "jpg" || imagePathArray[1] == "png"){
            let imgData: NSData = NSData(data: UIImageJPEGRepresentation((newImage), 1)!)
            let imageSize: Int = imgData.length
            print("size of image in KB: %f ", imageSize / 1024)
            //**** find file extension if it is jpg or png upload images or retry
            //**** image preview
            if(uploadTagValue == 100){
                img_photo.image = newImage
            }
            else if(uploadTagValue == 200){
                img_signature.image = newImage
            }
            else {
                img_id_proof.image = newImage
            }
        }
        else{
            let alertController = UIAlertController(title: "Invaild Image Format", message:
                "Extension is not allowed. Please choose jpeg/jpg/png formats!.", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: { action in
            }))
            self.present(alertController, animated: true, completion: nil)
        }
        dismiss(animated: true)
        //**** Save image to Document directory
//        var imagePath = NSDate().description
//        imagePath = imagePath.stringByReplacingOccurrencesOfString(" ", withString: "")
//        imagePath = imagesDirectoryPath.stringByAppendingString("/\(imagePath).png")
//        let data = UIImagePNGRepresentation(image)
//        let success = NSFileManager.defaultManager().createFileAtPath(imagePath, contents: data, attributes: nil)
//        dismissViewControllerAnimated(true) { () -> Void in
//            self.refreshTable()
//        }
    }
    @IBAction func actn_upload_photo(_ sender: Any) {
        //**** Check sourceType is available or not
            uploadTagValue = (sender as AnyObject).tag;
            if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary))
            {
               //**** imagePicker.allowsEditing = true
                imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
                self .present(imagePicker, animated: true, completion: nil)
            }
//        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
//        if UIDevice.current.userInterfaceIdiom == .phone
//        {
//            self.present(imagePicker, animated: true, completion: nil)
//        }
    }
    @IBAction func actn_upload_idProof(_ sender: Any) {
        //**** Check sourceType is available or not
            uploadTagValue = (sender as AnyObject).tag;
            if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary))
            {
                //**** imagePicker.allowsEditing = true
                imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
                self .present(imagePicker, animated: true, completion: nil)
            }
    }
    @IBAction func actn_upload_signature(_ sender: Any) {
        //**** Check sourceType is available or not
            uploadTagValue = (sender as AnyObject).tag;
            if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary))
            {
                //**** imagePicker.allowsEditing = true
                imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
                self .present(imagePicker, animated: true, completion: nil)
            }
    }
    @IBAction func actn_saveNomineeDetails(_ sender: Any) {
        print("nomineeNumber",nomineeNumber ?? "")
        print("nomineeType",nomineeType ?? "")
        if(nomineeType == "New Nominee"){
            if(txt_nomineeName.text?.isEmpty == true && txt_residentialAddress.text?.isEmpty == true && txt_gender.text?.isEmpty == true && nomineeRelation?.isEmpty == true){
                let alertController = UIAlertController(title: "Invalid input", message:
                    "Please fill all fields!", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: { action in
                }))
                self.present(alertController, animated: true, completion: nil)
            }
            else{
                //**** loading indicator/ preloader
                ActivityIndicator.startAnimating_LoadingIndicator(view: self.view)
                //add new nominee
                let string = "&dob="+txt_nomineeDOB.text!+"&address="+txt_residentialAddress.text!+"&city="+txt_city.text!+"&pin="+txt_pin.text!+"&mobile="+txt_mobile.text!+"&telephone="+txt_telNumber.text!+"&email="+txt_email.text!+"&gender="+txt_gender.text!+"&relation="+nomineeRelation!+"&tcnId="+tcnId!+"&nomineeNumber="+nomineeNumber!
                let postString = "pageKey=addNominee&memberCode="+GlobalValues.MyVariables.userCode!+"&name="+txt_nomineeName.text!+string
                print("add new nominee"+postString)
                urlConnection(postString: postString, connection: "addNewNominee")
            }
        }
        else if(nomineeType?.isEmpty == true){
            let alertController = UIAlertController(title: "Invalid input", message:
                "Please select nominee name or add new nominee!", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: { action in
            }))
            self.present(alertController, animated: true, completion: nil)
        }
        else{
            //**** loading indicator/ preloader
            ActivityIndicator.startAnimating_LoadingIndicator(view: self.view)
            //existing nominee details
            let string = "&nomineeId="+nomineeId!+"&tcnId="+tcnId!+"&nomineeNumber="+nomineeNumber!
            let postString = "pageKey=nomineeSubmit&memberId="+GlobalValues.MyVariables.empId!+string
            print("existing nominee details"+postString)
            urlConnection(postString: postString, connection: "existingNominee")
        }
    }
    //****    keyboard activities
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txt_nomineeName {
            txt_nomineeName.resignFirstResponder()
            txt_nomineeDOB.becomeFirstResponder()
            return true
        }
        else if textField == txt_nomineeDOB {
            txt_nomineeDOB.resignFirstResponder()
            txt_residentialAddress.becomeFirstResponder()
            return true
        }
        else if textField == txt_residentialAddress {
            txt_residentialAddress.resignFirstResponder()
            txt_city.becomeFirstResponder()
            return true
        }
        else if textField == txt_city {
            txt_city.resignFirstResponder()
            txt_pin.becomeFirstResponder()
            return true
        }
        else if textField == txt_pin {
            txt_pin.resignFirstResponder()
            txt_mobile.becomeFirstResponder()
            return true
        }
        else if textField == txt_mobile {
            txt_mobile.resignFirstResponder()
            txt_telNumber.becomeFirstResponder()
            return true
        }
        else if textField == txt_telNumber {
            txt_telNumber.resignFirstResponder()
            txt_email.becomeFirstResponder()
            return true
        }
        else if textField == txt_email {
            txt_email.resignFirstResponder()
            txt_gender.becomeFirstResponder()
            return true
        }
        else if textField == txt_gender {
            txt_gender.resignFirstResponder()
            self.view.endEditing(true)
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
    func urlConnection(postString: String, connection: String){
        self.nomineeDetails = []
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
                            if(connection == "getNomineeNames"){
                                self.nominee = json["nominees"]
                                for anItem in self.nominee as! [Dictionary<String, AnyObject>] {
                                    let name = anItem["nominee_name"] as? String
                                    if(name?.isEmpty == false){
                                        self.nomineeNames.append(name)
                                        self.nomineeIds.append(anItem["nominee_id"] as? String)
                                    }
                                }
                                self.nomineeIds.append("New Nominee")
                                self.nomineeNames.append("New Nominee")
                            }
                            else if(connection == "getNomineeDetails"){
                                let nomineeDetails = json["nomineeDetails"]
                                for anItem in nomineeDetails as! [Dictionary<String, AnyObject>] {
                                    self.nomineeDetails.append(anItem["nominee_name"] as? String)
                                    self.nomineeDetails.append(anItem["nominee_dob"] as? String)
                                    self.nomineeDetails.append(anItem["nominee_relation"] as? String)
                                    self.nomineeDetails.append(anItem["nominee_addrs"] as? String)
                                    self.nomineeDetails.append(anItem["nominee_city"] as? String)
                                    self.nomineeDetails.append(anItem["nominee_pin"] as? String)
                                    self.nomineeDetails.append(anItem["nominee_mobile"] as? String)
                                    self.nomineeDetails.append(anItem["nominee_phone"] as? String)
                                    self.nomineeDetails.append(anItem["nominee_email"] as? String)
                                    self.nomineeDetails.append(anItem["nominee_gender"] as? String)
                                }
                                self.tbl_nomineeDetailsView.reloadData()
                            }
                            else if(connection == "existingNominee" || connection == "addNewNominee"){
                                self.AccessoryDetailValue = "Detail"
                                self.txt_nomineeName.text = ""
                                self.txt_nomineeDOB.text = ""
                                self.txt_residentialAddress.text = ""
                                self.txt_city.text = ""
                                self.txt_pin.text = ""
                                self.txt_mobile.text = ""
                                self.txt_telNumber.text = ""
                                self.txt_email.text = ""
                                self.txt_gender.text = ""
                                self.tbl_relationWithApplicant.reloadData()
                                self.tbl_nomineeNames.reloadData()
                                self.tbl_nomineeDetailsView.reloadData()
                                //**** initialise view_nomineeDetails & tbl_nomineeDetailsView
                                self.view_nomineeDetails.isHidden = true
                                self.tbl_nomineeDetailsView.isHidden = true
                                print("nomineeNumber inside connection",self.nomineeNumber ?? "")
                                if(self.nomineeNumber == "2"){
                                    //**** Instantiate SecondViewController
                                    let supportingDocumentController = self.storyboard?.instantiateViewController(withIdentifier: "MemberSupportingDocumentController") as! MemberSupportingDocumentController
                                    //**** Take ctrl to next view
                                    supportingDocumentController.tcnId = json["tcnId"] as? String
                                    supportingDocumentController.title = "TCN Application Form"
                                    self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
                                    self.navigationController?.pushViewController(supportingDocumentController, animated: true)
                                }
                                else{
                                    //**** actionsheet with alertController for dismiss login action
                                    let alert = UIAlertController(title: "", message: "Do you want to add one more nominee?", preferredStyle: UIAlertControllerStyle.actionSheet)
                                    let libButton = UIAlertAction(title: "Yes", style: UIAlertActionStyle.default) { (alert) -> Void in
                                        let tcnId = json["tcnId"] as? String
                                        //**** Instantiate SecondViewController
                                        let nomineeDetailsController = self.storyboard?.instantiateViewController(withIdentifier: "NomineeDetailsController") as! MemberNomineeDetailsController
                                        //**** Take ctrl to next view
                                        nomineeDetailsController.tcnId = tcnId!
                                        nomineeDetailsController.nomineeNumber = "2"
                                        nomineeDetailsController.title = "TCN Application Form"
                                        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
                                        self.navigationController?.pushViewController(nomineeDetailsController, animated: true)
                                    }
                                    let cancelButton = UIAlertAction(title: "No", style: UIAlertActionStyle.cancel) { (alert) -> Void in
                                        //**** Instantiate SecondViewController
                                        let supportingDocumentController = self.storyboard?.instantiateViewController(withIdentifier: "MemberSupportingDocumentController") as! MemberSupportingDocumentController
                                        //**** Take ctrl to next view
                                        supportingDocumentController.tcnId = json["tcnId"] as? String
                                        supportingDocumentController.title = "TCN Application Form"
                                        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
                                        self.navigationController?.pushViewController(supportingDocumentController, animated: true)
                                    }
                                    alert.addAction(libButton)
                                    alert.addAction(cancelButton)
                                    self.present(alert, animated: true, completion: nil)
                                }
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
