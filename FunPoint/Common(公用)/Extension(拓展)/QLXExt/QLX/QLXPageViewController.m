//
//  QLXPageViewController.m
//  QLXExtDemo
//
//  Created by QLX on 15/10/29.
//  Copyright (c) 2015年 avatar. All rights reserved.
//

#import "QLXPageViewController.h"
#import "QLXPageView.h"
#import "QLXSegmentControl.h"
#import "QLXExt.h"
#import "QLXSegmentItem.h"


@implementation QLXPageViewController


-(void)viewDidLoad{
    [super viewDidLoad];
    [self setUpView]; // 配置view
}

-(void) setUpView{
    [self.segmentControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.mas_equalTo(@30);
    }];

    [self.pageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.segmentControl.mas_bottom);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
}
// 分页
-(QLXPageView *)pageView{
    if (!_pageView) {
        _pageView = [QLXPageView new];
        _pageView.pageViewDelegate = self;
        [self.view addSubview:_pageView];
    }
    return _pageView;
}

// 分段 如：标题
-(QLXSegmentControl *)segmentControl{
    if (!_segmentControl) {
        _segmentControl = [QLXSegmentControl new] ;
        _segmentControl.delegate = self;
        _segmentControl.scrollEnable = true;
        [self.view addSubview:_segmentControl];
    }
    return _segmentControl;
}

#pragma mark QLXSegmentControlDelegate

-(void)segmentControl:(QLXSegmentControl *)segment valueChangedWithIndex:(NSInteger)index{
    if (self.pageView.curPage != index) {
        self.pageView.curPage = index;
    }
}

#pragma mark QLXPageViewDelegate

-(NSMutableArray *)pageDataListWithPageView:(QLXPageView *)pageView{
    return self.pageViewModel.data;
}


-(void)pageView:(QLXPageView *)pageView pageChanged:(NSInteger)pageIndex{
     self.segmentControl.selectedIndex = pageIndex;
}



-(void)pageView:(QLXPageView *)pageView scrollPageProgress:(CGFloat)progress fromPage:(NSInteger)index{
    [self.segmentControl scrollSelectBackgroundViewWithProgressValue:progress fromIndex:index];
}


-(void)pageView:(QLXPageView *)pageView scrollProgress:(CGFloat)progress{
    [self.segmentControl scrollContentOffsetWithProgerss:progress];
}

#pragma mark - QLXHttpModelDelegate;

-(void)requestDidFinishWithData:(id)data hasMore:(BOOL)more error:(NSString *)error{
    if (self.segmentControlModel.data == data) {
        [self.segmentControl reloadData];
    }else if(self.pageViewModel.data == data){
        [self.pageView reloadData];
    }
}


#pragma set方法 自动为他们添加代理
-(void)setSegmentControlModel:(QLXHttpModel *)segmentControlModel{
    _segmentControlModel = segmentControlModel;
    _segmentControlModel.delegate = self;
}

-(void)setPageViewModel:(QLXHttpModel *)pageViewModel{
    _pageViewModel = pageViewModel;
    _pageViewModel.delegate = self;
}





@end
