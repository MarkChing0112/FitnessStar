//
//  RecordChallengeTableViewCell.swift
//  FypTest_APP
//
//  Created by kin ming ching on 4/5/2022.
//

import UIKit

class RecordChallengeTableViewCell: UITableViewCell {
    @IBOutlet weak var gymTypeLabel: UILabel!
    @IBOutlet weak var gymTimeLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
