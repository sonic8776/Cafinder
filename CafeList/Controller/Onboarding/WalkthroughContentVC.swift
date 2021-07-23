//
//  WalkthroughContentVC.swift
//  CafeList
//
//  Created by Judy Tsai on 2021/7/21.
//

import UIKit

class WalkthroughContentVC: UIViewController {

    @IBOutlet var contentImageView: UIImageView!

    var index = 0
    var heading = ""
    var subHeading = ""
    var imageFile = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        headingLabel.text = heading
//        subHeadingLabel.text = subHeading
        contentImageView.image = UIImage(named: imageFile)
    }
    

}
