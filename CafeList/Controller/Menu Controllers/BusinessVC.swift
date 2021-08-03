//
//  StudyWorkVC.swift
//  CafeList
//
//  Created by Judy Tsai on 2021/8/1.
//

import UIKit
import SideMenu

class BusinessVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private var cafeArray: [Cafe]!
    let myColor = Colors.shared
    
    @IBOutlet weak var tableView: UITableView!
    
    var searchController = UISearchController(searchResultsController: nil)
    var searchResults: [Cafe] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        filterCafes()
        setSearchController()
        setNavigationController()
        setTableViewBackground()
        
        self.tabBarItem = UITabBarItem(title: "探索", image: UIImage(systemName: "magnifyingglass"), selectedImage: nil)
    }
    
    func setSearchController() {
        self.navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "輸入地區 / 捷運站名搜尋咖啡廳..."
        searchController.searchBar.barTintColor = .white
        searchController.searchBar.backgroundImage = UIImage()
        searchController.searchBar.tintColor = myColor.primaryColor
    }
    
    func setNavigationController() {
        // Set to use the large title of the navigation bar
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // Change title color when user swipes down and title becomes small
        let textAttributes = [NSAttributedString.Key.foregroundColor: myColor.primaryColor]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        navigationController?.hidesBarsOnSwipe = false
        
        // Use Custom Font
        if let customFont = UIFont(name: "Ubuntu-Bold", size: 40.0) {
            navigationController?.navigationBar.largeTitleTextAttributes = [
                NSAttributedString.Key.foregroundColor:
                    myColor.primaryDarkColor,
                NSAttributedString.Key.font: customFont
            ]
        }
        
    }
    
    func setTableViewBackground() {
        // Light grey background & footer view
        self.tableView.backgroundView?.backgroundColor = myColor.lightGrey
        self.tableView.backgroundColor = myColor.lightGrey
        self.tableView.separatorStyle = .none

        // Set Top Padding = 10
        tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        
        let footerView = UIView()
        footerView.backgroundColor = myColor.lightGrey
        self.tableView.tableFooterView = footerView
    }
    
    @IBAction func didTapMenuBtn(_ sender: UIBarButtonItem) {
        
        if let tabVC = self.tabBarController as? CafeTabBarController {
            present(tabVC.sideMenu, animated: true, completion: nil)
        }
    }
    
    func filterCafes() {
        
        cafeArray = CafeManager.cafeList.filter {
            
            $0.wifi >= 4.0 &&
                $0.music >= 4.0 &&
                $0.socket != "no"
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "businessDetail" {
            if let cafeDetailVC = segue.destination as? CafeDetailVC,
               let row = tableView.indexPathForSelectedRow?.row {
                cafeDetailVC.currentCafe = (searchController.isActive) ? searchResults[row] :  cafeArray[row]
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searchController.isActive {
            return searchResults.count
        } else {
            return cafeArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "businessCell", for: indexPath) as! CafeListCell
        
        // 判斷是從搜尋結果或原本陣列取得咖啡廳
        let cafe = (searchController.isActive) ? searchResults[indexPath.row] : cafeArray[indexPath.row]
        
        cell.nameLabel.text = cafe.name
        cell.locationLabel.text = cafe.address
        
        // Configure socketLabel
        switch cafe.socket {
        
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
        switch cafe.limited_time {
        
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
        
        let label = cafe.mrt
        
        // MARK: - Kaohsiung - Red line
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
            
            // MARK: - Kaohsiung - Orange line
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
        
        // MARK: - Taipei - Red line
        else if label.contains("淡水") {
            cell.mrtLabel.text = "淡水"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtRed
        } else if label.contains("紅樹林") {
            cell.mrtLabel.text = "紅樹林"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtRed
        } else if label.contains("竹圍") {
            cell.mrtLabel.text = "竹圍"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtRed
        } else if label.contains("關渡") {
            cell.mrtLabel.text = "關渡"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtRed
        } else if label.contains("忠義") {
            cell.mrtLabel.text = "忠義"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtRed
        } else if label.contains("復興崗") {
            cell.mrtLabel.text = "復興崗"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtRed
        } else if label.contains("北投") {
            cell.mrtLabel.text = "北投"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtRed
        } else if label.contains("新北投") {
            cell.mrtLabel.text = "新北投"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtRed
        } else if label.contains("奇岩") {
            cell.mrtLabel.text = "奇岩"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtRed
        } else if label.contains("唭哩岸") {
            cell.mrtLabel.text = "唭哩岸"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtRed
        } else if label.contains("石牌") {
            cell.mrtLabel.text = "石牌"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtRed
        } else if label.contains("明德") {
            cell.mrtLabel.text = "明德"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtRed
        } else if label.contains("芝山") {
            cell.mrtLabel.text = "芝山"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtRed
        } else if label.contains("士林") {
            cell.mrtLabel.text = "士林"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtRed
        } else if label.contains("劍潭") {
            cell.mrtLabel.text = "劍潭"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtRed
        } else if label.contains("圓山") {
            cell.mrtLabel.text = "圓山"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtRed
        } else if label.contains("民權西路") {
            cell.mrtLabel.text = "民權西路"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtRed
        } else if label.contains("雙連") {
            cell.mrtLabel.text = "雙連"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtRed
        } else if label.contains("中山") {
            cell.mrtLabel.text = "中山"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtRed
        } else if label.contains("台北車站") {
            cell.mrtLabel.text = "台北車站"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtRed
        } else if label.contains("台大醫院") {
            cell.mrtLabel.text = "台大醫院"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtRed
        } else if label.contains("中正紀念堂") {
            cell.mrtLabel.text = "中正紀念堂"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtRed
        } else if label.contains("東門") {
            cell.mrtLabel.text = "東門"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtRed
        } else if label.contains("大安森林公園") {
            cell.mrtLabel.text = "大安森林公園"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtRed
        } else if label.contains("大安") {
            cell.mrtLabel.text = "大安"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtRed
        } else if label.contains("信義安和") {
            cell.mrtLabel.text = "信義安和"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtRed
        } else if label.contains("台北 101") {
            cell.mrtLabel.text = "台北 101"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtRed
        } else if label.contains("象山") {
            cell.mrtLabel.text = "象山"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtRed
        }
        // MARK: - Taipei - Green line
        else if label.contains("松山") {
            cell.mrtLabel.text = "松山"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtGreen
        } else if label.contains("南京三民") {
            cell.mrtLabel.text = "南京三民"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtGreen
        } else if label.contains("台北小巨蛋") {
            cell.mrtLabel.text = "台北小巨蛋"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtGreen
        } else if label.contains("南京復興") {
            cell.mrtLabel.text = "南京復興"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtGreen
        } else if label.contains("松江南京") {
            cell.mrtLabel.text = "松江南京"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtGreen
        } else if label.contains("北門") {
            cell.mrtLabel.text = "北門"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtGreen
        } else if label.contains("西門") {
            cell.mrtLabel.text = "西門"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtGreen
        } else if label.contains("小南門") {
            cell.mrtLabel.text = "小南門"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtGreen
        } else if label.contains("古亭") {
            cell.mrtLabel.text = "古亭"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtGreen
        } else if label.contains("台電大樓") {
            cell.mrtLabel.text = "台電大樓"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtGreen
        } else if label.contains("公館") {
            cell.mrtLabel.text = "公館"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtGreen
        } else if label.contains("萬隆") {
            cell.mrtLabel.text = "萬隆"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtGreen
        } else if label.contains("景美") {
            cell.mrtLabel.text = "景美"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtGreen
        } else if label.contains("大坪林") {
            cell.mrtLabel.text = "大坪林"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtGreen
        } else if label.contains("七張") {
            cell.mrtLabel.text = "七張"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtGreen
        } else if label.contains("新店區公所") {
            cell.mrtLabel.text = "新店區公所"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtGreen
        } else if label.contains("新店") {
            cell.mrtLabel.text = "新店"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtGreen
        }
        // MARK: - Taipei - Blue line
        else if label.contains("頂埔") {
            cell.mrtLabel.text = "頂埔"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtBlue
        } else if label.contains("永寧") {
            cell.mrtLabel.text = "永寧"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtBlue
        } else if label.contains("土城") {
            cell.mrtLabel.text = "土城"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtBlue
        } else if label.contains("海山") {
            cell.mrtLabel.text = "海山"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtBlue
        } else if label.contains("亞東醫院") {
            cell.mrtLabel.text = "亞東醫院"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtBlue
        } else if label.contains("府中") {
            cell.mrtLabel.text = "府中"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtBlue
        } else if label.contains("板橋") {
            cell.mrtLabel.text = "板橋"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtBlue
        } else if label.contains("新埔") {
            cell.mrtLabel.text = "新埔"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtBlue
        } else if label.contains("江子翠") {
            cell.mrtLabel.text = "江子翠"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtBlue
        } else if label.contains("龍山寺") {
            cell.mrtLabel.text = "龍山寺"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtBlue
        } else if label.contains("善導寺") {
            cell.mrtLabel.text = "善導寺"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtBlue
        } else if label.contains("忠孝新生") {
            cell.mrtLabel.text = "忠孝新生"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtBlue
        } else if label.contains("忠孝復興") {
            cell.mrtLabel.text = "忠孝復興"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtBlue
        } else if label.contains("忠孝敦化") {
            cell.mrtLabel.text = "忠孝敦化"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtBlue
        } else if label.contains("國父紀念館") {
            cell.mrtLabel.text = "國父紀念館"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtBlue
        } else if label.contains("市政府") {
            cell.mrtLabel.text = "市政府"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtBlue
        } else if label.contains("永春") {
            cell.mrtLabel.text = "永春"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtBlue
        } else if label.contains("後山埤") {
            cell.mrtLabel.text = "後山埤"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtBlue
        } else if label.contains("昆陽") {
            cell.mrtLabel.text = "昆陽"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtBlue
        } else if label.contains("南港") {
            cell.mrtLabel.text = "南港"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtBlue
        } else if label.contains("南港展覽館") {
            cell.mrtLabel.text = "南港展覽館"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtBlue
        }
        // MARK: - Taipei - Orange line
        else if label.contains("迴龍") {
            cell.mrtLabel.text = "迴龍"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtOrange
        } else if label.contains("丹鳳") {
            cell.mrtLabel.text = "丹鳳"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtOrange
        } else if label.contains("輔大") {
            cell.mrtLabel.text = "輔大"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtOrange
        } else if label.contains("新莊") {
            cell.mrtLabel.text = "新莊"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtOrange
        } else if label.contains("頭前庄") {
            cell.mrtLabel.text = "頭前庄"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtOrange
        } else if label.contains("先嗇宮") {
            cell.mrtLabel.text = "先嗇宮"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtOrange
        } else if label.contains("三重") {
            cell.mrtLabel.text = "三重"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtOrange
        } else if label.contains("菜寮") {
            cell.mrtLabel.text = "菜寮"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtOrange
        } else if label.contains("台北橋") {
            cell.mrtLabel.text = "台北橋"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtOrange
        } else if label.contains("蘆洲") {
            cell.mrtLabel.text = "蘆洲"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtOrange
        } else if label.contains("三民高中") {
            cell.mrtLabel.text = "三民高中"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtOrange
        } else if label.contains("徐匯中學") {
            cell.mrtLabel.text = "徐匯中學"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtOrange
        } else if label.contains("三和國中") {
            cell.mrtLabel.text = "三和國中"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtOrange
        } else if label.contains("三重國小") {
            cell.mrtLabel.text = "三重國小"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtOrange
        } else if label.contains("大橋頭") {
            cell.mrtLabel.text = "大橋頭"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtOrange
        } else if label.contains("中山國小") {
            cell.mrtLabel.text = "中山國小"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtOrange
        } else if label.contains("行天宮") {
            cell.mrtLabel.text = "行天宮"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtOrange
        } else if label.contains("頂溪") {
            cell.mrtLabel.text = "頂溪"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtOrange
        } else if label.contains("永安市場") {
            cell.mrtLabel.text = "永安市場"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtOrange
        } else if label.contains("景安") {
            cell.mrtLabel.text = "景安"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtOrange
        } else if label.contains("南勢角") {
            cell.mrtLabel.text = "南勢角"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtOrange
        }
        // MARK: - Taipei - Brown line
        else if label.contains("南港軟體園區") {
            cell.mrtLabel.text = "南港軟體園區"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtBrown
        } else if label.contains("東湖") {
            cell.mrtLabel.text = "東湖"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtBrown
        } else if label.contains("葫洲") {
            cell.mrtLabel.text = "葫洲"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtBrown
        } else if label.contains("大湖公園") {
            cell.mrtLabel.text = "大湖公園"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtBrown
        } else if label.contains("內湖") {
            cell.mrtLabel.text = "內湖"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtBrown
        } else if label.contains("文德") {
            cell.mrtLabel.text = "文德"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtBrown
        } else if label.contains("港墘") {
            cell.mrtLabel.text = "港墘"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtBrown
        } else if label.contains("西湖") {
            cell.mrtLabel.text = "西湖"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtBrown
        } else if label.contains("劍南路") {
            cell.mrtLabel.text = "劍南路"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtBrown
        } else if label.contains("大直") {
            cell.mrtLabel.text = "大直"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtBrown
        } else if label.contains("松山機場") {
            cell.mrtLabel.text = "松山機場"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtBrown
        } else if label.contains("中山國中") {
            cell.mrtLabel.text = "中山國中"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtBrown
        } else if label.contains("科技大樓") {
            cell.mrtLabel.text = "科技大樓"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtBrown
        } else if label.contains("六張犁") {
            cell.mrtLabel.text = "六張犁"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtBrown
        } else if label.contains("麟光") {
            cell.mrtLabel.text = "麟光"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtBrown
        } else if label.contains("辛亥") {
            cell.mrtLabel.text = "辛亥"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtBrown
        } else if label.contains("萬芳醫院") {
            cell.mrtLabel.text = "萬芳醫院"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtBrown
        } else if label.contains("萬芳社區") {
            cell.mrtLabel.text = "萬芳社區"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtBrown
        } else if label.contains("木柵") {
            cell.mrtLabel.text = "木柵"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtBrown
        } else if label.contains("動物園") {
            cell.mrtLabel.text = "動物園"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtBrown
        }
        // MARK: - Taipei - Yellow line
        else if label.contains("十四張") {
            cell.mrtLabel.text = "十四張"
            cell.mrtLabel.textColor = .black
            cell.mrtLabel.backgroundColor = myColor.mrtYellow
        } else if label.contains("秀朗橋") {
            cell.mrtLabel.text = "秀朗橋"
            cell.mrtLabel.textColor = .black
            cell.mrtLabel.backgroundColor = myColor.mrtYellow
        } else if label.contains("景平") {
            cell.mrtLabel.text = "景平"
            cell.mrtLabel.textColor = .black
            cell.mrtLabel.backgroundColor = myColor.mrtYellow
        } else if label.contains("中和") {
            cell.mrtLabel.text = "中和"
            cell.mrtLabel.textColor = .black
            cell.mrtLabel.backgroundColor = myColor.mrtYellow
        } else if label.contains("橋和") {
            cell.mrtLabel.text = "橋和"
            cell.mrtLabel.textColor = .black
            cell.mrtLabel.backgroundColor = myColor.mrtYellow
        } else if label.contains("中原") {
            cell.mrtLabel.text = "中原"
            cell.mrtLabel.textColor = .black
            cell.mrtLabel.backgroundColor = myColor.mrtYellow
        } else if label.contains("板新") {
            cell.mrtLabel.text = "板新"
            cell.mrtLabel.textColor = .black
            cell.mrtLabel.backgroundColor = myColor.mrtYellow
        } else if label.contains("新埔民生") {
            cell.mrtLabel.text = "新埔民生"
            cell.mrtLabel.textColor = .black
            cell.mrtLabel.backgroundColor = myColor.mrtYellow
        } else if label.contains("幸福") {
            cell.mrtLabel.text = "幸福"
            cell.mrtLabel.textColor = .black
            cell.mrtLabel.backgroundColor = myColor.mrtYellow
        } else if label.contains("新北產業園區") {
            cell.mrtLabel.text = "新北產業園區"
            cell.mrtLabel.textColor = .black
            cell.mrtLabel.backgroundColor = myColor.mrtYellow
        }
        
        // MARK: - No MRT information
        else {
            cell.mrtLabel.text = ""
            cell.mrtLabel.backgroundColor = nil
        }
        
        
        return cell
    }
    
}

// MARK: - UISearchController methods

extension BusinessVC: UISearchResultsUpdating {
    
    func filterContent(for searchText: String) {
        if searchController.isActive {
            searchResults = cafeArray.filter { (cafe) -> Bool in
                let name = cafe.name
                let address = cafe.address
                let mrt = cafe.mrt
                let isMatch = name.localizedCaseInsensitiveContains(searchText) || address.localizedCaseInsensitiveContains(searchText) || mrt.localizedCaseInsensitiveContains(searchText)
                return isMatch
            }
        } else {
            searchResults = []
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            filterContent(for: searchText)
            tableView.reloadData()
        }
    }
}
