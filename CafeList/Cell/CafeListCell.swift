//
//  CafeListCell.swift
//  CafeList
//
//  Created by Judy Tsai on 2021/6/18.
//

import UIKit

class CafeListCell: UITableViewCell {

    @IBOutlet var nameLabel : UILabel!
    @IBOutlet var locationLabel : UILabel!
    @IBOutlet var socketLabel : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        self.backgroundColor = Colors.shared.primaryLightColor
        nameLabel.textColor = Colors.shared.primaryColor
        locationLabel.textColor = Colors.shared.secondaryTextColor
        socketLabel.textColor = Colors.shared.primaryLightColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
