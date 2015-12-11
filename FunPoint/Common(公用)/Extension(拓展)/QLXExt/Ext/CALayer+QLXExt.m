//
//  CALayer+QLXExt.m
//  fcuhConsumer
//
//  Created by 邱良雄 on 15/8/14.
//  Copyright (c) 2015年 avatar. All rights reserved.
//

#import "CALayer+QLXExt.h"
#import "QLXExt.h"
@implementation CALayer(QLXExt)
-(void) addSpringAnimation:(KeyPathType) type  WithBlock:(void(^)(QLXSpringAnimation * animation)) block{
    QLXSpringAnimation * animation = [QLXSpringAnimation animationWithKeyPathType:type];
    block(animation);
    [self addAnimation:animation forKey:animation.keyPath];
    
}

-(void) addKeyframeAnimation:(KeyPathType) type  WithBlock:(void(^)(QLXKeyframeAnimation * animation)) block{
    QLXKeyframeAnimation * animation = [QLXKeyframeAnimation animationWithKeyPathType:type];
    block(animation);
    [self addAnimation:animation forKey:animation.keyPath];
}

-(void) addBasicAnimation:(KeyPathType) type  WithBlock:(void(^)(QLXBasicAnimation * animation)) block{
    QLXBasicAnimation * animation = [QLXBasicAnimation animationWithKeyPathType:type];
    block(animation);
    [self addAnimation:animation forKey:animation.keyPath];
}
@end

