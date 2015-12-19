//
//  MeController.swift
//  FunPoint
//
//  Created by QLX on 15/12/13.
//  Copyright © 2015年 com.fcuh.funpoint. All rights reserved.
//

import UIKit

class MeController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.cyanColor()
        self.title = "我"
      //  self.tabBarItem =
        let path = NSBundle.mainBundle().pathForResource("script", ofType: "js")
        JPEngine.evaluateScriptWithPath(path)
       
        // Do any additional setup after loading the view.
    }

    override func getTabBarItem() -> UITabBarItem! {
        let item = UITabBarItem(title: "我", image: UIImage(named: "tab_my_nor"), selectedImage: UIImage(named: "tab_my_down"))
//        item.setTitleColor(UIColor.yellowColor(), forState: UIControlState.Normal)
//        item.setTitleColor(UIColor.grayColor(), forState: UIControlState.Selected)
        return item
    }
    
//    override func getTabBarItem() -> UITabBarItem! {
//        return UITabBarItem(title: "我", image: <#T##UIImage?#>, selectedImage: <#T##UIImage?#>)
//    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
