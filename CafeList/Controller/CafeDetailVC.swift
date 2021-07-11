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
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        // 導覽列按鈕文字顏色
        navigationController?.navigationBar.tintColor = Colors.shared.primaryDarkColor
        // 不要調整內容的區域，讓內容蓋住透明的導覽列
        tableView.contentInsetAdjustmentBehavior = .never
        
        
    }
    
    func setMapView() {
        // Configure map view
        let coordinate = CLLocationCoordinate2D(latitude: Double(currentCafe.latitude)!, longitude: Double(currentCafe.longitude)!)
        let camera = GMSCameraPosition.camera(withLatitude: coordinate.latitude, longitude: coordinate.longitude, zoom: 15.0)
        
        mapView = GMSMapView.map(withFrame: self.mapUIView.frame, camera: camera)
        
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
    
    // MARK: - UITableView Methods.
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        
        case 0:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CafeDetailIconTextCell.self), for: indexPath) as! CafeDetailIconTextCell
            
            cell.iconImageView.image = UIImage(systemName: "map")?.withTintColor(.black, renderingMode: .alwaysOriginal)
            cell.shortTextLabel.text = currentCafe.address
            cell.selectionStyle = .none
            
            return cell
            
        case 1:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CafeDetailIconTextCell.self), for: indexPath) as! CafeDetailIconTextCell
            
            cell.iconImageView.image = UIImage(systemName: "doc")?.withTintColor(.black, renderingMode: .alwaysOriginal)
            cell.shortTextLabel.text =
                currentCafe.weburl == "" ? "未提供網站網址" : currentCafe.weburl
            cell.selectionStyle = .none
            
            return cell
            
        case 2:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CafeDetailIconTextCell.self), for: indexPath) as! CafeDetailIconTextCell
            
            cell.iconImageView.image = UIImage(systemName: "clock")?.withTintColor(.black, renderingMode: .alwaysOriginal)
            
            cell.shortTextLabel.text =
                currentCafe.open_time == "" ? "未提供營業時間" : "營業時間：\(currentCafe.open_time)"
            
            cell.selectionStyle = .none
            
            return cell
            
        default:
            fatalError("Failed to instantiate the table view cell for detail view controller")
        }
    }
    
}
