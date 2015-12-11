//
//  QLXViewController.m
//  fcuhConsumer
//
//  Created by 邱良雄 on 15/8/15.
//  Copyright (c) 2015年 avatar. All rights reserved.
//

#import "QLXViewController.h"
#import "QLXExt.h"
@interface QLXViewController ()
@end

@implementation QLXViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}


-(UIView *)bg{
    if (!_bg) {
        _bg = [QLXView createWithBgColor:[UIColor clearColor]];
        _bg.clipsToBounds = true;
        [self.view addSubview:_bg];
        [_bg constraintWithEdgeZero];
    }
    return _bg;
}





-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}












//
//-(UIView *)bgView{
//    if (!_bgView) {
//        _bgView = [UIView new];
//        _bgView.backgroundColor = [UIColor whiteColor];NSString
//        
//    }
//}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
