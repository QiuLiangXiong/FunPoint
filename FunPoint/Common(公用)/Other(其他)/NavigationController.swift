//
//  NavigationController.swift
//  FunPoint
//
//  Created by QLX on 15/12/13.
//  Copyright © 2015年 com.fcuh.funpoint. All rights reserved.
//

import UIKit

class NavigationController: QLXNavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setNavigationBarBgColor(mainColor)
        self.setTitleColor(UIColor.whiteColor())
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
