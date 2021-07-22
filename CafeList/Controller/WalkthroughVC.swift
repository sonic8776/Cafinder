//
//  WalkthroughVC.swift
//  CafeList
//
//  Created by Judy Tsai on 2021/7/21.
//

import UIKit
import CoreLocation

class WalkthroughVC: UIViewController, WalkthroughPageViewControllerDelegate {

    @IBOutlet var pageControl: UIPageControl!
    @IBOutlet var nextButton: UIButton! {
        didSet {
            nextButton.layer.cornerRadius = 25.0
            nextButton.layer.masksToBounds = true
        }
    }
    
    var walkthroughPageViewController: WalkthroughPageVC?
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    // MARK: - Action methods
    
    @IBAction func nextButtonTapped(sender: UIButton) {
        
        if let index = walkthroughPageViewController?.currentIndex {
            switch index {
            case 0...1:
                walkthroughPageViewController?.forwardPage()
                
            case 2:
                locationManager.requestWhenInUseAuthorization()
                locationManager.requestAlwaysAuthorization()
                UserDefaults.standard.set(true, forKey: "hasViewedWalkthrough")
                dismiss(animated: true, completion: nil)
                
            default: break
                
            }
        }
        
        updateUI()
    }
    
    func updateUI() {

        if let index = walkthroughPageViewController?.currentIndex {
            switch index {
            case 0...1:
                nextButton.setTitle("繼續", for: .normal)
              
            case 2:
                nextButton.setTitle("開始使用", for: .normal)
               
            default: break
            }
            
            pageControl.currentPage = index
        }
        
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination
        if let pageViewController = destination as? WalkthroughPageVC {
            walkthroughPageViewController = pageViewController
            walkthroughPageViewController?.walkthroughDelegate = self
        }
    }
    
    // MARK: - WalkthroughPageViewControllerDelegate method
    
    func didUpdatePageIndex(currentIndex: Int) {
        updateUI()
    }
}
