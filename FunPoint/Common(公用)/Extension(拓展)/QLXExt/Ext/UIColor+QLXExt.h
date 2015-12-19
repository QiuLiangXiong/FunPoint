//
//  UIColor+QLXExt.h
//  fcuhConsumer
//
//  Created by 邱良雄 on 15/8/7.
//  Copyright (c) 2015年 avatar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor(QLXExt)
+ (instancetype) colorWithHexString: (NSString *)color;
/**
 *  0~255 范围的rgb
 *
 *  @param red   [0 ,255]
 *  @param green
 *  @param blue
 *
 *  @return 
 */
+ (instancetype) colorWithR:(CGFloat) red g:(CGFloat) green b:(CGFloat)blue;
@end
