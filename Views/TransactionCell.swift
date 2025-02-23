//
//  TransactionCell.swift
//  quicksplit
//
//  Created by İlkim İclal Aydoğan on 22.02.2025.
//

import UIKit

class TransactionCell: UITableViewCell {

    @IBOutlet weak var transactionBubble: UIView!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var transactionTitleLabel: UILabel!
    @IBOutlet weak var transactionPayerLabel: UILabel!
    @IBOutlet weak var transactionAmountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        transactionBubble.layer.cornerRadius = transactionBubble.frame.size.height / 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
