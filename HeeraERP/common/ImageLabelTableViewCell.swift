//
//  ImageLabelTableViewCell.swift
//  HeeraERP
//
//  Created by Suvan on 1/5/18.
//  Copyright © 2018 Suvan. All rights reserved.
//

import UIKit

class ImageLabelTableViewCell: UITableViewCell {

    @IBOutlet weak var lbl_image: UILabel!
    @IBOutlet weak var img_view: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
