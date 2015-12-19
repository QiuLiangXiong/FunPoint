//
//  QLXTarbarVCTransitionPaddingAnimator.h
//  FunPoint
//
//  Created by QLX on 15/12/13.
//  Copyright © 2015年 com.fcuh.funpoint. All rights reserved.
//

#import "QLXVCTransitionAnimatorBase.h"

@class QLXPanGestureRecognizer;

@interface QLXTarbarVCTransitionPaddingAnimator : QLXVCTransitionAnimatorBase<UITabBarControllerDelegate>

@property(nonatomic , strong) QLXPanGestureRecognizer * panGR;

@end
