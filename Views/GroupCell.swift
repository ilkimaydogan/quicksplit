//
//  GroupCell.swift
//  quicksplit
//
//  Created by İlkim İclal Aydoğan on 22.02.2025.
//

import UIKit

class GroupCell: UITableViewCell {


    @IBOutlet weak var groupCellBubble: UIView!
    @IBOutlet weak var groupNameLabel: UILabel!
    @IBOutlet weak var memberTotalLabel: UILabel!
    @IBOutlet weak var totalSpendingLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        groupCellBubble.layer.cornerRadius = groupCellBubble.frame.size.height / 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
