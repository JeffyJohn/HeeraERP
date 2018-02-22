//
//  MemberProfileMainInfoCell.swift
//  HeeraERP
//
//  Created by Suvan on 12/29/17.
//  Copyright © 2017 Suvan. All rights reserved.
//

import UIKit

class MemberProfileMainInfoCell: UITableViewCell {
    //linking nib outlets/fields with controller
    @IBOutlet weak var img_memberPhoto: UIImageView!
    @IBOutlet weak var lbl_memberName: UILabel!
    @IBOutlet weak var lbl_memberCode: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
