//
//  MemberProfileIDproofsCell.swift
//  HeeraERP
//
//  Created by Suvan on 12/29/17.
//  Copyright © 2017 Suvan. All rights reserved.
//

import UIKit

class MemberProfileIDproofsCell: UITableViewCell {
    //linking nib outlets/fields with controller
    @IBOutlet weak var img_idProof: UIImageView!
    @IBOutlet weak var img_signature: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
