//
//  RootWindow.swift
//  FunPoint
//
//  Created by 邱良雄 on 15/12/9.
//  Copyright © 2015年 com.fcuh.funpoint. All rights reserved.
//

import UIKit

/// 主窗口 单例
class RootWindow: UIWindow {
    static let instance:RootWindow = RootWindow()
    /**
     单例
     */
    class func getInstance() -> RootWindow {
        return instance
    }
    /**
     初始化
     */
    override func onEnter() {
        super.onEnter()
        self.makeKeyAndVisible()
    }
    
    
    

    
    
    
 
}
