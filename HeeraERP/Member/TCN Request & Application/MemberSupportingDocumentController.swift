//
//  MemberSupportingDocumentController.swift
//  HeeraERP
//
//  Created by Suvan on 12/21/17.
//  Copyright © 2017 Suvan. All rights reserved.
//

import UIKit

class MemberSupportingDocumentController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    //connecting variables to controller
    @IBOutlet weak var btn_submitTcnForm: UIButton!
    @IBOutlet weak var btn_uploadPassport: UIButton!
    @IBOutlet weak var btn_uploadTransferCertificate: UIButton!
    @IBOutlet weak var btn_uploadTransactionProof: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var view_suppoertDocs: UIView!
    @IBOutlet weak var img_passport: UIImageView!
    @IBOutlet weak var img_transferProof: UIImageView!
    @IBOutlet weak var img_transactionProof: UIImageView!
    @IBOutlet weak var view_passbook: UIView!
    @IBOutlet weak var view_transferStatement: UIView!
    @IBOutlet weak var view_transactionProof: UIView!
    
    let imagePicker = UIImagePickerController()
    var uploadTagValue = Int()
    var tcnId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //**** disabling scroll indicator
            scrollView.showsVerticalScrollIndicator = false
        //**** button border style
            BasicProperties.buttonBorderStyle(button: btn_submitTcnForm)
            BasicProperties.buttonBorderStyle(button: btn_uploadPassport)
            BasicProperties.buttonBorderStyle(button: btn_uploadTransactionProof)
            BasicProperties.buttonBorderStyle(button: btn_uploadTransferCertificate)
        //**** imagePicker view
            imagePicker.delegate = self
        //**** get gallery access permision from user
            CheckAccess.checkPermission()
        //**** only portrait orientation
            UIDevice.current.setValue(Int(UIInterfaceOrientation.portrait.rawValue), forKey: "orientation")
       //**** shadow view for uiview: header_view
            shadowViewBlock(view: view_passbook)
            shadowViewBlock(view: view_transactionProof)
            shadowViewBlock(view: view_transferStatement)
    }
    func shadowViewBlock(view: UIView){
        view.layer.masksToBounds = false
        view.layer.shadowOffset = CGSize(width: 0.0 , height: 5.0)
        view.layer.shadowOpacity = 1.0
        view.layer.shadowRadius = 1.0
        view.layer.shadowColor = UIColor(red:0.59, green:0.56, blue:0.56, alpha:1.0).cgColor
    }
    //**** adjusting scroll view with respect to device size
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //**** scroll view
            scrollView.contentSize = CGSize(width: view.frame.size.width, height: view_suppoertDocs.frame.size.height)
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
    @IBAction func actn_transactionProof(_ sender: Any) {
        //**** Check sourceType is available or not
            uploadTagValue = (sender as AnyObject).tag;
            if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary))
            {
                // imagePicker.allowsEditing = true
                imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
                self .present(imagePicker, animated: true, completion: nil)
            }
    }
    @IBAction func actn_transferStatementProof(_ sender: Any) {
        //**** Check sourceType is available or not
        uploadTagValue = (sender as AnyObject).tag;
            if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary))
            {
                //**** imagePicker.allowsEditing = true
                imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
                self .present(imagePicker, animated: true, completion: nil)
            }
    }
    @IBAction func actn_uploadPassport_bankStatement(_ sender: Any) {
        //**** Check sourceType is available or not
            uploadTagValue = (sender as AnyObject).tag;
            if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary))
            {
                //**** imagePicker.allowsEditing = true
                imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
                self .present(imagePicker, animated: true, completion: nil)
            }
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
            if(uploadTagValue == 10){
                img_passport.image = newImage
            }
            else if(uploadTagValue == 20){
                img_transferProof.image = newImage
            }
            else {
                img_transactionProof.image = newImage
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
    }
}
