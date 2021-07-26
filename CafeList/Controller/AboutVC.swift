//
//  AboutVC.swift
//  CafeList
//
//  Created by Judy Tsai on 2021/7/12.
//

import UIKit
import MessageUI
import SafariServices
import StoreKit

class AboutVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    let myColor = Colors.shared
    var sectionTitles = ["支持我們", "關於本軟體"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTableView()
        setNavigationController()

    }
    
    func setTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = true
        tableView.cellLayoutMarginsFollowReadableWidth = true
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        tableView.tableFooterView = UIView() // remove unused seperators
    }
    
    func setNavigationController () {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        if let customFont = UIFont(name: "Ubuntu-Bold", size: 40.0) {
            navigationController?.navigationBar.largeTitleTextAttributes = [
                NSAttributedString.Key.foregroundColor:
                    myColor.primaryDarkColor,
                NSAttributedString.Key.font: customFont
            ]
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 5
        } else {
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
        
        let label = UILabel()
        label.frame = CGRect.init(x: 20, y: 0, width: headerView.frame.width-10, height: headerView.frame.height)
        
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textColor = myColor.primaryColor
        
        if section == 0 {
            label.text = "支持我們"
        } else {
            label.text = "關於本軟體"
        }
        
        headerView.addSubview(label)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "aboutCell", for: indexPath)
        cell.imageView?.tintColor = myColor.primaryLightColor
        
        if indexPath.section == 0 {
            switch indexPath.row {
            
            case 0:
                cell.textLabel?.text = "新增店家資訊"
                cell.detailTextLabel?.text = ""
                cell.imageView?.image = UIImage(systemName: "doc.badge.plus")
                
                return cell
                
            case 1:
                cell.textLabel?.text = "在 App Store 給我們評分"
                cell.detailTextLabel?.text = ""
                cell.imageView?.image = UIImage(systemName: "star.circle")
                
                return cell
                
            case 2:
                cell.textLabel?.text = "寫信給開發者"
                cell.detailTextLabel?.text = ""
                cell.imageView?.image = UIImage(systemName: "square.and.pencil")
                
                return cell
                
            case 3:
                cell.textLabel?.text = "Cafinder 官網"
                cell.detailTextLabel?.text = ""
                cell.imageView?.image = UIImage(systemName: "display")
                
                return cell
                
            case 4:
                cell.textLabel?.text = "Cafe Nomad 官網"
                cell.detailTextLabel?.text = ""
                cell.imageView?.image = UIImage(systemName: "display")
                
                return cell
                
            default:
                cell.textLabel?.text = ""
                cell.detailTextLabel?.text = ""
                
                return cell
            }
            
        } else {
            
            switch indexPath.row {
            
            case 0:
                cell.textLabel?.text = "版本"
                let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
                cell.detailTextLabel?.text = appVersion ?? "N/A"
                cell.imageView?.image = UIImage(systemName: "info.circle")
                
                return cell
                
            case 1:
                cell.textLabel?.text = "隱私權政策"
                cell.detailTextLabel?.text = ""
                cell.imageView?.image = UIImage(systemName: "doc")
                // 導到網頁上
                return cell
                
            default:
                cell.textLabel?.text = ""
                cell.detailTextLabel?.text = ""
                
                return cell
            }
        }
    }
}

extension AboutVC: MFMailComposeViewControllerDelegate {
    
    func displayAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let confirm = UIAlertAction(title: "好唷", style: .default, handler: { action in
            if let url = URL(string: "https://cafenomad.tw/contribute") {
                let controller = SFSafariViewController(url: url)
                self.present(controller, animated: true, completion: nil)
            }
        })
        let cancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        
        alert.addAction(confirm)
        alert.addAction(cancel)
        alert.view.tintColor = myColor.primaryColor
        alert.preferredAction = confirm
        
        present(alert, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.section {
        
        case 0:
            
            if indexPath.row == 0 {
                
                displayAlert(title: "友善提醒", message: "將跳轉至 Cafe Nomad 網站，請登入臉書後點右上選單 > 新增店家")
            }
            
            if indexPath.row == 1 {
                // Rate in App Store
                if let url = URL(string: "itms-apps://itunes.apple.com/app/" + "id1578166349") {
                      if #available(iOS 10, *) {
                          UIApplication.shared.open(url, options: [:], completionHandler: nil)

                      } else {
                          UIApplication.shared.openURL(url)
                      }
                  }
            }
            
            if indexPath.row == 2 {
                // Modify following variables with your text / recipient
                let recipientEmail = "sonic8776@gmail.com"
                let subject = "【Cafinder】來自使用者的回饋"
                let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
                let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String
                let deviceType = UIDevice().type
                let systemVersion = UIDevice.current.systemVersion
                let body = "\n\n\n\n\n【以下資訊供開發者除錯，請勿刪除】\nVersion：\(appVersion ?? "N/A")\nBuild：\(build ?? "N/A")\nDevice：\(deviceType)\nSystem Version：\(systemVersion)"
                
                //            // Show default mail composer
                //            if MFMailComposeViewController.canSendMail() {
                //                let mail = MFMailComposeViewController()
                //                mail.mailComposeDelegate = self
                //                mail.setToRecipients([recipientEmail])
                //                mail.setSubject(subject)
                //                mail.setMessageBody(body, isHTML: false)
                //
                //                present(mail, animated: true)
                //
                //                // Show third party email composer if default Mail app is not present
                //            } else if let emailUrl = createEmailUrl(to: recipientEmail, subject: subject, body: body) {
                //                UIApplication.shared.open(emailUrl)
                //            }
                
                if let emailUrl = createEmailUrl(to: recipientEmail, subject: subject, body: body) {
                    UIApplication.shared.open(emailUrl)
                }
                tableView.deselectRow(at: indexPath, animated: true)
            }
            
            if indexPath.row == 3 {
                // Cafinder 官網
                if let url = URL(string: "https://sonic8776.wixsite.com/cafinder") {
                    let controller = SFSafariViewController(url: url)
                    self.present(controller, animated: true, completion: nil)
                }
                tableView.deselectRow(at: indexPath, animated: true)
            }
            
            if indexPath.row == 4 {
                // Cafe Nomad 官網
                if let url = URL(string: "https://cafenomad.tw") {
                    let controller = SFSafariViewController(url: url)
                    self.present(controller, animated: true, completion: nil)
                }
                tableView.deselectRow(at: indexPath, animated: true)
            }
            
            else {
                tableView.deselectRow(at: indexPath, animated: true)
            }
            
        case 1:
            
            if indexPath.row == 1 {
                // Cafinder 隱私權政策
                if let url = URL(string: "https://sonic8776.wixsite.com/cafinder/privacy-policy") {
                    let controller = SFSafariViewController(url: url)
                    self.present(controller, animated: true, completion: nil)
                }
            }
            
            tableView.deselectRow(at: indexPath, animated: true)
            
            return
            
        default:
            tableView.deselectRow(at: indexPath, animated: true)
            return
        }
    }
    
    func createEmailUrl(to: String, subject: String, body: String) -> URL? {
        let subjectEncoded = subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let bodyEncoded = body.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        let gmailUrl = URL(string: "googlegmail://co?to=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
        let outlookUrl = URL(string: "ms-outlook://compose?to=\(to)&subject=\(subjectEncoded)")
        let yahooMail = URL(string: "ymail://mail/compose?to=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
        let sparkUrl = URL(string: "readdle-spark://compose?recipient=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
        let defaultUrl = URL(string: "mailto:\(to)?subject=\(subjectEncoded)&body=\(bodyEncoded)")
        
        if let gmailUrl = gmailUrl, UIApplication.shared.canOpenURL(gmailUrl) {
            return gmailUrl
        } else if let outlookUrl = outlookUrl, UIApplication.shared.canOpenURL(outlookUrl) {
            return outlookUrl
        } else if let yahooMail = yahooMail, UIApplication.shared.canOpenURL(yahooMail) {
            return yahooMail
        } else if let sparkUrl = sparkUrl, UIApplication.shared.canOpenURL(sparkUrl) {
            return sparkUrl
        }
        
        return defaultUrl
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}

// MARK: - Find user's device

public enum Model : String {

//Simulator
case simulator     = "simulator/sandbox",

//iPod
iPod1              = "iPod 1",
iPod2              = "iPod 2",
iPod3              = "iPod 3",
iPod4              = "iPod 4",
iPod5              = "iPod 5",
iPod6              = "iPod 6",
iPod7              = "iPod 7",

//iPad
iPad2              = "iPad 2",
iPad3              = "iPad 3",
iPad4              = "iPad 4",
iPadAir            = "iPad Air ",
iPadAir2           = "iPad Air 2",
iPadAir3           = "iPad Air 3",
iPadAir4           = "iPad Air 4",
iPad5              = "iPad 5", //iPad 2017
iPad6              = "iPad 6", //iPad 2018
iPad7              = "iPad 7", //iPad 2019
iPad8              = "iPad 8", //iPad 2020

//iPad Mini
iPadMini           = "iPad Mini",
iPadMini2          = "iPad Mini 2",
iPadMini3          = "iPad Mini 3",
iPadMini4          = "iPad Mini 4",
iPadMini5          = "iPad Mini 5",

//iPad Pro
iPadPro9_7         = "iPad Pro 9.7\"",
iPadPro10_5        = "iPad Pro 10.5\"",
iPadPro11          = "iPad Pro 11\"",
iPadPro2_11        = "iPad Pro 11\" 2nd gen",
iPadPro3_11        = "iPad Pro 11\" 3nd gen",
iPadPro12_9        = "iPad Pro 12.9\"",
iPadPro2_12_9      = "iPad Pro 2 12.9\"",
iPadPro3_12_9      = "iPad Pro 3 12.9\"",
iPadPro4_12_9      = "iPad Pro 4 12.9\"",
iPadPro5_12_9      = "iPad Pro 5 12.9\"",

//iPhone
iPhone4            = "iPhone 4",
iPhone4S           = "iPhone 4S",
iPhone5            = "iPhone 5",
iPhone5S           = "iPhone 5S",
iPhone5C           = "iPhone 5C",
iPhone6            = "iPhone 6",
iPhone6Plus        = "iPhone 6 Plus",
iPhone6S           = "iPhone 6S",
iPhone6SPlus       = "iPhone 6S Plus",
iPhoneSE           = "iPhone SE",
iPhone7            = "iPhone 7",
iPhone7Plus        = "iPhone 7 Plus",
iPhone8            = "iPhone 8",
iPhone8Plus        = "iPhone 8 Plus",
iPhoneX            = "iPhone X",
iPhoneXS           = "iPhone XS",
iPhoneXSMax        = "iPhone XS Max",
iPhoneXR           = "iPhone XR",
iPhone11           = "iPhone 11",
iPhone11Pro        = "iPhone 11 Pro",
iPhone11ProMax     = "iPhone 11 Pro Max",
iPhoneSE2          = "iPhone SE 2nd gen",
iPhone12Mini       = "iPhone 12 Mini",
iPhone12           = "iPhone 12",
iPhone12Pro        = "iPhone 12 Pro",
iPhone12ProMax     = "iPhone 12 Pro Max",

// Apple Watch
AppleWatch1         = "Apple Watch 1gen",
AppleWatchS1        = "Apple Watch Series 1",
AppleWatchS2        = "Apple Watch Series 2",
AppleWatchS3        = "Apple Watch Series 3",
AppleWatchS4        = "Apple Watch Series 4",
AppleWatchS5        = "Apple Watch Series 5",
AppleWatchSE        = "Apple Watch Special Edition",
AppleWatchS6        = "Apple Watch Series 6",

//Apple TV
AppleTV1           = "Apple TV 1gen",
AppleTV2           = "Apple TV 2gen",
AppleTV3           = "Apple TV 3gen",
AppleTV4           = "Apple TV 4gen",
AppleTV_4K         = "Apple TV 4K",
AppleTV2_4K        = "Apple TV 4K 2gen",

unrecognized       = "?unrecognized?"
}

// #-#-#-#-#-#-#-#-#-#-#-#-#
// MARK: UIDevice extensions
// #-#-#-#-#-#-#-#-#-#-#-#-#

public extension UIDevice {

var type: Model {
    var systemInfo = utsname()
    uname(&systemInfo)
    let modelCode = withUnsafePointer(to: &systemInfo.machine) {
        $0.withMemoryRebound(to: CChar.self, capacity: 1) {
            ptr in String.init(validatingUTF8: ptr)
        }
    }

    let modelMap : [String: Model] = [

        //Simulator
        "i386"      : .simulator,
        "x86_64"    : .simulator,

        //iPod
        "iPod1,1"   : .iPod1,
        "iPod2,1"   : .iPod2,
        "iPod3,1"   : .iPod3,
        "iPod4,1"   : .iPod4,
        "iPod5,1"   : .iPod5,
        "iPod7,1"   : .iPod6,
        "iPod9,1"   : .iPod7,

        //iPad
        "iPad2,1"   : .iPad2,
        "iPad2,2"   : .iPad2,
        "iPad2,3"   : .iPad2,
        "iPad2,4"   : .iPad2,
        "iPad3,1"   : .iPad3,
        "iPad3,2"   : .iPad3,
        "iPad3,3"   : .iPad3,
        "iPad3,4"   : .iPad4,
        "iPad3,5"   : .iPad4,
        "iPad3,6"   : .iPad4,
        "iPad6,11"  : .iPad5, //iPad 2017
        "iPad6,12"  : .iPad5,
        "iPad7,5"   : .iPad6, //iPad 2018
        "iPad7,6"   : .iPad6,
        "iPad7,11"  : .iPad7, //iPad 2019
        "iPad7,12"  : .iPad7,
        "iPad11,6"  : .iPad8, //iPad 2020
        "iPad11,7"  : .iPad8,

        //iPad Mini
        "iPad2,5"   : .iPadMini,
        "iPad2,6"   : .iPadMini,
        "iPad2,7"   : .iPadMini,
        "iPad4,4"   : .iPadMini2,
        "iPad4,5"   : .iPadMini2,
        "iPad4,6"   : .iPadMini2,
        "iPad4,7"   : .iPadMini3,
        "iPad4,8"   : .iPadMini3,
        "iPad4,9"   : .iPadMini3,
        "iPad5,1"   : .iPadMini4,
        "iPad5,2"   : .iPadMini4,
        "iPad11,1"  : .iPadMini5,
        "iPad11,2"  : .iPadMini5,

        //iPad Pro
        "iPad6,3"   : .iPadPro9_7,
        "iPad6,4"   : .iPadPro9_7,
        "iPad7,3"   : .iPadPro10_5,
        "iPad7,4"   : .iPadPro10_5,
        "iPad6,7"   : .iPadPro12_9,
        "iPad6,8"   : .iPadPro12_9,
        "iPad7,1"   : .iPadPro2_12_9,
        "iPad7,2"   : .iPadPro2_12_9,
        "iPad8,1"   : .iPadPro11,
        "iPad8,2"   : .iPadPro11,
        "iPad8,3"   : .iPadPro11,
        "iPad8,4"   : .iPadPro11,
        "iPad8,9"   : .iPadPro2_11,
        "iPad8,10"  : .iPadPro2_11,
        "iPad13,4"  : .iPadPro3_11,
        "iPad13,5"  : .iPadPro3_11,
        "iPad13,6"  : .iPadPro3_11,
        "iPad13,7"  : .iPadPro3_11,
        "iPad8,5"   : .iPadPro3_12_9,
        "iPad8,6"   : .iPadPro3_12_9,
        "iPad8,7"   : .iPadPro3_12_9,
        "iPad8,8"   : .iPadPro3_12_9,
        "iPad8,11"  : .iPadPro4_12_9,
        "iPad8,12"  : .iPadPro4_12_9,
        "iPad13,8"  : .iPadPro5_12_9,
        "iPad13,9"  : .iPadPro5_12_9,
        "iPad13,10" : .iPadPro5_12_9,
        "iPad13,11" : .iPadPro5_12_9,

        //iPad Air
        "iPad4,1"   : .iPadAir,
        "iPad4,2"   : .iPadAir,
        "iPad4,3"   : .iPadAir,
        "iPad5,3"   : .iPadAir2,
        "iPad5,4"   : .iPadAir2,
        "iPad11,3"  : .iPadAir3,
        "iPad11,4"  : .iPadAir3,
        "iPad13,1"  : .iPadAir4,
        "iPad13,2"  : .iPadAir4,
        

        //iPhone
        "iPhone3,1" : .iPhone4,
        "iPhone3,2" : .iPhone4,
        "iPhone3,3" : .iPhone4,
        "iPhone4,1" : .iPhone4S,
        "iPhone5,1" : .iPhone5,
        "iPhone5,2" : .iPhone5,
        "iPhone5,3" : .iPhone5C,
        "iPhone5,4" : .iPhone5C,
        "iPhone6,1" : .iPhone5S,
        "iPhone6,2" : .iPhone5S,
        "iPhone7,1" : .iPhone6Plus,
        "iPhone7,2" : .iPhone6,
        "iPhone8,1" : .iPhone6S,
        "iPhone8,2" : .iPhone6SPlus,
        "iPhone8,4" : .iPhoneSE,
        "iPhone9,1" : .iPhone7,
        "iPhone9,3" : .iPhone7,
        "iPhone9,2" : .iPhone7Plus,
        "iPhone9,4" : .iPhone7Plus,
        "iPhone10,1" : .iPhone8,
        "iPhone10,4" : .iPhone8,
        "iPhone10,2" : .iPhone8Plus,
        "iPhone10,5" : .iPhone8Plus,
        "iPhone10,3" : .iPhoneX,
        "iPhone10,6" : .iPhoneX,
        "iPhone11,2" : .iPhoneXS,
        "iPhone11,4" : .iPhoneXSMax,
        "iPhone11,6" : .iPhoneXSMax,
        "iPhone11,8" : .iPhoneXR,
        "iPhone12,1" : .iPhone11,
        "iPhone12,3" : .iPhone11Pro,
        "iPhone12,5" : .iPhone11ProMax,
        "iPhone12,8" : .iPhoneSE2,
        "iPhone13,1" : .iPhone12Mini,
        "iPhone13,2" : .iPhone12,
        "iPhone13,3" : .iPhone12Pro,
        "iPhone13,4" : .iPhone12ProMax,
        
        // Apple Watch
        "Watch1,1" : .AppleWatch1,
        "Watch1,2" : .AppleWatch1,
        "Watch2,6" : .AppleWatchS1,
        "Watch2,7" : .AppleWatchS1,
        "Watch2,3" : .AppleWatchS2,
        "Watch2,4" : .AppleWatchS2,
        "Watch3,1" : .AppleWatchS3,
        "Watch3,2" : .AppleWatchS3,
        "Watch3,3" : .AppleWatchS3,
        "Watch3,4" : .AppleWatchS3,
        "Watch4,1" : .AppleWatchS4,
        "Watch4,2" : .AppleWatchS4,
        "Watch4,3" : .AppleWatchS4,
        "Watch4,4" : .AppleWatchS4,
        "Watch5,1" : .AppleWatchS5,
        "Watch5,2" : .AppleWatchS5,
        "Watch5,3" : .AppleWatchS5,
        "Watch5,4" : .AppleWatchS5,
        "Watch5,9" : .AppleWatchSE,
        "Watch5,10" : .AppleWatchSE,
        "Watch5,11" : .AppleWatchSE,
        "Watch5,12" : .AppleWatchSE,
        "Watch6,1" : .AppleWatchS6,
        "Watch6,2" : .AppleWatchS6,
        "Watch6,3" : .AppleWatchS6,
        "Watch6,4" : .AppleWatchS6,

        //Apple TV
        "AppleTV1,1" : .AppleTV1,
        "AppleTV2,1" : .AppleTV2,
        "AppleTV3,1" : .AppleTV3,
        "AppleTV3,2" : .AppleTV3,
        "AppleTV5,3" : .AppleTV4,
        "AppleTV6,2" : .AppleTV_4K,
        "AppleTV11,1" : .AppleTV2_4K
    ]

    if let model = modelMap[String.init(validatingUTF8: modelCode!)!] {
        if model == .simulator {
            if let simModelCode = ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] {
                if let simModel = modelMap[String.init(validatingUTF8: simModelCode)!] {
                    return simModel
                }
            }
        }
        return model
    }
    return Model.unrecognized
  }
}
