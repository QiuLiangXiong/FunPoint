//
//  AroundController.swift
//  FunPoint
//
//  Created by QLX on 15/12/13.
//  Copyright © 2015年 com.fcuh.funpoint. All rights reserved.
//

import UIKit

class AroundController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.redColor()
        self.title = "周围"
        
        // Do any additional setup after loading the view.
    }

    override func getTabBarItem() -> UITabBarItem! {
        let item = UITabBarItem(title: "周围", image: UIImage(named: "tab_friends_nor"), selectedImage: UIImage(named: "tab_friends_down"))
        return item
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
