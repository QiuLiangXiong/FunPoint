//
//  QLXTabBarController.m
//  FunPoint
//
//  Created by QLX on 15/12/13.
//  Copyright © 2015年 com.fcuh.funpoint. All rights reserved.
//

#import "QLXTabBarController.h"
#import "QLXExt.h"

@interface QLXTabBarController ()

@property(nonatomic , strong) QLXTarbarVCTransitionPaddingAnimator * animator;

@end

@implementation QLXTabBarController
@synthesize animator = _animator;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBar.translucent = false;// 如果不设置非透明  切换后台的时候底部会黑一下
    self.delegate =  self.animator;
    
    NSLog(@"%@",self.delegate);
    [self.animator logRetainCount];
    [GCDQueue executeInMainQueue:^{
       NSLog(@"%@",self.delegate);
    } afterDelaySecs:1];
    [GCDQueue executeInMainQueue:^{
        NSLog(@"%@",self.delegate);
    } afterDelaySecs:2];
   // self setValue:<#(nullable id)#> forKey:<#(nonnull NSString *)#>
    // Do any additional setup after loading the view.
}

-(QLXTarbarVCTransitionPaddingAnimator *)animator{
    if (!_animator) {
        _animator = [QLXTarbarVCTransitionPaddingAnimator new];
        _animator.destinationController = self;
        
    }
    return _animator;
}

-(void)setAnimator:(QLXTarbarVCTransitionPaddingAnimator *)animator{
    _animator = animator;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
