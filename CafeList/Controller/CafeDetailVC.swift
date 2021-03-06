//
//  ViewController.swift
//  CafeList
//
//  Created by Judy Tsai on 2021/6/17.
//

import UIKit
import GoogleMaps
import CoreLocation
import CoreData

class CafeDetailVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var currentCafe: Cafe!
    var mapView = GMSMapView()
    let manager = CLLocationManager()
    let myColor = Colors.shared
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var isFavorite: Bool! {
        
        let request: NSFetchRequest<CafeItem> = CafeItem.fetchRequest()
        request.predicate = NSPredicate(format: "id MATCHES %@", currentCafe.id)
        request.fetchLimit = 1
        
        do {
            let count = try context.count(for: request)
            if(count == 0){
                // no matching object
                return false
            }
            else{
                // at least one matching object exists
                return true
            }
        }
        catch {
            print("Could not fetch \(error)")
        }
        return nil
    }
    
    var webURL: String?
    
    @IBOutlet var tableView : UITableView!
    @IBOutlet weak var mapUIView: UIView!
    @IBOutlet weak var favoriteBtn: UIBarButtonItem!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.hidesBarsOnSwipe = false
        navigationController?.setNavigationBarHidden(false, animated: true)
        
        webURL = currentCafe.weburl
        
        currentCafe.isFavorite = isFavorite
        favoriteBtn.image = currentCafe.isFavorite ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = false
        
        navigationItem.title = currentCafe.name
        setMapView()
        
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.activityType = .automotiveNavigation
        
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
        
        favoriteBtn.tintColor = myColor.mrtRed
        
        // ??????????????????
        //        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        //        navigationController?.navigationBar.shadowImage = UIImage()
        // ???????????????????????????
        navigationController?.navigationBar.tintColor = myColor.primaryDarkColor
        // ???????????????????????????????????????????????????????????????
        //        tableView.contentInsetAdjustmentBehavior = .never
        
        tableView.allowsSelection = false
        
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
        marker.icon = GMSMarker.markerImage(with: .brown)
        marker.map = mapView
        mapView.selectedMarker = marker
        
        self.mapUIView.addSubview(mapView)
        
        // Set constraints to mapView
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        mapView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        mapView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: tableView.topAnchor).isActive = true
        
    }
    
    @IBAction func linkBtnPressed(_ sender: UIButton) {
        guard let safeURL = webURL, safeURL != "" else {
            print("webURL is nil.")
            return
        }
        
        if let url = URL(string: safeURL) {
            UIApplication.shared.open(url)
        } else {
            print("Website URL is not correct")
            displayAlert(title: "???????????????", message: "???????????????????????????")
        }
    }
    
    func displayAlert(title: String, message: String) {
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "??????", style: .default, handler: nil)
        controller.addAction(okAction)
        controller.view.tintColor = myColor.primaryColor
        present(controller, animated: true, completion: nil)
    }
    
    @IBAction func favoriteBtnPressed(_ sender: UIBarButtonItem) {
        
        let favoriteCafe = CafeItem(context: context)
        favoriteCafe.id = currentCafe.id
        favoriteCafe.name = currentCafe.name
        favoriteCafe.city = currentCafe.city
        favoriteCafe.wifi = currentCafe.wifi
        favoriteCafe.seat = currentCafe.seat
        favoriteCafe.quiet = currentCafe.quiet
        favoriteCafe.tasty = currentCafe.tasty
        favoriteCafe.cheap = currentCafe.cheap
        favoriteCafe.music = currentCafe.music
        favoriteCafe.url = currentCafe.weburl
        favoriteCafe.address = currentCafe.address
        favoriteCafe.latitude = currentCafe.latitude
        favoriteCafe.longitude = currentCafe.longitude
        favoriteCafe.limited_time = currentCafe.limited_time
        favoriteCafe.socket = currentCafe.socket
        favoriteCafe.standing_desk = currentCafe.socket
        favoriteCafe.mrt = currentCafe.mrt
        favoriteCafe.open_time = currentCafe.open_time
        
        if !currentCafe.isFavorite {
            // Save to db and add to favorite
            saveCafeItems(isFavorite: true)
            
        } else {
            // Delete from db and remove from favorite
            
            // 1) Check if this object exists in DB by id
            let request: NSFetchRequest<CafeItem> = CafeItem.fetchRequest()
            request.predicate = NSPredicate(format: "id MATCHES %@", currentCafe.id)
            
            do {
                let count = try context.count(for: request)
               
                if(count == 0){
                    // no matching object
                    return
                }
                else {
                    // at least one matching object exists
                    // 2) Delete all matched objects
                    if let result = try? context.fetch(request) {
                        for object in result {
                            context.delete(object)
                        }
                    }
                }
            }
            catch {
                print("Could not fetch \(error)")
            }
            // 3) Save to DB
            saveCafeItems(isFavorite: false)

            print("Successfully deleted data from DB.")
        }
    }
    
    func saveCafeItems(isFavorite: Bool) {
        do {
            try context.save()
            print("Successfully saved data to DB.")
            favoriteBtn.image = isFavorite ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
        } catch {
            print("Error saving context: \(error)")
        }
    }
    
    // MARK: - UITableView Methods.
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 11
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func setTextCell(description: String, indexPath: IndexPath) -> CafeDetailTextCell {
        let textCell = tableView.dequeueReusableCell(withIdentifier: String(describing: CafeDetailTextCell.self), for: indexPath) as! CafeDetailTextCell
        textCell.descriptionLabel.text = description
        textCell.descriptionLabel.textColor = myColor.primaryColor
        textCell.rightLabel.text = "???????????????"
        textCell.rightLabel.textColor = .darkGray
        
        return textCell
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
                
                if currentCafe.wifi == 0 {
                    
                    return setTextCell(description: "WiFi ??????", indexPath: indexPath)
                    
                } else {
                    
                    cell.descriptionLabel.text = "WiFi ??????"
                    cell.ratingStars.rating = currentCafe.wifi
                    
                    return cell
                }
                
            case 1:
                
                if currentCafe.cheap == 0 {
                    
                    return setTextCell(description: "????????????", indexPath: indexPath)
                    
                } else {
                    
                    cell.descriptionLabel.text = "????????????"
                    cell.ratingStars.rating = currentCafe.cheap
                    
                    return cell
                }
                
            case 2:
                
                if currentCafe.quiet == 0 {
                    
                    return setTextCell(description: "????????????", indexPath: indexPath)
                    
                } else {
                    
                    cell.descriptionLabel.text = "????????????"
                    cell.ratingStars.rating = currentCafe.quiet
                    
                    return cell
                }
                
            case 3:
                
                if currentCafe.tasty == 0 {
                    
                    return setTextCell(description: "????????????", indexPath: indexPath)
                    
                } else {
                    
                    cell.descriptionLabel.text = "????????????"
                    cell.ratingStars.rating = currentCafe.tasty
                    
                    return cell
                }
                
            case 4:
                
                if currentCafe.music == 0 {
                    
                    return setTextCell(description: "????????????", indexPath: indexPath)
                    
                } else {
                    
                    cell.descriptionLabel.text = "????????????"
                    cell.ratingStars.rating = currentCafe.music
                    
                    return cell
                }
                
            case 5:
                
                if currentCafe.seat == 0 {
                    
                    return setTextCell(description: "????????????", indexPath: indexPath)
                    
                } else {
                    
                    cell.descriptionLabel.text = "????????????"
                    cell.ratingStars.rating = currentCafe.seat
                    
                    return cell
                }
                
            default:
                fatalError("Failed to instantiate the table view cell for detail view controller")
            }
            
        } else if indexPath.row <= 9 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CafeDetailTextCell.self), for: indexPath) as! CafeDetailTextCell
            cell.descriptionLabel.textColor = myColor.primaryColor
            cell.rightLabel.textColor = myColor.primaryColor
            
            
            switch indexPath.row {
            
            case 6:
                
                cell.descriptionLabel.text = "????????????"
                
                switch currentCafe.limited_time {
                case "yes":
                    cell.rightLabel.text = "???????????????"
                case "maybe":
                    cell.rightLabel.text = "?????????????????????????????????"
                case "no":
                    cell.rightLabel.text = "???????????????"
                default:
                    cell.rightLabel.text = "???????????????"
                    cell.rightLabel.textColor = .darkGray
                }
                
                return cell
                
            case 7:
                
                cell.descriptionLabel.text = "????????????"
                if currentCafe.open_time != "" {
                    cell.rightLabel.text = currentCafe.open_time
                } else {
                    cell.rightLabel.text = "???????????????"
                    cell.rightLabel.textColor = .darkGray
                }
                
                return cell
                
            case 8:
                
                cell.descriptionLabel.text = "???????????????"
                
                switch currentCafe.standing_desk {
                case "yes":
                    cell.rightLabel.text = "??????????????????"
                case "no":
                    cell.rightLabel.text = "??????"
                default:
                    cell.rightLabel.text = "???????????????"
                    cell.rightLabel.textColor = .darkGray
                }
                
                return cell
                
            case 9:
                
                cell.descriptionLabel.text = "????????????"
                if currentCafe.mrt != "" {
                    cell.rightLabel.text = currentCafe.mrt
                } else {
                    cell.rightLabel.text = "?????????????????? / ???????????????"
                    cell.rightLabel.textColor = .darkGray
                }
                
                return cell
                
            default:
                fatalError("Failed to instantiate the table view cell for detail view controller")
            }
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: HyperLinkCell.self), for: indexPath) as! HyperLinkCell
            cell.webURLLabel.text = "?????? / ??????"
            cell.webURLLabel.textColor = myColor.primaryColor
            cell.linkButton.setTitleColor(myColor.primaryColor, for: .normal)
            
            if webURL == nil || webURL == "" {
                cell.linkButton.setTitle("???????????????", for: .normal)
                cell.linkButton.setTitleColor(.darkGray, for: .normal)
            } else {
                
                let attributes: [NSAttributedString.Key: Any] = [
                    .underlineStyle: NSUnderlineStyle.single.rawValue
                ]
                let attributeString = NSMutableAttributedString(
                    string: "????????????",
                    attributes: attributes
                )
                cell.linkButton.setAttributedTitle(attributeString, for: .normal)
            }
            
            return cell
        }
        
    }
    
}

// MARK: - GMSMapViewDelegate

extension CafeDetailVC: GMSMapViewDelegate {
    
    func openGoogleMapAlert() {
        let alert = UIAlertController(title: "????????? Google Maps", message: "??? Google Maps ???????????????????????????????????????", preferredStyle: .alert)
        let confirm = UIAlertAction(title: "??????", style: .default) { action in
            let lat = self.currentCafe.latitude
            let long = self.currentCafe.longitude
            if UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!) {
                UIApplication.shared.open(URL(string:"comgooglemaps://?center=\(lat),\(long)&zoom=17&views=traffic&q=\(lat),\(long)")!, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.open(URL(string: "http://maps.google.com/maps?q=loc:\(lat),\(long)&zoom=17&views=traffic&q=\(lat),\(long)")!, options: [:], completionHandler: nil)
            }
        }
        let cancel = UIAlertAction(title: "??????", style: .cancel, handler: nil)
        alert.addAction(confirm)
        alert.addAction(cancel)
        alert.preferredAction = confirm
        alert.view.tintColor = myColor.primaryColor
        present(alert, animated: true, completion: nil)
    }
    
    // Tap info window of marker to open Google Maps app or browser to see more information.
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        openGoogleMapAlert()
    }
    
    // Tap marker to open Google Maps app or browser to see more information.
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        openGoogleMapAlert()
        
        return true
    }
}
