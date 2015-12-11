//
//  QLXAdPageView.h
//  轮播图 又名 广告图 控件
//
//  Created by QLX on 15/11/1.
//  Copyright (c) 2015年 avatar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QLXPageView.h"
#import "QLXSegmentControl.h"

@protocol QLXAdPageViewDelegate;
@class QLXPageControl;
@interface QLXAdPageView : UIView

@property(nonatomic , weak) id<QLXAdPageViewDelegate> delegate;

// 默认是系统自带的
@property(nonatomic , strong) UIImage * dotNormalImage;//自定义小圆点 的 正常图片
// 默认是系统自带的
@property(nonatomic , strong) UIImage * dotSelectedImage;//小圆点 的 选中图片
@property(nonatomic , strong) QLXPageControl * pageControl;
@property (nonatomic, assign) BOOL adEnable;

// 刷新
-(void) realoadData;

@end


// 代理
@protocol QLXAdPageViewDelegate <NSObject>


@optional

/**
 *  获取每一页 所需要的数据单元
 *
 *  配置ReuseDataBase派生类 的数组 对应pageCell只能是配置QLXPageViewCell派生类
 *  @param pageView
 *
 *  @return 数组 数组的大小代表有几页
 */
-(NSMutableArray *) pageDataListWithPageView:(QLXAdPageView *)pageView;



@end