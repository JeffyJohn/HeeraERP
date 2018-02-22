//
//  MemberNomineeDetailCell.swift
//  HeeraERP
//
//  Created by Suvan on 12/21/17.
//  Copyright © 2017 Suvan. All rights reserved.
//

import UIKit

class MemberNomineeDetailCell: UITableViewCell {

    @IBOutlet weak var txt_cell_name: UITextField!
    @IBOutlet weak var txt_cell_dob: UITextField!
    @IBOutlet weak var txt_cell_relationwithApplicant: UITextField!
    @IBOutlet weak var txt_cell_city: UITextField!
    @IBOutlet weak var txt_cell_residentialAddress: UITextField!
    @IBOutlet weak var txt_cell_pin: UITextField!
    @IBOutlet weak var txt_cell_mobileNumber: UITextField!
    @IBOutlet weak var txt_cell_tele_number: UITextField!
    @IBOutlet weak var txt_cell_email: UITextField!
    @IBOutlet weak var txt_cell_gender: UITextField!
    @IBOutlet weak var img_photo: UIImageView!
    @IBOutlet weak var img_signature: UIImageView!
    @IBOutlet weak var img_idProof: UIImageView!
    @IBOutlet weak var lbl_idProof: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // text style
        txt_cell_name.isUserInteractionEnabled = false
        txt_cell_dob.isUserInteractionEnabled = false
        txt_cell_relationwithApplicant.isUserInteractionEnabled = false
        txt_cell_city.isUserInteractionEnabled = false
        txt_cell_residentialAddress.isUserInteractionEnabled = false
        txt_cell_pin.isUserInteractionEnabled = false
        txt_cell_mobileNumber.isUserInteractionEnabled = false
        txt_cell_tele_number.isUserInteractionEnabled = false
        txt_cell_email.isUserInteractionEnabled = false
        txt_cell_gender.isUserInteractionEnabled = false
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
