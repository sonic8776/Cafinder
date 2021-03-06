//
//  CafeListViewController.swift
//  CafeList
//
//  Created by Judy Tsai on 2021/6/17.
//

import UIKit
import CoreLocation
import UserNotifications
import SideMenu

class CafeListVC: UITableViewController {
    
    @IBOutlet var emptyCafeView: UIView!
    
    private var studyWorkController : UIViewController!
    private var gatherController : UIViewController!
    private var businessController : UIViewController!
    
    private var sideMenu: SideMenuNavigationController?
    let locationManager = CLLocationManager()
    let myColor = Colors.shared
    
    var searchController = UISearchController(searchResultsController: nil)
    var searchResults: [Cafe] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.hidesBarsOnSwipe = true
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if UserDefaults.standard.bool(forKey: "hasViewedWalkthrough") {
            return
        }
        
        let storyboard = UIStoryboard(name: "Onboarding", bundle: nil)
        if let walkthroughViewController = storyboard.instantiateViewController(withIdentifier: "WalkthroughViewController") as? WalkthroughVC {
            walkthroughViewController.modalPresentationStyle = .fullScreen
            present(walkthroughViewController, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Prepare for empty view
        tableView.backgroundView = emptyCafeView
        tableView.backgroundView?.isHidden = true
        
        // Remove seperators
        tableView.separatorStyle = .none
        
        // Set Top Padding = 10
        //tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        
        getCafeList()
        tableView.reloadData()
        
        setSearchController()
        setNavigationController()
        
        setSideMenu()
    }

    func setSearchController() {
        self.navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "???????????? / ???????????????????????????..."
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
        
        navigationController?.hidesBarsOnSwipe = true
        
        // Use Custom Font
        if let customFont = UIFont(name: "Ubuntu-Bold", size: 40.0) {
            navigationController?.navigationBar.largeTitleTextAttributes = [
                NSAttributedString.Key.foregroundColor:
                    myColor.primaryDarkColor,
                NSAttributedString.Key.font: customFont
            ]
        }
    }
    
    func setSideMenu() {
        // Prepare for menu
        let menu = MenuTableVC(with: SideMenuItem.allCases)

        sideMenu = SideMenuNavigationController(rootViewController: menu)
        sideMenu?.leftSide = true
        
        sideMenu?.presentationStyle = .viewSlideOut
        SideMenuManager.default.leftMenuNavigationController = sideMenu
        //SideMenuManager.default.addPanGestureToPresent(toView: view) -> will freeze the table!
        
        if let tabVC = self.tabBarController as? CafeTabBarController {
            tabVC.cafeListVC = self.navigationController
            tabVC.sideMenu = sideMenu
        }
    }
    
    func getCafeList(){
        
        let urlStr = "https://cafenomad.tw/api/v1.2/cafes".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
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
                    //CafeManager.cafeList = CafeManager.cafeList.sorted() { $0.latitude > $1.latitude }
 
                    self.tableView.reloadData()
                    self.prepareNotification()
                }
            }
        }
        task.resume()
    }
    
    func createCalendarNotification() {
        // Notify user to use app every Thursday 20:00
        
        // Create user notification
        let content = UNMutableNotificationContent()
        content.title = "??????????????????????????????????????????"
        content.body = "???????????????????????????????????????????????????????????????"
        content.sound = UNNotificationSound.default
        
        // Configure the recurring date.
        var dateComponents = DateComponents()
        dateComponents.calendar = Calendar.current

//        print("timezone: \(Calendar.current.timeZone)") // Asia/Taipei
//        print("first weekday: \(Calendar.current.firstWeekday)") // Monday
        
        dateComponents.weekday = 5  // Thursday
        dateComponents.hour = 20    // 20:00
//        dateComponents.weekday = 6  // for test
//        dateComponents.hour = 9    // for test
//        dateComponents.minute = 45 // for test
           
        // Create the trigger as a repeating event.
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        //let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
        let request = UNNotificationRequest(identifier: "calendar", content: content, trigger: trigger)
        
        // Schedule notification
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error adding request to UNUserNotificationCenter: \(error)")
            }
        }
        print("Successfully added Calendar notification.")
    }

    @IBAction func didTapMenuBtn(_ sender: UIBarButtonItem) {
        
        if let tabVC = self.tabBarController as? CafeTabBarController{
            present(tabVC.sideMenu, animated: true, completion: nil)
        }
    }
    
    func prepareNotification() {
        if CafeManager.cafeList.count <= 0 {
            return
        }
        createCalendarNotification()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        if CafeManager.cafeList.count > 0 {
            tableView.backgroundView?.isHidden = true
        } else {
            tableView.backgroundView?.isHidden = false
        }
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive {
            return searchResults.count
        } else {
            return CafeManager.cafeList.count
        }
    }
    
//    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let view = UIView()
//        view.backgroundColor = myColor.lightGrey
//        return view
//    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CafeListCell.self), for: indexPath) as! CafeListCell
        
        // ??????????????????????????????????????????????????????
        let cafe = (searchController.isActive) ? searchResults[indexPath.row] : CafeManager.cafeList[indexPath.row]
        
        // Configure name and location labels
        cell.nameLabel.text = cafe.name
        cell.locationLabel.text = cafe.address
        
        // Configure socketLabel
        switch cafe.socket {
        
        case "yes":
            cell.socketLabel.text = "# ???????????????"
            
        case "maybe":
            cell.socketLabel.text = "# ??????????????????????????????"
            
        case "no":
            cell.socketLabel.text = "# ?????? / ????????????"
            
        default:
            cell.socketLabel.text = "?????????????????????"
        }
        
        // Configure limit_timeLabel
        switch cafe.limited_time {
        
        case "yes":
            cell.limit_timeLabel.text = "# ???????????????"
            
        case "maybe":
            cell.limit_timeLabel.text = "# ?????????????????????????????????"
            
        case "no":
            cell.limit_timeLabel.text = "# ???????????????"
            
        default:
            cell.limit_timeLabel.text = "?????????????????????"
        }
        
        // Configure mrtLabel
        cell.mrtLabel.clipsToBounds = true
        cell.mrtLabel.layer.cornerRadius = 5
        
        let label = cafe.mrt
        
        // MARK: - Kaohsiung - Red line
        if label.contains("??????") {
            cell.mrtLabel.text = "??????"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtRed
        } else if label.contains("??????????????????") {
            cell.mrtLabel.text = "????????????"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtRed
        } else if label.contains("??????") {
            cell.mrtLabel.text = "??????"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtRed
        } else if label.contains("????????????") {
            cell.mrtLabel.text = "????????????"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtRed
        } else if label.contains("??????") {
            cell.mrtLabel.text = "??????"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtRed
        } else if label.contains("??????") {
            cell.mrtLabel.text = "??????"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtRed
        } else if label.contains("????????????") {
            cell.mrtLabel.text = "????????????"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtRed
        } else if label.contains("????????????") {
            cell.mrtLabel.text = "????????????"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtRed
        } else if label.contains("?????????") {
            cell.mrtLabel.text = "?????????"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtRed
        } else if label.contains("????????????") {
            cell.mrtLabel.text = "????????????"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtRed
        } else if label.contains("??????") {
            cell.mrtLabel.text = "??????"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtRed
        } else if label.contains("?????????") {
            cell.mrtLabel.text = "?????????"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtRed
        } else if label.contains("??????") {
            cell.mrtLabel.text = "??????"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtRed
        } else if label.contains("????????????") {
            cell.mrtLabel.text = "????????????"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtRed
        } else if label.contains("??????") {
            cell.mrtLabel.text = "??????"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtRed
        } else if label.contains("??????") {
            cell.mrtLabel.text = "??????"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtRed
        } else if label.contains("????????????") {
            cell.mrtLabel.text = "????????????"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtRed
        } else if label.contains("???????????????") {
            cell.mrtLabel.text = "???????????????"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtRed
        } else if label.contains("??????") {
            cell.mrtLabel.text = "??????"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtRed
        } else if label.contains("????????????") {
            cell.mrtLabel.text = "????????????"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtRed
        } else if label.contains("??????") {
            cell.mrtLabel.text = "??????"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtRed
        } else if label.contains("????????????") {
            cell.mrtLabel.text = "????????????"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtRed
        } else if label.contains("???????????????") {
            cell.mrtLabel.text = "???????????????"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtRed
        } else if label.contains("?????????") {
            cell.mrtLabel.text = "?????????"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtRed
        } else if label.contains("??????") {
            cell.mrtLabel.text = "??????"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtRed
            
            // MARK: - Kaohsiung - Orange line
        } else if label.contains("?????????") {
            cell.mrtLabel.text = "?????????"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtOrange
        } else if label.contains("?????????") {
            cell.mrtLabel.text = "?????????"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtOrange
        } else if label.contains("?????????") {
            cell.mrtLabel.text = "?????????"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtOrange
        } else if label.contains("?????????") {
            cell.mrtLabel.text = "?????????"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtOrange
        } else if label.contains("????????????") {
            cell.mrtLabel.text = "????????????"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtOrange
        } else if label.contains("????????????") {
            cell.mrtLabel.text = "????????????"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtOrange
        } else if label.contains("?????????") {
            cell.mrtLabel.text = "?????????"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtOrange
        } else if label.contains("?????????") {
            cell.mrtLabel.text = "?????????"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtOrange
        } else if label.contains("?????????") {
            cell.mrtLabel.text = "?????????"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtOrange
        } else if label.contains("????????????") {
            cell.mrtLabel.text = "????????????"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtOrange
        } else if label.contains("??????") {
            cell.mrtLabel.text = "??????"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtOrange
        } else if label.contains("??????") {
            cell.mrtLabel.text = "??????"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtOrange
        } else if label.contains("????????????") {
            cell.mrtLabel.text = "????????????"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtOrange
        } else if label.contains("??????") {
            cell.mrtLabel.text = "??????"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtOrange
        }
        
        // MARK: - Taipei - Red line
        else if label.contains("??????") {
            cell.mrtLabel.text = "??????"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtRed
        } else if label.contains("?????????") {
            cell.mrtLabel.text = "?????????"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtRed
        } else if label.contains("??????") {
            cell.mrtLabel.text = "??????"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtRed
        } else if label.contains("??????") {
            cell.mrtLabel.text = "??????"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtRed
        } else if label.contains("??????") {
            cell.mrtLabel.text = "??????"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtRed
        } else if label.contains("?????????") {
            cell.mrtLabel.text = "?????????"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtRed
        } else if label.contains("??????") {
            cell.mrtLabel.text = "??????"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtRed
        } else if label.contains("?????????") {
            cell.mrtLabel.text = "?????????"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtRed
        } else if label.contains("??????") {
            cell.mrtLabel.text = "??????"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtRed
        } else if label.contains("?????????") {
            cell.mrtLabel.text = "?????????"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtRed
        } else if label.contains("??????") {
            cell.mrtLabel.text = "??????"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtRed
        } else if label.contains("??????") {
            cell.mrtLabel.text = "??????"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtRed
        } else if label.contains("??????") {
            cell.mrtLabel.text = "??????"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtRed
        } else if label.contains("??????") {
            cell.mrtLabel.text = "??????"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtRed
        } else if label.contains("??????") {
            cell.mrtLabel.text = "??????"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtRed
        } else if label.contains("??????") {
            cell.mrtLabel.text = "??????"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtRed
        } else if label.contains("????????????") {
            cell.mrtLabel.text = "????????????"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtRed
        } else if label.contains("??????") {
            cell.mrtLabel.text = "??????"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtRed
        } else if label.contains("??????") {
            cell.mrtLabel.text = "??????"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtRed
        } else if label.contains("????????????") {
            cell.mrtLabel.text = "????????????"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtRed
        } else if label.contains("????????????") {
            cell.mrtLabel.text = "????????????"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtRed
        } else if label.contains("???????????????") {
            cell.mrtLabel.text = "???????????????"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtRed
        } else if label.contains("??????") {
            cell.mrtLabel.text = "??????"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtRed
        } else if label.contains("??????????????????") {
            cell.mrtLabel.text = "??????????????????"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtRed
        } else if label.contains("??????") {
            cell.mrtLabel.text = "??????"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtRed
        } else if label.contains("????????????") {
            cell.mrtLabel.text = "????????????"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtRed
        } else if label.contains("?????? 101") {
            cell.mrtLabel.text = "?????? 101"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtRed
        } else if label.contains("??????") {
            cell.mrtLabel.text = "??????"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtRed
        }
        // MARK: - Taipei - Green line
        else if label.contains("??????") {
            cell.mrtLabel.text = "??????"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtGreen
        } else if label.contains("????????????") {
            cell.mrtLabel.text = "????????????"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtGreen
        } else if label.contains("???????????????") {
            cell.mrtLabel.text = "???????????????"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtGreen
        } else if label.contains("????????????") {
            cell.mrtLabel.text = "????????????"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtGreen
        } else if label.contains("????????????") {
            cell.mrtLabel.text = "????????????"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtGreen
        } else if label.contains("??????") {
            cell.mrtLabel.text = "??????"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtGreen
        } else if label.contains("??????") {
            cell.mrtLabel.text = "??????"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtGreen
        } else if label.contains("?????????") {
            cell.mrtLabel.text = "?????????"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtGreen
        } else if label.contains("??????") {
            cell.mrtLabel.text = "??????"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtGreen
        } else if label.contains("????????????") {
            cell.mrtLabel.text = "????????????"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtGreen
        } else if label.contains("??????") {
            cell.mrtLabel.text = "??????"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtGreen
        } else if label.contains("??????") {
            cell.mrtLabel.text = "??????"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtGreen
        } else if label.contains("??????") {
            cell.mrtLabel.text = "??????"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtGreen
        } else if label.contains("?????????") {
            cell.mrtLabel.text = "?????????"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtGreen
        } else if label.contains("??????") {
            cell.mrtLabel.text = "??????"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtGreen
        } else if label.contains("???????????????") {
            cell.mrtLabel.text = "???????????????"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtGreen
        } else if label.contains("??????") {
            cell.mrtLabel.text = "??????"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtGreen
        }
        // MARK: - Taipei - Blue line
        else if label.contains("??????") {
            cell.mrtLabel.text = "??????"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtBlue
        } else if label.contains("??????") {
            cell.mrtLabel.text = "??????"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtBlue
        } else if label.contains("??????") {
            cell.mrtLabel.text = "??????"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtBlue
        } else if label.contains("??????") {
            cell.mrtLabel.text = "??????"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtBlue
        } else if label.contains("????????????") {
            cell.mrtLabel.text = "????????????"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtBlue
        } else if label.contains("??????") {
            cell.mrtLabel.text = "??????"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtBlue
        } else if label.contains("??????") {
            cell.mrtLabel.text = "??????"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtBlue
        } else if label.contains("??????") {
            cell.mrtLabel.text = "??????"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtBlue
        } else if label.contains("?????????") {
            cell.mrtLabel.text = "?????????"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtBlue
        } else if label.contains("?????????") {
            cell.mrtLabel.text = "?????????"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtBlue
        } else if label.contains("?????????") {
            cell.mrtLabel.text = "?????????"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtBlue
        } else if label.contains("????????????") {
            cell.mrtLabel.text = "????????????"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtBlue
        } else if label.contains("????????????") {
            cell.mrtLabel.text = "????????????"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtBlue
        } else if label.contains("????????????") {
            cell.mrtLabel.text = "????????????"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtBlue
        } else if label.contains("???????????????") {
            cell.mrtLabel.text = "???????????????"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtBlue
        } else if label.contains("?????????") {
            cell.mrtLabel.text = "?????????"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtBlue
        } else if label.contains("??????") {
            cell.mrtLabel.text = "??????"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtBlue
        } else if label.contains("?????????") {
            cell.mrtLabel.text = "?????????"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtBlue
        } else if label.contains("??????") {
            cell.mrtLabel.text = "??????"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtBlue
        } else if label.contains("??????") {
            cell.mrtLabel.text = "??????"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtBlue
        } else if label.contains("???????????????") {
            cell.mrtLabel.text = "???????????????"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtBlue
        }
        // MARK: - Taipei - Orange line
        else if label.contains("??????") {
            cell.mrtLabel.text = "??????"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtOrange
        } else if label.contains("??????") {
            cell.mrtLabel.text = "??????"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtOrange
        } else if label.contains("??????") {
            cell.mrtLabel.text = "??????"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtOrange
        } else if label.contains("??????") {
            cell.mrtLabel.text = "??????"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtOrange
        } else if label.contains("?????????") {
            cell.mrtLabel.text = "?????????"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtOrange
        } else if label.contains("?????????") {
            cell.mrtLabel.text = "?????????"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtOrange
        } else if label.contains("??????") {
            cell.mrtLabel.text = "??????"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtOrange
        } else if label.contains("??????") {
            cell.mrtLabel.text = "??????"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtOrange
        } else if label.contains("?????????") {
            cell.mrtLabel.text = "?????????"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtOrange
        } else if label.contains("??????") {
            cell.mrtLabel.text = "??????"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtOrange
        } else if label.contains("????????????") {
            cell.mrtLabel.text = "????????????"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtOrange
        } else if label.contains("????????????") {
            cell.mrtLabel.text = "????????????"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtOrange
        } else if label.contains("????????????") {
            cell.mrtLabel.text = "????????????"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtOrange
        } else if label.contains("????????????") {
            cell.mrtLabel.text = "????????????"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtOrange
        } else if label.contains("?????????") {
            cell.mrtLabel.text = "?????????"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtOrange
        } else if label.contains("????????????") {
            cell.mrtLabel.text = "????????????"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtOrange
        } else if label.contains("?????????") {
            cell.mrtLabel.text = "?????????"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtOrange
        } else if label.contains("??????") {
            cell.mrtLabel.text = "??????"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtOrange
        } else if label.contains("????????????") {
            cell.mrtLabel.text = "????????????"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtOrange
        } else if label.contains("??????") {
            cell.mrtLabel.text = "??????"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtOrange
        } else if label.contains("?????????") {
            cell.mrtLabel.text = "?????????"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtOrange
        }
        // MARK: - Taipei - Brown line
        else if label.contains("??????????????????") {
            cell.mrtLabel.text = "??????????????????"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtBrown
        } else if label.contains("??????") {
            cell.mrtLabel.text = "??????"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtBrown
        } else if label.contains("??????") {
            cell.mrtLabel.text = "??????"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtBrown
        } else if label.contains("????????????") {
            cell.mrtLabel.text = "????????????"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtBrown
        } else if label.contains("??????") {
            cell.mrtLabel.text = "??????"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtBrown
        } else if label.contains("??????") {
            cell.mrtLabel.text = "??????"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtBrown
        } else if label.contains("??????") {
            cell.mrtLabel.text = "??????"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtBrown
        } else if label.contains("??????") {
            cell.mrtLabel.text = "??????"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtBrown
        } else if label.contains("?????????") {
            cell.mrtLabel.text = "?????????"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtBrown
        } else if label.contains("??????") {
            cell.mrtLabel.text = "??????"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtBrown
        } else if label.contains("????????????") {
            cell.mrtLabel.text = "????????????"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtBrown
        } else if label.contains("????????????") {
            cell.mrtLabel.text = "????????????"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtBrown
        } else if label.contains("????????????") {
            cell.mrtLabel.text = "????????????"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtBrown
        } else if label.contains("?????????") {
            cell.mrtLabel.text = "?????????"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtBrown
        } else if label.contains("??????") {
            cell.mrtLabel.text = "??????"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtBrown
        } else if label.contains("??????") {
            cell.mrtLabel.text = "??????"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtBrown
        } else if label.contains("????????????") {
            cell.mrtLabel.text = "????????????"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtBrown
        } else if label.contains("????????????") {
            cell.mrtLabel.text = "????????????"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtBrown
        } else if label.contains("??????") {
            cell.mrtLabel.text = "??????"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtBrown
        } else if label.contains("?????????") {
            cell.mrtLabel.text = "?????????"
            cell.mrtLabel.textColor = .white
            cell.mrtLabel.backgroundColor = myColor.mrtBrown
        }
        // MARK: - Taipei - Yellow line
        else if label.contains("?????????") {
            cell.mrtLabel.text = "?????????"
            cell.mrtLabel.textColor = .black
            cell.mrtLabel.backgroundColor = myColor.mrtYellow
        } else if label.contains("?????????") {
            cell.mrtLabel.text = "?????????"
            cell.mrtLabel.textColor = .black
            cell.mrtLabel.backgroundColor = myColor.mrtYellow
        } else if label.contains("??????") {
            cell.mrtLabel.text = "??????"
            cell.mrtLabel.textColor = .black
            cell.mrtLabel.backgroundColor = myColor.mrtYellow
        } else if label.contains("??????") {
            cell.mrtLabel.text = "??????"
            cell.mrtLabel.textColor = .black
            cell.mrtLabel.backgroundColor = myColor.mrtYellow
        } else if label.contains("??????") {
            cell.mrtLabel.text = "??????"
            cell.mrtLabel.textColor = .black
            cell.mrtLabel.backgroundColor = myColor.mrtYellow
        } else if label.contains("??????") {
            cell.mrtLabel.text = "??????"
            cell.mrtLabel.textColor = .black
            cell.mrtLabel.backgroundColor = myColor.mrtYellow
        } else if label.contains("??????") {
            cell.mrtLabel.text = "??????"
            cell.mrtLabel.textColor = .black
            cell.mrtLabel.backgroundColor = myColor.mrtYellow
        } else if label.contains("????????????") {
            cell.mrtLabel.text = "????????????"
            cell.mrtLabel.textColor = .black
            cell.mrtLabel.backgroundColor = myColor.mrtYellow
        } else if label.contains("??????") {
            cell.mrtLabel.text = "??????"
            cell.mrtLabel.textColor = .black
            cell.mrtLabel.backgroundColor = myColor.mrtYellow
        } else if label.contains("??????????????????") {
            cell.mrtLabel.text = "??????????????????"
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
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let cafeDetailVC = segue.destination as? CafeDetailVC,
           let row = tableView.indexPathForSelectedRow?.row {
            cafeDetailVC.currentCafe = (searchController.isActive) ? searchResults[row] :  CafeManager.cafeList[row]
        }
    }
}

// MARK: - UISearchController methods

extension CafeListVC: UISearchResultsUpdating {
    
    func filterContent(for searchText: String) {
        if searchController.isActive {
            searchResults = CafeManager.cafeList.filter { (cafe) -> Bool in
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
