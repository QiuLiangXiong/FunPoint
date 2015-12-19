//
//  QLXPanGestureRecognizer.h
//  FunPoint
//
//  Created by QLX on 15/12/15.
//  Copyright © 2015年 com.fcuh.funpoint. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSUInteger, QLXPanGestureRecognizerDirection) {
    QLXPanGestureRecognizerDirectionDefault     = 0,       // 全方向
    QLXPanGestureRecognizerDirectionHorizontal  = 1 << 4,  // 横向
    QLXPanGestureRecognizerDirectionVertical    = 1 << 5   // 纵向
};

@interface QLXPanGestureRecognizer : UIPanGestureRecognizer

@property(nonatomic , assign) BOOL delayBeginToDirection;   // 是否延迟开始触摸直到有了方向为止
@property(nonatomic , assign) QLXPanGestureRecognizerDirection direction;
@property(nonatomic , weak) UIView * targetView ; // 在这个view下滑动
@property(nonatomic , assign) CGPoint locationInTargetView;
@property(nonatomic , assign) BOOL paning;



@end


