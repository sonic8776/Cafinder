//
//  CafeListViewController.swift
//  CafeList
//
//  Created by Judy Tsai on 2021/6/17.
//

import UIKit
import CoreLocation

class CafeListVC: UITableViewController {

    //var cafeList = [Cafe]()
    let cafeManager = CafeManager.shared
    let locationManager = CLLocationManager()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.hidesBarsOnSwipe = true
//        tableView.backgroundColor = Colors.shared.primaryLightColor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getCafeList()
        //cafeManager.getCafeList()
        tableView.reloadData()
        locationManager.requestWhenInUseAuthorization() // 詢問時機待優化
        
        
        tableView.cellLayoutMarginsFollowReadableWidth = true
        
        // Set to use the large title of the navigation bar
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // Configure the navigation bar
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.hidesBarsOnSwipe = true
        
        // Use Cutom Font
        if let customFont = UIFont(name: "RubikRoman-Medium", size: 40.0) {
            navigationController?.navigationBar.largeTitleTextAttributes = [
                NSAttributedString.Key.foregroundColor:
                    Colors.shared.primaryColor,
                NSAttributedString.Key.font: customFont
            ]
        }
        
    }
    
    func getCafeList(){
        
        let urlStr = "https://cafenomad.tw/api/v1.2/cafes/kaohsiung".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let url = URL(string: urlStr!)
        let task = URLSession.shared.dataTask(with: url!) {(data, response, error) in
            
            if let error = error {
                assertionFailure("Error fetching JSON data: \(error)")
            }
            
            if let data = data,
               let resultArray = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [[String: Any]] {
                DispatchQueue.main.async {
                    for coffeeshop in resultArray{
                        if let cafe = Cafe(json: coffeeshop){
                            CafeManager.cafeList.append(cafe)
                        }
                    }
                    self.tableView.reloadData()
                }
            }
        }
        task.resume()
        locationManager.requestWhenInUseAuthorization() // 詢問時機待優化
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return CafeManager.cafeList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CafeListCell_V2.self), for: indexPath) as! CafeListCell_V2

        cell.nameLabel.text = CafeManager.cafeList[indexPath.row].name
        cell.locationLabel.text = CafeManager.cafeList[indexPath.row].address
        
        switch CafeManager.cafeList[indexPath.row].socket {
        
        case "yes":
            cell.socketLabel.text = "# 有很多插座"
            
        case "maybe":
            cell.socketLabel.text = "# 不太多插座，要看座位"
        
        case "no":
            cell.socketLabel.text = "# 沒有 / 很少插座"
        
        default:
            cell.socketLabel.text = "未提供插座資訊"
        }
        
        switch CafeManager.cafeList[indexPath.row].limited_time {
        
        case "yes":
            cell.limit_timeLabel.text = "# 一律有限時"
            
        case "maybe":
            cell.limit_timeLabel.text = "# 看情況，假日或客滿限時"
        
        case "no":
            cell.limit_timeLabel.text = "# 一律不限時"
        
        default:
            cell.limit_timeLabel.text = "未提供限時資訊"
        }
    
        return cell
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let cafeDetailVC = segue.destination as? CafeDetailVC,
           let row = tableView.indexPathForSelectedRow?.row {
            cafeDetailVC.currentCafe = CafeManager.cafeList[row]
        }
        
    }
    

}
