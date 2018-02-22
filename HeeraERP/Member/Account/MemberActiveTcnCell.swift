//
//  MemberActiveTcnCell.swift
//  HeeraERP
//
//  Created by Suvan on 1/3/18.
//  Copyright © 2018 Suvan. All rights reserved.
//

import UIKit

class MemberActiveTcnCell: UITableViewCell {

    @IBOutlet weak var txt_tcn: UILabel!
    @IBOutlet weak var txt_units: UILabel!
    @IBOutlet weak var txt_currency: UILabel!
    @IBOutlet weak var txt_amount: UILabel!
    @IBOutlet weak var txt_approvedDate: UILabel!
    @IBOutlet weak var btn_withdraw: UIButton!
    
    @IBOutlet weak var lbl_firstLabel: UILabel!
    @IBOutlet weak var lbl_secondLabel: UILabel!
    @IBOutlet weak var lbl_thirdLabel: UILabel!
    @IBOutlet weak var lbl_fourthLabel: UILabel!
    @IBOutlet weak var lbl_fifthLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        BasicProperties.buttonBorderStyle(button: btn_withdraw)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
