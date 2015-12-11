//
//  QLXScrollView.m
//  fcuhConsumer
//
//  Created by 邱良雄 on 15/9/16.
//  Copyright (c) 2015年 avatar. All rights reserved.
//

#import "QLXScrollView.h"
#import "QLXExt.h"

@implementation QLXScrollView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/



-(BOOL)touchesShouldCancelInContentView:(UIView *)view{
    if ([view isKindOfClass:[UIControl class]]) {
        return true;
    }
    return [super touchesShouldCancelInContentView:view];
}

@end
