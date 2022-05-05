//
//  RecordTableViewCell.swift
//  FypTest_APP


import UIKit

class RecordTableViewCell: UITableViewCell {

    
    @IBOutlet weak var gymTypeLabel: UILabel!
    @IBOutlet weak var gymTimeLabel: UILabel!
    
    @IBOutlet weak var gymTypeImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
