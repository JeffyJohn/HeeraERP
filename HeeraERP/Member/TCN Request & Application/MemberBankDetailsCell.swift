//
//  MemberBankDetailsCell.swift
//  HeeraERP
//
//  Created by Suvan on 12/21/17.
//  Copyright © 2017 Suvan. All rights reserved.
//

import UIKit

class MemberBankDetailsCell: UITableViewCell {

    
    @IBOutlet weak var txt_cell_bankAccountNo: UITextField!
    @IBOutlet weak var txt_cell_bankName: UITextField!
    @IBOutlet weak var txt_cell_branch: UITextField!
    @IBOutlet weak var txt_cell_ifsc: UITextField!
    @IBOutlet weak var txt_cell_accountHolder: UITextField!
    @IBOutlet weak var lbl_line: UILabel!
    
    @IBOutlet weak var btn_withdraw: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        BasicProperties.textBorderStyle(textField: txt_cell_bankAccountNo)
        BasicProperties.textBorderStyle(textField: txt_cell_bankName)
        BasicProperties.textBorderStyle(textField: txt_cell_branch)
        BasicProperties.textBorderStyle(textField: txt_cell_ifsc)
        BasicProperties.textBorderStyle(textField: txt_cell_accountHolder)
        BasicProperties.buttonBorderStyle(button: btn_withdraw)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
