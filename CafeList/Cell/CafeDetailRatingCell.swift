//
//  CafeDetailRatingCell.swift
//  CafeList
//
//  Created by Judy Tsai on 2021/7/14.
//

import UIKit
import Cosmos

class CafeDetailRatingCell: UITableViewCell {

    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var ratingStars: CosmosView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
