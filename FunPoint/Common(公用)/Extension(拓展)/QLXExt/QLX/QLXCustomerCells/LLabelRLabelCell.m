//
//  LLabelRLabelCell.m
//  fcuhConsumer
//
//  Created by 邱良雄 on 15/8/12.
//  Copyright (c) 2015年 avatar. All rights reserved.
//

#import "LLabelRLabelCell.h"

@implementation LLabelRLabelCell

-(void)createUI{
    [super createUI];
    // 左边标签
    [self setSeparatorLineShowWithInset:UIEdgeInsetsMake(0, 15, 0, 0)];
    self.leftLbl = [QLXLabel createWithText:@"" hexColorString:@"#333333" fontSize:17];
    self.leftLbl.staticEnable = true;
    [self.view addSubview:self.leftLbl];
    [self.leftLbl mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.view).offset(15);
        make.centerY.equalTo(self.view);
    }];
    
    // 右边标签
    self.rightLbl = [QLXLabel createWithText:@"" hexColorString:@"#999999" fontSize:15];
    self.rightLbl.numberOfLines = 0;
    [self.view addSubview:self.rightLbl];
    [self.rightLbl mas_makeConstraints:^(MASConstraintMaker *make){
        make.right.equalTo(self.view).offset(-15);
        make.centerY.equalTo(self.view);
        make.top.greaterThanOrEqualTo(self.view).offset(17.5);
        make.bottom.greaterThanOrEqualTo(self.view).offset(-17.5);
        make.height.mas_greaterThanOrEqualTo(@15);
        make.left.greaterThanOrEqualTo(self.leftLbl.mas_right).offset(30);
    }];
}

-(void) setContentWithLeftStr:(NSString*) left rigthtStr:(NSString *) right {
    self.leftLbl.text = left;
    self.rightLbl.text = right;
}





@end
