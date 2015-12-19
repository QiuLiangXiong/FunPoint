//
//  ApplicationManager.swift
//  FunPoint
//
//  Created by QLX on 15/12/13.
//  Copyright © 2015年 com.fcuh.funpoint. All rights reserved.
//

import UIKit

class ApplicationManager: NSObject {
    
    private static var instance = ApplicationManager() // once 线程安全
    class func getInstance() -> ApplicationManager {
        return instance
    }
    // 初始化
    override init() {
        super.init()
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: false)// 状态栏变白色
    }
    
    // 程序主窗口
    var _rootWindow:UIWindow!
    var rootWindow:UIWindow! {
        if _rootWindow == nil {
            _rootWindow = self.getRootWindow()
        }
        return _rootWindow
    }
    // 主控制器
    var rootViewController:UIViewController! {
        return self.rootWindow.rootViewController!
    }
    
    // 产生一个窗口
    private func getRootWindow() -> UIWindow {
        let window = UIWindow(frame: UIScreen.mainScreen().bounds )
//        let t = UITabBarController()
//        let v = UIViewController()
//        v.view.backgroundColor = UIColor.whiteColor()
//        t.viewControllers = [v]
        window.rootViewController = RootViewController()
        window.makeKeyAndVisible()
        return window
    }
    
    
    
}
