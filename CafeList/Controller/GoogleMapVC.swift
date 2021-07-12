//
//  GoogleMapVC.swift
//  CafeList
//
//  Created by Judy Tsai on 2021/6/26.
//

import UIKit
import GoogleMaps
import CoreLocation

class GoogleMapVC: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate {
    
    @IBOutlet weak var mapUIView: UIView!
    
    let manager = CLLocationManager()
    let myColor = Colors.shared
    var mapView = GMSMapView()
    
    var cafeManager = CafeManager()
    //var cafeList = [Cafe]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        manager.requestWhenInUseAuthorization()
        manager.requestAlwaysAuthorization()
        
        let textAttributes = [NSAttributedString.Key.foregroundColor: myColor.primaryColor]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        mapView.delegate = self
        
        //fetchJsonData()
        //test()
        showCafesOnMap()
        
        if !CLLocationManager.locationServicesEnabled() {
            displayAlert(title: "Oops!", message: "請開啟定位服務，才能顯示您的位置唷！")
        } else {
            manager.desiredAccuracy = kCLLocationAccuracyBest
            manager.activityType = .automotiveNavigation
            manager.allowsBackgroundLocationUpdates = true
            manager.delegate = self
            manager.startUpdatingLocation()
            manager.startUpdatingHeading()
            
            mapView.settings.myLocationButton = true
            mapView.isMyLocationEnabled = true
        }
 
        // print("License: \n\n\(GMSServices.openSourceLicenseInfo())")
    }
    
    func displayAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "好喔", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    /*
    func test() {
        if let url = URL(string: "https://cafenomad.tw/api/v1.2/cafes/kaohsiung") {
            let request = URLRequest(url: url)
            let session = URLSession.shared
            
            let task = session.dataTask(with: request) { (data, response, error) in
                
                if let error = error {
                    print("Error: \(error)")
                    return
                }
                
                guard let responseData = data else { return }
                do {
                    if let allCafes = try JSONSerialization.jsonObject(with: responseData, options: []) as? [[String: Any]] {
                        for item in allCafes {
                            
                            let cafe = Cafe(json: item)
                            cafe?.latitude = item["latitude"] as! String
                            cafe?.longitude = item["longitude"] as! String
                            cafe?.name = item["name"] as! String
                            //self.cafeList.append(cafe!)
                        }
                    }
                    let decoder = JSONDecoder()
                    //self.cafeList = try decoder.decode([Cafe].self, from: responseData)
                } catch {
                    print("Error getting json data: \(error)")
                }
            }
            task.resume()
        }

    }
    
    func fetchJsonData(){
        
        let urlStr = "https://cafenomad.tw/api/v1.2/cafes/kaohsiung".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let url = URL(string: urlStr!)
        let task = URLSession.shared.dataTask(with: url!) {(data, response, error) in
            
            if let error = error {
                assertionFailure("Error fetching JSON data: \(error)")
            }
            
            if let data = data,
               let resultArray = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [[String: Any]] {
                
                    for coffeeshop in resultArray{
                        if let cafe = Cafe(json: coffeeshop){
                            //self.cafeList.append(cafe)
                        }
                    }
                    
                
            }
        }
        task.resume()
        
    }
    */
    
    func showCafesOnMap(){
        
        for data in CafeManager.cafeList {
            
            if let lat = CLLocationDegrees(data.latitude),
               let lon = CLLocationDegrees(data.longitude) {
                
                let location = CLLocationCoordinate2D(latitude: lat, longitude: lon)
                
                let marker = GMSMarker()
                marker.position = location
                marker.appearAnimation = .pop
                marker.title = data.name
                marker.icon = GMSMarker.markerImage(with: .brown)
                marker.map = mapView
            }
            
        }
        self.mapUIView.addSubview(mapView)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Show the user's current location with blue pot.
        guard let location = locations.first else { return }
        
        let testLat = 22.631435
        let testLon = 120.301950
        let testCoor = CLLocationCoordinate2D(latitude: testLat, longitude: testLon)
        
        //let coordinate = location.coordinate
        //let camera = GMSCameraPosition.camera(withLatitude: coordinate.latitude, longitude: coordinate.longitude, zoom: 18.0)
        let camera = GMSCameraPosition.camera(withLatitude: testCoor.latitude, longitude: testCoor.longitude, zoom: 18.0)
        mapView = GMSMapView.map(withFrame: self.view.frame, camera: camera)

        self.mapUIView.addSubview(mapView)
        showCafesOnMap()
        manager.stopUpdatingLocation()
        
        // Creates a marker in the center of the map.
        //        let marker = GMSMarker()
        //        marker.position = coordinate
        //        marker.title = "HK"
        //        marker.snippet = "China"
        //        marker.map = mapView
    }
    
}
