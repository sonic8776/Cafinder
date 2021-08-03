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

// Point of Interest Item which implements the GMUClusterItem protocol.
class POIItem: NSObject, GMUClusterItem {
    var position: CLLocationCoordinate2D
    var name: String!
    
    init(position: CLLocationCoordinate2D, name: String) {
        self.position = position
        self.name = name
    }
}


class GoogleMapVC: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate {
    
    @IBOutlet weak var mapUIView: UIView!
    
    let manager = CLLocationManager()
    let myColor = Colors.shared
    var userLocation: CLLocation?
    private var mapView = GMSMapView()
    private var clusterManager: GMUClusterManager!
    private var observer: NSObjectProtocol?
    
    //var didShowMap = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setMapView()
        setCluster()
        showCafesOnMap()
        
        // Set navigationBar color
        let textAttributes = [NSAttributedString.Key.foregroundColor: myColor.primaryColor]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        observer = NotificationCenter.default.addObserver(forName: UIScene.willEnterForegroundNotification, object: nil, queue: .main) { [unowned self] notification in
            // do whatever you want when the app is brought back to the foreground
            checkLocationService()
        }
    }
    
    func setMapView() {
        // Set mapView
        let defaultCenter = CLLocationCoordinate2D(latitude: -32.725757, longitude: 21.481987)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(mapView)
        mapView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        mapView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor).isActive = true
        mapView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        mapView.camera = GMSCameraPosition(target: defaultCenter, zoom: 1, bearing: 0, viewingAngle: 0)
        mapView.delegate = self
    }
    
    func setCluster() {
        // Set up the cluster manager with the supplied icon generator and renderer.
        //let iconGenerator = MapClusterIconGenerator()
        let iconGenerator = GMUDefaultClusterIconGenerator()
        //let iconGenerator = GMUDefaultClusterIconGenerator.init(buckets: [9999], backgroundColors: [myColor.secondaryColor])
        let algorithm = GMUNonHierarchicalDistanceBasedAlgorithm()
        let renderer = GMUDefaultClusterRenderer(mapView: mapView,
                                                 clusterIconGenerator: iconGenerator)
        clusterManager = GMUClusterManager(map: mapView, algorithm: algorithm, renderer: renderer)
        
        // Register self to listen to GMSMapViewDelegate events.
        clusterManager.setMapDelegate(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        checkLocationService()
    }
    
    func checkLocationService() {
        // Check if locationServices have been enabled
        if !CLLocationManager.locationServicesEnabled() {
            // not enabled -> Set map center to Taipei Main Station
            let coordinate = CLLocationCoordinate2D(latitude: 25.046273, longitude: 121.517498)
            
            CATransaction.begin()
            CATransaction.setValue(Int(2), forKey: kCATransactionAnimationDuration)
            mapView.animate(toLocation: coordinate)
            mapView.animate(toZoom: 18)
            CATransaction.commit()
            
            displayAlert(title: "定位服務還沒打開", message: "請至 設定 > 隱私權 > 開啟定位服務，並重開地圖")
        } else {
            // enabled -> startUpdating user's location
            manager.desiredAccuracy = kCLLocationAccuracyBest
            manager.activityType = .automotiveNavigation
            manager.delegate = self
            manager.startUpdatingLocation()
            manager.startUpdatingHeading()
            
            mapView.settings.myLocationButton = true
            mapView.isMyLocationEnabled = true
        }
    }
    
    func creatLocationNotification() {
        // To Be Done: suggest a nearby cafe to user
        // Choose a cafe randomly
        let randomNum = Int.random(in: 0..<CafeManager.cafeList.count)
        let suggestedCafe = CafeManager.cafeList[randomNum]
        
        // Create user notification
        let content = UNMutableNotificationContent()
        content.title = "推薦咖啡廳"
        content.body = "推薦你看看 \(suggestedCafe.name)，位於 \(suggestedCafe.address)，週末去喝杯咖啡吧！"
        content.sound = UNNotificationSound.default
        
        guard let userCoordinate = userLocation?.coordinate else {
            print("Can't get userLocation.coordinate.")
            return
        }
        
        let center = userCoordinate
        let region = CLCircularRegion(center: center, radius: 2000.0, identifier: "Headquarters")
        region.notifyOnEntry = true
        region.notifyOnExit = false
        let trigger = UNLocationNotificationTrigger(region: region, repeats: false)
        let request = UNNotificationRequest(identifier: "location", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error adding request to UNUserNotificationCenter: \(error)")
            }
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
        var markerArray = [GMSMarker]()
        for data in CafeManager.cafeList {
            
            if let lat = CLLocationDegrees(data.latitude),
               let lon = CLLocationDegrees(data.longitude) {
                
                let location = CLLocationCoordinate2D(latitude: lat, longitude: lon)
                
                if CLLocationCoordinate2DIsValid(location) {
                    
                    let marker = GMSMarker(position: location)

                    marker.title = data.name
                    marker.snippet = data.address
                    marker.icon = icon
                    markerArray.append(marker)
                    
                } else {
                    print("Invalid location: \(data.name), (\(location.latitude), \(location.longitude))")
                }
            }
        }
        clusterManager.add(markerArray)
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
//        self.mapView.camera = GMSCameraPosition.camera(withTarget: marker.position, zoom: 18.0)
//        let update = GMSCameraUpdate.zoom(by: 1)
//        mapView.animate(with: update)
        
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
        userLocation = currentLocation
        
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
    deinit {
        if let observer = observer {
            NotificationCenter.default.removeObserver(observer)
        }
    }
}
