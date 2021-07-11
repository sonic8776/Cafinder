//
//  CafeDetailIconTextCell.swift
//  CafeList
//
//  Created by Judy Tsai on 2021/6/18.
//

import UIKit

class CafeDetailIconTextCell: UITableViewCell {

    @IBOutlet var iconImageView : UIImageView!
    @IBOutlet var shortTextLabel : UILabel! {
        didSet {
            shortTextLabel.numberOfLines = 0
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        iconImageView.tintColor = Colors.shared.primaryDarkColor
        shortTextLabel.textColor = Colors.shared.primaryDarkColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
