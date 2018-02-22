//
//  TwoImagesViewCell.swift
//  HeeraERP
//
//  Created by Suvan on 2/1/18.
//  Copyright © 2018 Suvan. All rights reserved.
//

import UIKit

class TwoImagesViewCell: UITableViewCell {
    @IBOutlet weak var image1: UIImageView!
    @IBOutlet weak var image2: UIImageView!
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
