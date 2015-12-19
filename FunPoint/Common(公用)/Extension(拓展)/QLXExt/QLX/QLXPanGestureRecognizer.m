//
//  QLXPanGestureRecognizer.m
//  FunPoint
//
//  Created by QLX on 15/12/15.
//  Copyright © 2015年 com.fcuh.funpoint. All rights reserved.
//

#import "QLXPanGestureRecognizer.h"
#import "QLXExt.h"

@interface QLXPanGestureRecognizer()

@property(nonatomic , weak)  id target;
@property(nonatomic , assign)  SEL action;
@property(nonatomic , assign) BOOL delayBegan;   //是否要延迟开始
@property(nonatomic , assign) BOOL reciveTouch;  // 是否接受触摸


@end

@implementation QLXPanGestureRecognizer



-(instancetype)init{
    self = [super init];
    if (self) {
        self.reciveTouch = true;
        [self removeTarget:self action:@selector(handlePanGestrure:)];
        [self addTarget:self action:@selector(handlePanGestrure:)];
    }
    return self;
}

-(instancetype)initWithTarget:(id)target action:(SEL)action{
    self = [super initWithTarget:self action:@selector(handlePanGestrure:)];
    if (self) {
        self.reciveTouch = true;
        [self addTarget:target action:action];
    }
    return self;
    
}

-(void)addTarget:(id)target action:(SEL)action{
    if (target == self) {
        [super addTarget:target action:action];
    }else {
        self.target = target;
        self.action = action;
    }
    
}

-(void) handlePanGestrure:(QLXPanGestureRecognizer *) gesture{
    UIGestureRecognizerState state = [gesture getOriginState];
    BOOL isDelay = self.delayBegan;
    if (self.delayBeginToDirection) {
        assert(self.targetView); //这个属性要设置 目标视图内滑动
        CGPoint offset = [gesture translationInView:self.targetView];
        if (state == UIGestureRecognizerStateBegan) {
            [self setUpDelayBeganWithOffset:offset];
        }else if(state == UIGestureRecognizerStateChanged){
            if (self.delayBegan) {
                [self setUpDelayBeganWithOffset:offset];
            }
        }
    }else {
        self.delayBegan = false;
    }
    if (self.delayBegan == false) {
        if (isDelay) {
            self.delayBegan = true;
        }
        [self sendTouchIfNeedWithGesture:gesture];
        self.delayBegan = false;
    }
    if (self.paning == false) { // 手势结束后 要重置这个属性 默认可以
        self.reciveTouch = true;
    }
}

-(BOOL) shouldRevieTouchWithGesture:(QLXPanGestureRecognizer *)gesture{
    if (self.state == UIGestureRecognizerStateBegan) {
        CGPoint offset = [gesture translationInView:self.targetView];
        if (self.direction == QLXPanGestureRecognizerDirectionHorizontal) {
            self.reciveTouch = fabs(offset.x) >= fabs(offset.y);
        }else if(self.direction == QLXPanGestureRecognizerDirectionVertical){
            self.reciveTouch = fabs(offset.x) <= fabs(offset.y);
        }
        
    }
    return self.reciveTouch;
}

-(void) sendTouchIfNeedWithGesture:(QLXPanGestureRecognizer *)gesture{
    if ([self shouldRevieTouchWithGesture:gesture]) {
        msgSend(msgTarget(self.target) , self.action , (UIView *)gesture);// 执行该方法
    }
}

-(void) setUpDelayBeganWithOffset:(CGPoint) offset{
    if (self.direction == QLXPanGestureRecognizerDirectionHorizontal) {
        self.delayBegan = offset.x == 0;
    }else if(self.direction == QLXPanGestureRecognizerDirectionVertical){
        self.delayBegan = offset.y == 0;
    }else {
        self.delayBegan = false;
    }
}

-(UIGestureRecognizerState) getOriginState{
    return [super state];
}

-(UIGestureRecognizerState)state{
    if (self.delayBeginToDirection && self.delayBegan) {
        UIGestureRecognizerState state = [super state];
        if (state == UIGestureRecognizerStateChanged || state == UIGestureRecognizerStateBegan) {
            return UIGestureRecognizerStateBegan;
        }
    }
    return [super state];
}

-(CGPoint)locationInTargetView{
    return [self translationInView:self.targetView];
}

-(BOOL)paning{
    if (self.state == UIGestureRecognizerStateBegan || self.state == UIGestureRecognizerStateChanged) {
        return true;
    }
    return false;
}

@end
