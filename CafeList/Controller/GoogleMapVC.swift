//
//  GoogleMapVC.swift
//  CafeList
//
//  Created by Judy Tsai on 2021/6/26.
//

import UIKit
import GoogleMaps
import GoogleMapsUtils
import CoreLocation

class GoogleMapVC: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate {
    
    @IBOutlet weak var mapUIView: UIView!
    
    let manager = CLLocationManager()
    let myColor = Colors.shared
    private var mapView = GMSMapView()
    private var clusterManager: GMUClusterManager!
    
    var didShowMap = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.mapUIView.addSubview(mapView)
        
        // Insets are specified in this order: top, left, bottom, right
//        let mapInsets = UIEdgeInsets(top: 100.0, left: 0.0, bottom: 0.0, right: 300.0)
//        mapView.padding = mapInsets
        
        let textAttributes = [NSAttributedString.Key.foregroundColor: myColor.primaryColor]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        mapView.delegate = self
        
        // Set up the cluster manager with the supplied icon generator and renderer.
        let iconGenerator = GMUDefaultClusterIconGenerator()
        let algorithm = GMUNonHierarchicalDistanceBasedAlgorithm()
        let renderer = GMUDefaultClusterRenderer(mapView: mapView,
                                    clusterIconGenerator: iconGenerator)
        clusterManager = GMUClusterManager(map: mapView, algorithm: algorithm, renderer: renderer)

        // Register self to listen to GMSMapViewDelegate events.
        clusterManager.setMapDelegate(self)
        
        //showCafesOnMap()
        
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
    /* Get JSON data
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
                
                if CLLocationCoordinate2DIsValid(location) {
                    
                    let marker = GMSMarker(position: location)
                    marker.position = location
                    marker.appearAnimation = .pop
                    marker.title = data.name
                    marker.icon = GMSMarker.markerImage(with: .brown)
                    marker.map = mapView
                    clusterManager.add(marker)
                    
                } else {
                    print("Invalid location: \(data.name), (\(location.latitude), \(location.longitude))")
                }
            }
        }
        self.mapUIView.addSubview(mapView)
        clusterManager.cluster()
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
      // Center the map on tapped marker
      mapView.animate(toLocation: marker.position)
      // Check if a cluster icon was tapped
      if marker.userData is GMUCluster {
        // Zoom in on tapped cluster
        mapView.animate(toZoom: mapView.camera.zoom + 1)
        print("Did tap cluster")
        return true
      }
        
        
        
      print("Did tap a normal marker")
      return false
    }
    
    // Tap info window of marker to see cafe detail
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
       
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Show the user's current location with blue pot.
        guard let location = locations.first else { return }
        
        let coordinate = location.coordinate
        let camera = GMSCameraPosition.camera(withLatitude: coordinate.latitude, longitude: coordinate.longitude, zoom: 18.0)

        // Insets are specified in this order: top, left, bottom, right
        let mapInsets = UIEdgeInsets(top: 100.0, left: 0.0, bottom: 0.0, right: 300.0)
        mapView.padding = mapInsets
        
        mapView = GMSMapView.map(withFrame: CGRect(x:0, y:0, width:self.view.bounds.width, height:self.view.bounds.height - self.tabBarController!.tabBar.frame.height), camera: camera)

        //self.mapUIView.addSubview(mapView)
        //showCafesOnMap()
        //manager.stopUpdatingLocation()
        
        
        if !didShowMap {
            showCafesOnMap()
            didShowMap = true
            manager.stopUpdatingLocation()
        }

    }
}
