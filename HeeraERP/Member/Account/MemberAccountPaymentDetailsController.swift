//
//  MemberAccountPaymentDetailsController.swift
//  HeeraERP
//
//  Created by Suvan on 1/4/18.
//  Copyright © 2018 Suvan. All rights reserved.
//

import UIKit

class MemberAccountPaymentDetailsController: UIViewController, UITableViewDelegate, UITableViewDataSource,DropDownMenuControllerDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    @IBOutlet weak var tbl_paymode: UITableView!
    @IBOutlet weak var txt_depositeDate: UITextField!
    @IBOutlet weak var txt_ddCheque: UITextField!
    @IBOutlet weak var txt_bankName: UITextField!
    @IBOutlet weak var txt_branchName: UITextField!
    @IBOutlet weak var tbl_applyingFrom: UITableView!
    @IBOutlet weak var txt_heeraAccountNumber: UITextField!
    @IBOutlet weak var img_uploadDocuments: UIImageView!
    @IBOutlet weak var btn_uploadPaymentDetails: UIButton!
    @IBOutlet weak var btn_submit: UIButton!
    @IBOutlet weak var lbl_uploadPaymentDocumentHeader: UILabel!
    @IBOutlet weak var main_view: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var paymode = ["Pay Mode"]
    var applyingFrom = ["Applying From"]
    var AccessoryDetailValue: String?
    var tagValue: Int?
    let imagePicker = UIImagePickerController()
    
    func acceptData(data: AnyObject!) {
        AccessoryDetailValue = data as? String
        if(tagValue == 100){
            tbl_paymode.reloadData()
        }
        else{
            tbl_applyingFrom.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //**** lbl_uploadPaymentDocumentHeader text border line
            let border = CALayer()
            let width = CGFloat(1.0)
            border.borderColor = UIColor(red:0.17, green:0.14, blue:0.14, alpha:1.0).cgColor
            border.frame = CGRect(x: 0, y: lbl_uploadPaymentDocumentHeader.frame.size.height - width, width:  lbl_uploadPaymentDocumentHeader.frame.size.width, height: lbl_uploadPaymentDocumentHeader.frame.size.height)
            border.borderWidth = width
            lbl_uploadPaymentDocumentHeader.layer.addSublayer(border)
            lbl_uploadPaymentDocumentHeader.layer.masksToBounds = true
        //**** for bold label: lbl_uploadPaymentDocumentHeader
            lbl_uploadPaymentDocumentHeader.font = UIFont(name:"HelveticaNeue-Bold", size: 17.0)
        //**** text and buton style
            BasicProperties.textBorderStyle(textField: txt_depositeDate)
            BasicProperties.textBorderStyle(textField: txt_ddCheque)
            BasicProperties.textBorderStyle(textField: txt_bankName)
            BasicProperties.textBorderStyle(textField: txt_branchName)
            BasicProperties.textBorderStyle(textField: txt_heeraAccountNumber)
            BasicProperties.buttonBorderStyle(button: btn_submit)
            BasicProperties.buttonBorderStyle(button: btn_uploadPaymentDetails)
        //**** text field delegate
            txt_depositeDate.delegate = self
            txt_ddCheque.delegate = self
            txt_bankName.delegate = self
            txt_branchName.delegate = self
            txt_heeraAccountNumber.delegate = self
        //**** disable scroll view indicator
            scrollView.showsVerticalScrollIndicator = false
        //**** imagePicker view
            imagePicker.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //**** extending scroll view
            scrollView.contentSize = CGSize(width: view.frame.size.width, height: main_view.frame.size.height)
    }
    @IBAction func actn_uploadDocuments(_ sender: Any) {
        //**** Check sourceType is available or not
         if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary))
        {
            //**** imagePicker.allowsEditing = true
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            self .present(imagePicker, animated: true, completion: nil)
        }
    }
    @IBAction func actn_submit(_ sender: Any) {
    }
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if(tableView == tbl_paymode){
            return paymode.count
        }
        else{
            return applyingFrom.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //**** Configure the cell
        let CellIdentifier =  "cells"
        let cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier, for: indexPath)
        tableView.separatorStyle = .none
        if(tableView == tbl_paymode){
            cell.textLabel?.text = paymode[indexPath.row]
            if((AccessoryDetailValue) != nil){
                if(tagValue == 100){
                    cell.detailTextLabel?.text = AccessoryDetailValue
                }
            }
            else{
                cell.detailTextLabel?.text = " "
            }
            return cell
        }
        else{
            cell.textLabel?.text = applyingFrom[indexPath.row]
            if((AccessoryDetailValue) != nil){
                if(tagValue == 200){
                    cell.detailTextLabel?.text = AccessoryDetailValue
                }
            }
            else{
                cell.detailTextLabel?.text = " "
            }
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        let initController = self.storyboard?.instantiateViewController(withIdentifier: "DropDownMenuController") as! DropDownMenuController
        if(tableView == tbl_paymode){
            initController.title = "Pay Mode"
            initController.cellArray = ["Cheque","DD","Online Trandfer","Others"]
            tagValue = tbl_paymode.tag
        }
        else{
            initController.title = "Applying From"
            initController.cellArray = ["Afghanistan","India"]
            tagValue = tbl_applyingFrom.tag
        }
        initController.delegate = self
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        self.navigationController?.pushViewController(initController, animated: true )
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var newImage: UIImage
        print("inside func")
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
        print("extensionssss ",imagePathArray[1])
        if(imagePathArray[1] == "jpeg" || imagePathArray[1] == "jpg" || imagePathArray[1] == "png"){
            print("extension ",imagePathArray[1])
           // let imgData: NSData = NSData(data: UIImageJPEGRepresentation((newImage), 1)!)
           // let imageSize: Int = imgData.length
            //**** find file extension if it is jpg or png upload images or retry
            //**** image preview
            img_uploadDocuments.image = newImage
        }
        else{
            let alertController = UIAlertController(title: "Invaild Image Format", message:
                "Extension is not allowed. Please choose jpeg/jpg/png formats!.", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: { action in
            }))
            self.present(alertController, animated: true, completion: nil)
        }
        dismiss(animated: true)
    }
    //****    keyboard activities
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txt_depositeDate {
            txt_depositeDate.resignFirstResponder()
            txt_ddCheque.becomeFirstResponder()
            return true
        }
        else if textField == txt_ddCheque {
            txt_ddCheque.resignFirstResponder()
            txt_bankName.becomeFirstResponder()
            return true
        }
        else if textField == txt_bankName {
            txt_bankName.resignFirstResponder()
            txt_branchName.becomeFirstResponder()
            return true
        }
        else if textField == txt_branchName {
            txt_branchName.resignFirstResponder()
            txt_heeraAccountNumber.becomeFirstResponder()
            return true
        }
        else if textField == txt_heeraAccountNumber {
            txt_heeraAccountNumber.resignFirstResponder()
            view.endEditing(true)
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
}
