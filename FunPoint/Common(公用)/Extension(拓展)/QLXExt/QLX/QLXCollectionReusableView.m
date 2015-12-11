//
//  QLXCollectionReusableView.m
//  QLXExtDemo
//
//  Created by 邱良雄 on 15/10/22.
//  Copyright (c) 2015年 avatar. All rights reserved.
//

#import "QLXCollectionReusableView.h"
#import "QLXExt.h"

@implementation QLXCollectionReusableView


-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}


- (void)createUI{
    
}

-(void)reuseWithData:(ReuseDataBase *)data section:(NSInteger)section isHeader:(BOOL)bHeader{
    self.data = data;
    self.section = section;
    self.bHeader = bHeader;
}
-(CGFloat) viewHeight{
    self.width = self.collectionView.width;
    [self refreshLayout];
    CGFloat  height = [self systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    self.data.height = height;
    return height;
}

-(void)refresh{
    
}

-(UIView *)view{
    if (!_view) {
        _view = [QLXView createWithBgColor:[UIColor clearColor]];
        [self addSubview:_view];
        [_view constraintWithEdgeZero];
    }
    return _view;
}
@end
