//
//  QLXCollectionViewCell.h
//  QLXExtDemo
//
//  Created by 邱良雄 on 15/10/22.
//  Copyright (c) 2015年 avatar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QLXCollectionView.h"
@class QLXStaticCell;
@class QLXCollectionView;
@class QLXCollectionViewCell;

@class ReuseDataBase;
@protocol  QLXCollectionViewCellDelegate;

@interface QLXCollectionViewCell : UICollectionViewCell

@property(nonatomic , weak) QLXCollectionView * collectionView;
@property(nonatomic , strong) ReuseDataBase * data;
@property(nonatomic , strong) NSIndexPath * indexPath;
@property(nonatomic , weak) id<QLXCollectionViewCellDelegate> delegate;
@property (nonatomic, strong) UIView * lineV;
@property (nonatomic, strong) UIView * view;
@property (nonatomic, assign) BOOL cellSelected;

-(void) createUI;

-(void) reuseWithData:(ReuseDataBase *) data indexPath:(NSIndexPath *) indexPath;

-(void) setSeparatorLineHidden;

-(void) setSeparatorLineShow;

-(CGSize) cellSize;
// 内容根据自动布局得出理论大小
-(CGSize) contentViewSize;

/**
 *  需要在子类里重写
 *
 *  @return cell 的宽度
 */
-(CGFloat) cellWidth;

-(CGFloat) cellHeight;

-(void) setSeparatorLineShowWithInset:(UIEdgeInsets ) edgeInset;

-(void) setSeparatorLineColor:(UIColor *) color;
/**
 *  刷新 可重写
 */
-(void) refresh;

/**
 *  选中该cell
 */
-(void) selectedCell;

/**
 *  取消选中
 */
-(void) deSelectedCell;

@end


@protocol QLXCollectionViewCellDelegate <NSObject>

@optional

-(void) collectionViewCell:(QLXCollectionViewCell *)cell didSelect:(NSIndexPath *)indexPath;
-(void) collectionViewCell:(QLXCollectionViewCell *)cell didHighlited:(NSIndexPath *)indexPath;

// 主动请求刷新数据

-(void) reloadWithcollectionViewCell:(QLXCollectionViewCell *)cell;

@end


