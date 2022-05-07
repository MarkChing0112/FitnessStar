//
//  searchGymRoomTableViewCell.swift
//  FypTest_APP


import UIKit

class searchGymRoomTableViewCell: UITableViewCell {

    @IBOutlet weak var gymRoom: UILabel!
    @IBOutlet weak var GymRoomImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.GymRoomImageView.layer.masksToBounds = true
        self.GymRoomImageView.layer.cornerRadius = 20
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
