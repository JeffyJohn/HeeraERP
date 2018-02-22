//
//  TwoLabelTableViewCell.swift
//  HeeraERP
//
//  Created by Suvan on 1/5/18.
//  Copyright © 2018 Suvan. All rights reserved.
//

import UIKit

class TwoLabelTableViewCell: UITableViewCell {
    @IBOutlet weak var lbl_key: UILabel!
    @IBOutlet weak var lbl_value: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
