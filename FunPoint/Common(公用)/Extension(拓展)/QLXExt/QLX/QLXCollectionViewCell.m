//
//  QLXCollectionViewCell.m
//  QLXExtDemo
//
//  Created by 邱良雄 on 15/10/22.
//  Copyright (c) 2015年 avatar. All rights reserved.
//

#import "QLXCollectionViewCell.h"
#import "QLXExt.h"
#import "QLXCollectionView.h"

@implementation QLXCollectionViewCell



-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}


// 可以重写 可以不用重写
-(void) createUI{
    // 分割线 默认不显示
    self.lineV = [UIView new];
    self.lineV.hidden = true;
    self.lineV.backgroundColor = [UIColor colorWithWhite:225/255.0 alpha:1];
    [self addSubview:self.lineV];
    [self.lineV mas_makeConstraints:^(MASConstraintMaker *make){
        make.bottom.equalTo(self).offset(0);
        make.left.equalTo(self).offset(0);
        make.right.equalTo(self).offset(0);
        make.height.mas_equalTo(@0.3);
    }];
}
// 需要重写
-(void) reuseWithData:(ReuseDataBase *) data indexPath:(NSIndexPath *) indexPath{
    self.data = data;
    self.indexPath = indexPath;
}

-(CGSize) cellSize{
    //assert(self.collectionView);
    if ([self cellWidth]) {
        self.width = [self cellWidth];
    }
    if ([self cellHeight]){
        self.height = [self cellHeight];
    }
    if ([self cellWidth] && [self cellHeight]) {
        return CGSizeMake([self cellWidth], [self cellHeight]);
    }
    CGSize size = [self contentViewSize];
    if ([self cellWidth]) {
        size.width = [self cellWidth];
    }
    if ([self cellHeight]) {
        size.height = [self cellHeight];
    }
    self.data.height = size.width;
    self.data.width = size.height;
    return size;
}

-(CGFloat)cellWidth{
    return 0;
}

-(CGFloat) cellHeight{
    return 0;
}

-(CGSize) contentViewSize{
    [self refreshLayout];
    return [self.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
}

-(void) setSeparatorLineHidden{
    self.lineV.hidden = true;
}
-(void) setSeparatorLineShow{
    self.lineV.hidden = false;
}
-(void) setSeparatorLineShowWithInset:(UIEdgeInsets ) edgeInset{
    [self setSeparatorLineShow];
    [self.lineV mas_remakeConstraints:^(MASConstraintMaker *make){
        make.bottom.equalTo(self).offset(-edgeInset.bottom);
        make.left.equalTo(self).offset(edgeInset.left);
        make.right.equalTo(self).offset(-edgeInset.right);
        make.height.mas_equalTo(@0.3);
    }];
}
-(void) setSeparatorLineColor:(UIColor *) color{
    self.lineV.backgroundColor = color;
}

-(void) refresh{
}

-(UIView *)view{
    if (!_view) {
        _view = [QLXView createWithBgColor:[UIColor clearColor]];
        [self.contentView addSubview:_view];
        [_view constraintWithEdgeZero];
    }
    return _view;
}

-(void)setSelected:(BOOL)selected{
    if (selected) {
        [self selectedCell];
    }else if(self.collectionView.highlighted == false){
        [self deSelectedCell];
    }
    [super setSelected:selected];
}

-(void)selectedCell{
    
}

-(void)deSelectedCell{
    
}




@end
