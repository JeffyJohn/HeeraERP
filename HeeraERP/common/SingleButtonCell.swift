//
//  SingleButtonCell.swift
//  HeeraERP
//
//  Created by Suvan on 1/5/18.
//  Copyright © 2018 Suvan. All rights reserved.
//

import UIKit

class SingleButtonCell: UITableViewCell {

    @IBOutlet weak var btn_singleButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        BasicProperties.buttonBorderStyle(button: btn_singleButton)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
