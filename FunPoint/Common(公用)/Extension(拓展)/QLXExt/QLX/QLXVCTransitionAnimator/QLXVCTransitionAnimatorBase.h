//
//  QLXVCTransitionAnimatorBase.h
//  fcuhConsumer
//  对控制器的转场动画进行封装  继承写个具体的动画变得极为简单 妈妈 就 再也不用担心的我转场动画不会写了
//  Created by 邱良雄 on 15/10/10.
//  Copyright (c) 2015年 avatar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIKit/UIKit.h"


typedef NS_ENUM(NSUInteger, QLXVCTransitonType) {
    QLXVCTransitonTypeNone                    = 1 << 0,
    QLXVCTransitonTypePresentation            = 1 << 1,
    QLXVCTransitonTypeDismiss                 = 1 << 2,
    QLXVCTransitonTypePush                    = 1 << 3,
    QLXVCTransitonTypeInteractionPresentation = 1 << 4,
    QLXVCTransitonTypeInteractionDismiss      = 1 << 5,
    QLXVCTransitonTypeInteractionPop          = 1 << 6,
    QLXVCTransitonTypeOther                   = 1 << 7
};

@interface QLXVCTransitionAnimatorBase : UIPercentDrivenInteractiveTransition
<
  UIViewControllerAnimatedTransitioning ,
  UIViewControllerTransitioningDelegate ,
  UIGestureRecognizerDelegate,
  UINavigationControllerDelegate
>

@property (nonatomic, assign) QLXVCTransitonType transitionType;
@property (nonatomic, weak  ) UIViewController   * destinationController; // 目的 控制器
@property (nonatomic, weak  ) UIViewController   * fromViewController;
@property (nonatomic, weak  ) UIViewController   * toViewController;
@property (nonatomic, weak  ) UIView             * containerView;
@property (nonatomic, assign) BOOL isDimiss;
@property (nonatomic, assign) BOOL isPop;

/**
 *  初始化
 */
- (void) initConfigs;

/**
 *  返回pop手势进度
 *
 *  @param gesture
 *
 *  @return [0 , 1] 区间 代表进度
 */
- (CGFloat) getInteractiveProgressWithGesture:(UIScreenEdgePanGestureRecognizer *)gesture;
/**
 *  过度动画基类方法 重写时记得父类方法
 *
 *  @param transitionContext 
 */
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext;

@end
