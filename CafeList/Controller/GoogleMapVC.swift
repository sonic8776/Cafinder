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
        
        // Set mapView
        let defaultCenter = CLLocationCoordinate2D(latitude: -32.725757, longitude: 21.481987)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(mapView)
        mapView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        mapView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor).isActive = true
        mapView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        mapView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        mapView.camera = GMSCameraPosition(target: defaultCenter, zoom: 1, bearing: 0, viewingAngle: 0)
        mapView.delegate = self
        
        // Set navigationBar color
        let textAttributes = [NSAttributedString.Key.foregroundColor: myColor.primaryColor]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        
        // Set up the cluster manager with the supplied icon generator and renderer.
        let iconGenerator = GMUDefaultClusterIconGenerator()
        let algorithm = GMUNonHierarchicalDistanceBasedAlgorithm()
        let renderer = GMUDefaultClusterRenderer(mapView: mapView,
                                                 clusterIconGenerator: iconGenerator)
        clusterManager = GMUClusterManager(map: mapView, algorithm: algorithm, renderer: renderer)
        
        // Register self to listen to GMSMapViewDelegate events.
        clusterManager.setMapDelegate(self)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Check if locationServices have been enabled
        if !CLLocationManager.locationServicesEnabled() {
            
            let coordinate = CLLocationCoordinate2D(latitude: 25.046273, longitude: 121.517498)
            
            CATransaction.begin()
            CATransaction.setValue(Int(2), forKey: kCATransactionAnimationDuration)
            mapView.animate(toLocation: coordinate)
            mapView.animate(toZoom: 18)
            CATransaction.commit()
            
            showCafesOnMap()
            
            displayAlert(title: "定位服務還沒打開", message: "請至 設定 > 隱私權 > 開啟定位服務，並重開地圖")
        } else {
            manager.desiredAccuracy = kCLLocationAccuracyBest
            manager.activityType = .automotiveNavigation
            manager.allowsBackgroundLocationUpdates = true
            manager.delegate = self
            manager.startUpdatingLocation()
            manager.startUpdatingHeading()
            
            mapView.settings.myLocationButton = true
            mapView.isMyLocationEnabled = true
            
            showCafesOnMap()
        }
        
    }
    
    func displayAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let confirm = UIAlertAction(title: "開啟定位", style: .default, handler: { action in
            
            if let url = URL(string:UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        })
        let cancel = UIAlertAction(title: "純看地圖", style: .cancel, handler: nil)
        
        alert.addAction(confirm)
        alert.addAction(cancel)
        alert.preferredAction = confirm
        alert.view.tintColor = myColor.primaryColor
        
        present(alert, animated: true, completion: nil)
    }
    
    func showCafesOnMap(){
        
        let icon = GMSMarker.markerImage(with: .brown)
        for data in CafeManager.cafeList {
            
            if let lat = CLLocationDegrees(data.latitude),
               let lon = CLLocationDegrees(data.longitude) {
                
                let location = CLLocationCoordinate2D(latitude: lat, longitude: lon)
                
                if CLLocationCoordinate2DIsValid(location) {
                    
                    let marker = GMSMarker(position: location)
                    marker.position = location
                    marker.appearAnimation = .pop
                    marker.title = data.name
                    marker.snippet = data.address
                    marker.icon = icon
                    marker.map = mapView
                    clusterManager.add(marker)
                    
                } else {
                    print("Invalid location: \(data.name), (\(location.latitude), \(location.longitude))")
                }
            }
        }
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
        
        //        let bounds = GMSCoordinateBounds(coordinate: self.userLocation!.coordinate, coordinate: marker.position)
        //        self.mapView.animateWithCameraUpdate(GMSCameraUpdate.fitBounds(bounds, withPadding: 120.0))
        self.mapView.camera = GMSCameraPosition.camera(withTarget: marker.position, zoom: 18.0)
        let update = GMSCameraUpdate.zoom(by: 1)
        mapView.animate(with: update)
        
        print("Did tap a normal marker")
        return false
    }
    
    // Tap info window of marker to see cafe detail
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        
        performSegue(withIdentifier: "checkDetailFromMap", sender: marker)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "checkDetailFromMap" {
            if let detailVC = segue.destination as? CafeDetailVC,
               let marker = sender as? GMSMarker {
                
                for cafe in CafeManager.cafeList {
                    if cafe.name == marker.title {
                        detailVC.currentCafe = cafe
                        break
                    }
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Show the user's current location with blue pot.
        guard let currentLocation = locations.first else { return }
        print("Current Location: (\(currentLocation.coordinate.latitude), \(currentLocation.coordinate.longitude))")
        
        let coordinate = currentLocation.coordinate
        
        CATransaction.begin()
        CATransaction.setValue(Int(2), forKey: kCATransactionAnimationDuration)
        mapView.animate(toLocation: coordinate)
        mapView.animate(toZoom: 18)
        CATransaction.commit()
        
        
        //        if !didShowMap {
        //            showCafesOnMap()
        //            didShowMap = true
        //            manager.stopUpdatingLocation()
        //        }
        
        manager.stopUpdatingLocation()
        
    }
}
