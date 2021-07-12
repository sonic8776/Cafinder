//
//  CafeTabBarController.swift
//  CafeList
//
//  Created by Judy Tsai on 2021/7/12.
//

import UIKit

class CafeTabBarController: UITabBarController {
    
    let myColor = Colors.shared
    let customButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBar.barTintColor = myColor.primaryColor
        self.tabBar.tintColor = myColor.secondaryColor
        self.tabBar.unselectedItemTintColor = .white
        
        //settingButton()
    }
    
    func settingButton() {
        let image = UIImage(named: "Map_Marker")
        customButton.setImage(image, for: .normal)
        customButton.frame.size = CGSize(width: 60, height: 60)
        // 這邊希望他超出 tabBar 範圍，因此在這邊提高其 y 軸位置。
        customButton.center = CGPoint(x: tabBar.bounds.midX, y: tabBar.bounds.midY - customButton.frame.height / 3)
        customButton.backgroundColor = myColor.secondaryColor
        customButton.layer.cornerRadius = 15
        //customButton.layer.borderColor = UIColor.black.cgColor
        //customButton.layer.borderWidth = 3
        customButton.clipsToBounds = true
        // 取消按鈕點選 highLight 效果
        customButton.adjustsImageWhenHighlighted = false
        // 為客製化按鈕新增一個點擊事件
        customButton.addTarget(self, action: #selector(showViewController), for: .touchDown)
        tabBar.addSubview(customButton)
    }
    
    @objc func showViewController() {
        // 設置按鈕背景色，讓他看起來有 highlighted 的效果
        customButton.backgroundColor = myColor.secondaryColor
        // 跳轉至 tabBarController 相對應的索引值的
        self.selectedIndex = 1
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        // 判斷點選的頁面 title 是否為 Home：true 按鈕背景色為白色；false 則為灰色。
        if item.title == "Map" {
            customButton.backgroundColor = myColor.secondaryColor
        } else {
            customButton.backgroundColor = myColor.primaryLightColor
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        touches.forEach { (touch) in
            // position 為碰觸的位置
            let position = touch.location(in: tabBar)
            // 按鈕的高度偏差值
            let offset = customButton.frame.height / 3
            // 判斷按鈕 x 軸範圍是否在其中
            if customButton.frame.minX <= position.x && position.x <= customButton.frame.maxX {
                // 判斷按鈕 y 軸範圍是否在其中
                if customButton.frame.minY - offset <= position.y && position.y <= customButton.frame.maxY - offset{
                    // 執行相同的按鈕方法
                    showViewController()
                }
            }
        }
    }
}
