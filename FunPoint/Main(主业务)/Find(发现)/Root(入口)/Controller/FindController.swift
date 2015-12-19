//
//  FindController.swift
//  FunPoint
//
//  Created by QLX on 15/12/13.
//  Copyright © 2015年 com.fcuh.funpoint. All rights reserved.
//

import UIKit

class FindController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.blueColor()
        self.title = "发现"
        // Do any additional setup after loading the view.
    }

    override func getTabBarItem() -> UITabBarItem! {
        let item = UITabBarItem(title: "发现", image: UIImage(named: "tab_business_nor"), selectedImage: UIImage(named: "tab_business_down"))
        //        item.setTitleColor(UIColor.yellowColor(), forState: UIControlState.Normal)
        //        item.setTitleColor(UIColor.grayColor(), forState: UIControlState.Selected)
        return item
    }
    
    
    override func viewDidAppear(animated: Bool) {
        
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
