//
//  IncomeExpenseTableViewCell.swift
//  Wallet
//
//  Created by Krunal Shah on 2022-08-14.
//

import UIKit

class IncomeExpenseTableViewCell: UITableViewCell {
    
    @IBOutlet weak var tType: UILabel!
    @IBOutlet weak var amount: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func fillCell(type: String, cAmount: String) {
        tType.text = type
        amount.text = cAmount
    }
}
