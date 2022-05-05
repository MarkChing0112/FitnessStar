//
//  RecordDetailTableViewCell.swift
//  FypTest_APP
//
//  Created by kin ming ching on 5/5/2022.
//

import UIKit

class RecordDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var User_Train_Set: UILabel!
    @IBOutlet weak var User_Total_Time: UILabel!
    @IBOutlet weak var AccuraryLBL: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
