//
//  RootViewController.swift
//  FunPoint
//
//  Created by QLX on 15/12/13.
//  Copyright © 2015年 com.fcuh.funpoint. All rights reserved.
//

import UIKit

class RootViewController: QLXTabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        UITabBar.appearance().tintColor = mainColor  //设置选中渲染颜色
        let aroundVC = AroundController.createWithNavigatonController() // 周围
        let findVC   = FindController.createWithNavigatonController() // 发现
        let activityVC = ActivityController.createWithNavigatonController() // 活动
        let meVC = MeController.createWithNavigatonController()        // 我
        self.viewControllers = [aroundVC , findVC , activityVC , meVC]
    }

}
