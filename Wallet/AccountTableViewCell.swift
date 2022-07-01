//
//  AccountTableViewCell.swift
//  Wallet
//
//  Created by Krunal Shah on 2022-06-30.
//

import UIKit

class AccountTableViewCell: UITableViewCell {

    @IBOutlet weak var accountNameLabel: UILabel!
    @IBOutlet weak var currentBalanceLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func fillCell(accountName: String, currentBalance: String) {
        accountNameLabel.text = accountName
        currentBalanceLabel.text = currentBalance
    }
}
