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
    let myColor = Colors.shared
    
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
                    myColor.primaryColor,
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
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CafeListCell.self), for: indexPath) as! CafeListCell

        cell.nameLabel.text = CafeManager.cafeList[indexPath.row].name
        cell.locationLabel.text = CafeManager.cafeList[indexPath.row].address
        
        // Configure socketLabel
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
        
        // Configure limit_timeLabel
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
        
        // Configure mrtLabel
        cell.mrtLabel.clipsToBounds = true
        cell.mrtLabel.layer.cornerRadius = 5
        
        let label = CafeManager.cafeList[indexPath.row].mrt
        
        // MARK: - Kaohsiung
        // Red line
        if label.contains("小港") {
            cell.mrtLabel.text = "小港"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtRed
        } else if label.contains("高雄國際機場") {
            cell.mrtLabel.text = "小港機場"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtRed
        } else if label.contains("草衙") {
            cell.mrtLabel.text = "草衙"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtRed
        } else if label.contains("前鎮高中") {
            cell.mrtLabel.text = "前鎮高中"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtRed
        } else if label.contains("凱旋") {
            cell.mrtLabel.text = "凱旋"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtRed
        } else if label.contains("獅甲") {
            cell.mrtLabel.text = "獅甲"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtRed
        } else if label.contains("三多商圈") {
            cell.mrtLabel.text = "三多商圈"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtRed
        } else if label.contains("中央公園") {
            cell.mrtLabel.text = "中央公園"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtRed
        } else if label.contains("美麗島") {
            cell.mrtLabel.text = "美麗島"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtRed
        } else if label.contains("高雄車站") {
            cell.mrtLabel.text = "高雄車站"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtRed
        } else if label.contains("後驛") {
            cell.mrtLabel.text = "後驛"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtRed
        } else if label.contains("凹子底") {
            cell.mrtLabel.text = "凹子底"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtRed
        } else if label.contains("巨蛋") {
            cell.mrtLabel.text = "巨蛋"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtRed
        } else if label.contains("生態園區") {
            cell.mrtLabel.text = "生態園區"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtRed
        } else if label.contains("左營") {
            cell.mrtLabel.text = "左營"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtRed
        } else if label.contains("世運") {
            cell.mrtLabel.text = "世運"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtRed
        } else if label.contains("油廠國小") {
            cell.mrtLabel.text = "油廠國小"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtRed
        } else if label.contains("楠梓加工區") {
            cell.mrtLabel.text = "楠梓加工區"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtRed
        } else if label.contains("後勁") {
            cell.mrtLabel.text = "後勁"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtRed
        } else if label.contains("都會公園") {
            cell.mrtLabel.text = "都會公園"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtRed
        } else if label.contains("青埔") {
            cell.mrtLabel.text = "青埔"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtRed
        } else if label.contains("橋頭糖廠") {
            cell.mrtLabel.text = "橋頭糖廠"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtRed
        } else if label.contains("橋頭火車站") {
            cell.mrtLabel.text = "橋頭火車站"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtRed
        } else if label.contains("南岡山") {
            cell.mrtLabel.text = "南岡山"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtRed
        } else if label.contains("岡山") {
            cell.mrtLabel.text = "岡山"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtRed
        
        // Orange line
        } else if label.contains("西子灣") {
            cell.mrtLabel.text = "西子灣"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtOrange
        } else if label.contains("鹽埕埔") {
            cell.mrtLabel.text = "鹽埕埔"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtOrange
        } else if label.contains("市議會") {
            cell.mrtLabel.text = "市議會"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtOrange
        } else if label.contains("美麗島") {
            cell.mrtLabel.text = "美麗島"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtOrange
        } else if label.contains("信義國小") {
            cell.mrtLabel.text = "信義國小"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtOrange
        } else if label.contains("文化中心") {
            cell.mrtLabel.text = "文化中心"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtOrange
        } else if label.contains("五塊厝") {
            cell.mrtLabel.text = "五塊厝"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtOrange
        } else if label.contains("技擊館") {
            cell.mrtLabel.text = "技擊館"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtOrange
        } else if label.contains("衛武營") {
            cell.mrtLabel.text = "衛武營"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtOrange
        } else if label.contains("鳳山西站") {
            cell.mrtLabel.text = "鳳山西站"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtOrange
        } else if label.contains("鳳山") {
            cell.mrtLabel.text = "鳳山"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtOrange
        } else if label.contains("大東") {
            cell.mrtLabel.text = "大東"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtOrange
        } else if label.contains("鳳山國中") {
            cell.mrtLabel.text = "鳳山國中"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtOrange
        } else if label.contains("大寮") {
            cell.mrtLabel.text = "大寮"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtOrange
        }
        else {
            cell.mrtLabel.text = ""
            cell.mrtLabel.backgroundColor = nil
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
