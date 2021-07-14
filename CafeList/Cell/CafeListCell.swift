//
//  CafeListCell_V2.swift
//  CafeList
//
//  Created by Judy Tsai on 2021/7/11.
//

import UIKit

class CafeListCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var backgroundCardView: UIView!
    @IBOutlet weak var socketLabel: UILabel!
    @IBOutlet weak var limit_timeLabel: UILabel!
    @IBOutlet weak var mrtLabel: PaddingLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Set colors
        nameLabel.textColor = Colors.shared.primaryColor
        locationLabel.textColor = Colors.shared.secondaryTextColor
        socketLabel.textColor = Colors.shared.primaryLightColor
        limit_timeLabel.textColor = Colors.shared.primaryLightColor
        
        backgroundCardView.backgroundColor = .white
        contentView.backgroundColor = UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1.0)
        
        // Set card view layer
        backgroundCardView.layer.cornerRadius = 10.0
        backgroundCardView.layer.masksToBounds = false
        
        backgroundCardView.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
        backgroundCardView.layer.shadowOffset = CGSize(width: 0, height: 0)
        backgroundCardView.layer.shadowOpacity = 0.8
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
