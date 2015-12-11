//
//  QLXCollectionReusableView.h
//  QLXExtDemo
//
//  Created by 邱良雄 on 15/10/22.
//  Copyright (c) 2015年 avatar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QLXCollectionView.h"

@class ReuseDataBase;
@class QLXCollectionView;
@protocol  QLXCollectionReusableViewDelegate;

@interface QLXCollectionReusableView : UICollectionReusableView

@property(nonatomic , weak) QLXCollectionView * collectionView;
@property(nonatomic , strong) ReuseDataBase * data;
@property(nonatomic , assign) NSInteger section;
@property(nonatomic , assign) BOOL bHeader;
@property(nonatomic , weak) id<QLXCollectionReusableViewDelegate> delegate;
@property (nonatomic, strong) UIView * view;

-(void) createUI;

-(void) reuseWithData:(ReuseDataBase *) data section:(NSInteger) section isHeader:(BOOL) bHeader;

-(CGFloat) viewHeight;
/**
 *  刷新
 */
-(void)refresh;

@end

@protocol QLXCollectionReusableViewDelegate <NSObject>

@end