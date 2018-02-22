//
//  MemberNomineeDetailsCell.swift
//  HeeraERP
//
//  Created by Suvan on 1/29/18.
//  Copyright © 2018 Suvan. All rights reserved.
//

import UIKit

class MemberNomineeDetailsCell: UITableViewCell {
    @IBOutlet weak var lbl_name: UILabel!
    @IBOutlet weak var lbl_DOB: UILabel!
    @IBOutlet weak var lbl_relation: UILabel!
    @IBOutlet weak var lbl_residential: UILabel!
    @IBOutlet weak var lbl_city: UILabel!
    @IBOutlet weak var lbl_pin: UILabel!
    @IBOutlet weak var lbl_mobile: UILabel!
    @IBOutlet weak var lbl_tel: UILabel!
    @IBOutlet weak var lbl_email: UILabel!
    @IBOutlet weak var lbl_gender: UILabel!
    @IBOutlet weak var lbl_nominee: UIImageView!
    @IBOutlet weak var lbl_signature: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
