//
//  ViewController.swift
//  CafeList
//
//  Created by Judy Tsai on 2021/6/17.
//

import UIKit
import GoogleMaps
import CoreLocation

class CafeDetailVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var currentCafe : Cafe!
    var mapView = GMSMapView()
    let manager = CLLocationManager()
    let myColor = Colors.shared
    
    @IBOutlet var tableView : UITableView!
    @IBOutlet weak var mapUIView: UIView!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.hidesBarsOnSwipe = false
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = false
        
        navigationItem.title = currentCafe.name
        setMapView()
        
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.activityType = .automotiveNavigation
        
        tableView.separatorStyle = .none
        // 導覽列變透明
//        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
//        navigationController?.navigationBar.shadowImage = UIImage()
        // 導覽列按鈕文字顏色
        navigationController?.navigationBar.tintColor = myColor.primaryDarkColor
        // 不要調整內容的區域，讓內容蓋住透明的導覽列
//        tableView.contentInsetAdjustmentBehavior = .never
        
        tableView.allowsSelection = false
        
        //displayAlert(title: "小提醒", message: "如果星星數為零，可能是尚未上傳評分資訊，不代表這間店真實評價唷！")
    }
    
    func setMapView() {
        // Configure map view
        let coordinate = CLLocationCoordinate2D(latitude: Double(currentCafe.latitude)!, longitude: Double(currentCafe.longitude)!)
        let camera = GMSCameraPosition.camera(withLatitude: coordinate.latitude, longitude: coordinate.longitude, zoom: 15.0)
        
        mapView = GMSMapView.map(withFrame: self.mapUIView.frame, camera: camera)
        mapView.delegate = self
        
        // Configure a marker
        let marker = GMSMarker()
        marker.position = coordinate
        marker.title = currentCafe.name
        marker.snippet = currentCafe.address
        marker.map = mapView
        mapView.selectedMarker = marker
        
        self.mapUIView.addSubview(mapView)
        
        // Set constraints to mapView
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        mapView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        mapView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: tableView.topAnchor).isActive = true

    }
    
    func displayAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "我知道了", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - UITableView Methods.
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 9
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row <= 5 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CafeDetailRatingCell.self), for: indexPath) as! CafeDetailRatingCell
            cell.descriptionLabel.textColor = myColor.primaryColor
            
            // Set star settings
            cell.ratingStars.settings.updateOnTouch = false
            cell.ratingStars.settings.starMargin = 5
            cell.ratingStars.settings.starSize = 23
            cell.ratingStars.settings.emptyColor = myColor.emptyStar
            cell.ratingStars.settings.emptyBorderColor = .white
            cell.ratingStars.settings.filledColor = myColor.secondaryColor
            cell.ratingStars.settings.filledBorderColor = .white
            
            switch indexPath.row {
            
            case 0:
                
                cell.descriptionLabel.text = "WiFi 穩定"
                cell.ratingStars.rating = currentCafe.wifi
                
                return cell
                
            case 1:
                
                cell.descriptionLabel.text = "價格便宜"
                cell.ratingStars.rating = currentCafe.cheap

                return cell
                
            case 2:
                
                cell.descriptionLabel.text = "安靜程度"
                cell.ratingStars.rating = currentCafe.quiet
                
                return cell
                
            case 3:
                
                cell.descriptionLabel.text = "食物美味"
                cell.ratingStars.rating = currentCafe.tasty
                
                return cell
                
            case 4:
                
                cell.descriptionLabel.text = "裝潢音樂"
                cell.ratingStars.rating = currentCafe.music
                
                return cell
                
            case 5:
                
                cell.descriptionLabel.text = "通常有位"
                cell.ratingStars.rating = currentCafe.seat
                
                return cell
                
            default:
                fatalError("Failed to instantiate the table view cell for detail view controller")
            }
            
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CafeDetailTextCell.self), for: indexPath) as! CafeDetailTextCell
            cell.descriptionLabel.textColor = myColor.primaryColor
            cell.rightLabel.textColor = myColor.primaryColor
            
            switch indexPath.row {
            
            case 6:
                
                cell.descriptionLabel.text = "有無限時"
                
                switch currentCafe.limited_time {
                case "yes":
                    cell.rightLabel.text = "一律有限時"
                case "maybe":
                    cell.rightLabel.text = "看情況，假日或客滿限時"
                case "no":
                    cell.rightLabel.text = "一律不限時"
                default:
                    cell.rightLabel.text = "未提供限時資訊"
                }
                
                return cell
            
            case 7:
                
                cell.descriptionLabel.text = "營業時間"
                if currentCafe.open_time != "" {
                    cell.rightLabel.text = currentCafe.open_time
                } else {
                    cell.rightLabel.text = "附近沒有捷運 / 未提供資訊"
                }
                
                return cell
                
            case 8:
                
                cell.descriptionLabel.text = "可站立工作"
                
                switch currentCafe.standing_desk {
                case "yes":
                    cell.rightLabel.text = "有些座位可以"
                case "no":
                    cell.rightLabel.text = "無法"
                default:
                    cell.rightLabel.text = "未提供站位資訊"
                }
                
                return cell
                
            case 9:
                
                cell.descriptionLabel.text = "鄰近捷運"
                cell.rightLabel.text = currentCafe.mrt
                
                return cell
                
            default:
                fatalError("Failed to instantiate the table view cell for detail view controller")
            }
        }
        
    }
    
}

extension CafeDetailVC: GMSMapViewDelegate {
    
    // Tap info window of marker to open Google Maps app or browser to see more information.
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        let lat = currentCafe.latitude
        let long = currentCafe.longitude
        if UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!) {
            UIApplication.shared.open(URL(string:"comgooglemaps://?center=\(lat),\(long)&zoom=17&views=traffic&q=\(lat),\(long)")!, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.open(URL(string: "http://maps.google.com/maps?q=loc:\(lat),\(long)&zoom=17&views=traffic&q=\(lat),\(long)")!, options: [:], completionHandler: nil)
        }
    }
    
    // Tap marker to open Google Maps app or browser to see more information.
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        let lat = currentCafe.latitude
        let long = currentCafe.longitude
        if UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!) {
            UIApplication.shared.open(URL(string:"comgooglemaps://?center=\(lat),\(long)&zoom=17&views=traffic&q=\(lat),\(long)")!, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.open(URL(string: "http://maps.google.com/maps?q=loc:\(lat),\(long)&zoom=17&views=traffic&q=\(lat),\(long)")!, options: [:], completionHandler: nil)
        }
        return true
    }
}
