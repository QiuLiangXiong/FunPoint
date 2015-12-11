//
//  QLXPageViewController.h
//  QLXExtDemo
//
//  Created by QLX on 15/10/29.
//  Copyright (c) 2015年 avatar. All rights reserved.
//

#import "QLXViewController.h"
#import "QLXSegmentControl.h"
#import "QLXPageView.h"
#import "QLXHttpModel.h"
#import "QLXPageViewCell.h"
#import "QLXTableViewPage.h"
@class QLXPageView;
@class QLXSegmentControl;

@interface QLXPageViewController : QLXViewController<QLXHttpModelDelegate , QLXPageViewDelegate ,QLXSegmentControlDelegate>

@property(nonatomic , strong) QLXPageView * pageView;
@property(nonatomic , strong) QLXSegmentControl * segmentControl;

@property(nonatomic , strong) QLXHttpModel * pageViewModel;
@property(nonatomic , strong) QLXHttpModel * segmentControlModel;

@end
