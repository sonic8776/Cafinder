//
//  AboutVC.swift
//  CafeList
//
//  Created by Judy Tsai on 2021/7/12.
//

import UIKit
import MessageUI
import SafariServices

class AboutVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    let myColor = Colors.shared
    var sectionTitles = ["支持我們", "關於本軟體"]
    var sectionHeaderHeight: CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = true
        
        tableView.cellLayoutMarginsFollowReadableWidth = true
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // Set navigationController
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        if let customFont = UIFont(name: "RubikRoman-Medium", size: 40.0) {
            navigationController?.navigationBar.largeTitleTextAttributes = [
                NSAttributedString.Key.foregroundColor:
                    myColor.primaryColor,
                NSAttributedString.Key.font: customFont
            ]
        }
        
        tableView.tableFooterView = UIView() // remove unused seperators
        sectionHeaderHeight = tableView.dequeueReusableCell(withIdentifier: "headerCell")?.contentView.bounds.height ?? 0
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
        
        return sectionHeaderHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
        
        let label = UILabel()
        label.frame = CGRect.init(x: 20, y: 0, width: headerView.frame.width-10, height: headerView.frame.height-10)
        
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
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "好唷", style: .default, handler: { action in
            if let url = URL(string: "https://cafenomad.tw/contribute") {
                let controller = SFSafariViewController(url: url)
                self.present(controller, animated: true, completion: nil)
            }
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.section {
        case 0:
            if indexPath.row == 0 {
                
                displayAlert(title: "友善提醒", message: "將跳轉至 Cafe Nomad 網站，請登入臉書後點右上選單 -> 新增店家")
            }
            
            if indexPath.row == 1 {
                // Rate in App Store
            }
            
            if indexPath.row == 2 {
                // Modify following variables with your text / recipient
                let recipientEmail = "sonic8776@gmail.com"
                let subject = "【CafeList】來自使用者的回饋"
                let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
                let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String
                let body = "\n\n\n\n\n【以下資訊供開發者除錯，請勿刪除】\nVersion：\(appVersion ?? "N/A")\nBuild：\(build ?? "N/A")"
                
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
            }
            
            if indexPath.row == 4 {
                if let url = URL(string: "https://cafenomad.tw") {
                    let controller = SFSafariViewController(url: url)
                    self.present(controller, animated: true, completion: nil)
                }
            }
            
            else {
                tableView.deselectRow(at: indexPath, animated: true)
            }
        case 1:
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
