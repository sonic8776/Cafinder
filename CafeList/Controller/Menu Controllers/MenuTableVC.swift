//
//  MenuTableVC.swift
//  CafeList
//
//  Created by apple on 2021/8/1.
//

import UIKit

protocol MenuControllerDelegate {
    func didSelectMenuItem(named: SideMenuItem)
}

enum SideMenuItem: String, CaseIterable {
    case allCafes = "所有咖啡廳"
    case studyWork = "讀書 / 工作"
    case gather = "朋友小聚"
    case business = "談論公事"
}

class MenuTableVC: UITableViewController {

    let myColor = Colors.shared
    //private let menuItems: [String] = ["所有咖啡廳", "讀書 / 工作", "朋友小聚", "談論公事"]
    private let menuItems: [SideMenuItem]
    public var delegate: MenuControllerDelegate?
    
    init(with menuItems: [SideMenuItem]) {
        self.menuItems = menuItems
        super.init(nibName: nil, bundle: nil)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "menuCell")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //setNavigationController()
        title = "選擇需求"
        
        setTableViewBackground()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        navigationController?.setNavigationBarHidden(false, animated: animated)
//    }
    
//    func setNavigationController() {
//        navigationController?.navigationBar.barTintColor = myColor.secondaryColor
//        navigationController?.navigationBar.tintColor = .black
//    }
    
    func setTableViewBackground() {
        // Light grey background & footer view
        self.tableView.backgroundView?.backgroundColor = myColor.secondaryColor
        self.tableView.backgroundColor = myColor.secondaryColor
        self.tableView.separatorStyle = .none

        let footerView = UIView()
        footerView.backgroundColor = myColor.secondaryColor
        self.tableView.tableFooterView = footerView
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {

        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return menuItems.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell", for: indexPath)
        
        cell.textLabel?.text = menuItems[indexPath.row].rawValue
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 30)
        cell.textLabel?.textColor = myColor.primaryDarkColor
        
        cell.backgroundColor = myColor.secondaryColor
        cell.contentView.backgroundColor = myColor.secondaryColor

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 0 {
            
            if let tabVC = self.view.window?.rootViewController as? CafeTabBarController, var controllers = tabVC.viewControllers {
                controllers[0] = tabVC.cafeListVC
                self.dismiss(animated: true) {
                    tabVC.setViewControllers(controllers, animated: true)
                }
            }
        }
        
        if indexPath.row == 1 {
            if let tabVC = self.view.window?.rootViewController as? CafeTabBarController, var controllers = tabVC.viewControllers {
                if tabVC.studyVC == nil {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let studyVC = storyboard.instantiateViewController(withIdentifier: "studyNaviVC") as! UINavigationController
                    tabVC.studyVC = studyVC
                }
                controllers[0] = tabVC.studyVC
                self.dismiss(animated: true) {
                    tabVC.setViewControllers(controllers, animated: true)
                }
            }
        }
        
        if indexPath.row == 2 {
            if let tabVC = self.view.window?.rootViewController as? CafeTabBarController, var controllers = tabVC.viewControllers {
                if tabVC.gatherVC == nil {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let gatherVC = storyboard.instantiateViewController(withIdentifier: "gatherNaviVC") as! UINavigationController
                    tabVC.gatherVC = gatherVC
                }
                controllers[0] = tabVC.gatherVC
                self.dismiss(animated: true) {
                    tabVC.setViewControllers(controllers, animated: true)
                }
            }
        }
        
        if indexPath.row == 3 {
            if let tabVC = self.view.window?.rootViewController as? CafeTabBarController, var controllers = tabVC.viewControllers {
                if tabVC.businessVC == nil {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let businessVC = storyboard.instantiateViewController(withIdentifier: "businessNaviVC") as! UINavigationController
                    tabVC.businessVC = businessVC
                }
                controllers[0] = tabVC.businessVC
                self.dismiss(animated: true) {
                    tabVC.setViewControllers(controllers, animated: true)
                }
            }
        }
    }
    
    func updateVC(identifier : String){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: identifier)
         
        if let tabVC = self.view.window?.rootViewController as? UITabBarController, var controllers = tabVC.viewControllers {
            controllers[0] = vc
            self.dismiss(animated: true) {
                tabVC.setViewControllers(controllers, animated: true)
            }
        }
    }
    
}
