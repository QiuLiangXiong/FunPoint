//
//  QLXCollectionView.m
//  QLXExtDemo
//
//  Created by 邱良雄 on 15/10/21.
//  Copyright (c) 2015年 avatar. All rights reserved.
//

#import "QLXCollectionView.h"
#import "QLXExt.h"
#import "QLXCollectionViewCell.h"
#import "QLXCollectionReusableView.h"
@interface QLXCollectionView()<UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout>

@property (nonatomic, copy) NSString * cellReuseIdentifier;
@property (nonatomic, copy) NSString * headerReuseIdentifier;
@property (nonatomic, copy) NSString * footerReuseIdentifier;

@property (nonatomic, strong) NSMutableDictionary * cacheCellDic;
@property (nonatomic, strong) NSMutableDictionary * cacheHeaderDic;
@property (nonatomic, strong) NSMutableDictionary * cacheFooterDic;

@property (nonatomic, strong) QLXCollectionViewCell * cacheCell; // 用于分页滚动缓着


@end

@implementation QLXCollectionView

+(instancetype) createWithLayout:(UICollectionViewLayout *)layout{
    return [[self alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
}

+(instancetype) createWithFlowLayout{
    return [self createWithLayout:[UICollectionViewFlowLayout new]];
}

-(instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        self.layout = layout;
        [self initConfig];
    }
    return self;
}

-(void) initConfig{
    self.dataSource = self;
    self.delegate = self;
    [self registerCellClass:[QLXCollectionViewCell class]];
}

-(void)registerCellClass:(Class)cellClass {
    assert(cellClass);
    self.cellReuseIdentifier = NSStringFromClass(cellClass);
    [self registerClass:cellClass forCellWithReuseIdentifier:self.cellReuseIdentifier];
}

-(void) registerHeaderClass:(Class) headerClass{
    assert(headerClass);
    self.headerReuseIdentifier = NSStringFromClass(headerClass);
    [self registerClass:headerClass forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:self.headerReuseIdentifier];
}

-(void) registerFooterClass:(Class) footerClass{
    assert(footerClass);
    self.footerReuseIdentifier = NSStringFromClass(footerClass);
    [self registerClass:footerClass forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:self.footerReuseIdentifier];
}

-(void)setRefreshEnable:(BOOL)refreshEnable{
    if (_refreshEnable != refreshEnable) {
        _refreshEnable = refreshEnable;
        if (refreshEnable) {
            [self addRefreshHeaderWithTarget:self refreshingAction:@selector(headerRefresh)];
            [self addRefreshFooterWithTarget:self refreshingAction:@selector(footerRefresh)];
        }else {
            [self removeRefreshHeader];
            [self removeRefreshFooter];
        }
    }
}


-(NSMutableArray *) getSecionDataListWithSection:(NSInteger) section{
    if ([self.dataSourceDelegate respondsToSelector:@selector(cellDataList)]) {
        NSMutableArray * array = [self.dataSourceDelegate cellDataList];
        if (array.count > section) {
            id dataList = [array objectAtIndex:section];
            if (![dataList isKindOfClass:[NSArray class]]) {
                if (section == 0) {
                    return array;
                }else {
                    assert(0); // array 数据单元不是数组
                }
            }else {
                return dataList;
            }
        }else {
            return  nil;
            assert(0); // 数组越界 检查  array
        }
    }else {
        assert(0); // 没实现cellDataList;
    }
    return nil;
}

-(NSInteger)curPage{
    return self.offsetX / self.width + 0.5;
}

-(void)setCurPage:(NSInteger)curPage{
    self.offsetX = curPage * self.width;
}

#pragma mark UICollectionViewDataSourceDelegate


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    if ([self.dataSourceDelegate respondsToSelector:@selector(numberOfSectionsInTableView:)]) {
        return [self.dataSourceDelegate numberOfSectionsInCollectionView:collectionView];
    }else {
        if ([self.dataSourceDelegate respondsToSelector:@selector(cellDataList)]) {
            NSArray * array = [self.dataSourceDelegate cellDataList];
            if (array.count > 0) {
                if ([[array objectAtIndex:0] isKindOfClass:[NSArray class]]) {
                    return array.count;
                }else {
                    return 1;
                }
            }else {
                return 1;
            }
        }
    }
    return 0;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if ([self.dataSourceDelegate respondsToSelector:@selector(collectionView:numberOfItemsInSection:)]) {
        return [self.dataSourceDelegate collectionView:collectionView numberOfItemsInSection:section];
    }else {
        return [self getSecionDataListWithSection:section].count;
    }
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.dataSourceDelegate respondsToSelector:@selector(collectionView:cellForItemAtIndexPath:)]) {
        return [self.dataSourceDelegate collectionView:collectionView cellForItemAtIndexPath:indexPath];
    }else {
        id data = [[self getSecionDataListWithSection:indexPath.section] objectAtIndex:indexPath.row];
        if (data) {
            ReuseDataBase * reuseData = (ReuseDataBase *)data;
            assert([reuseData isKindOfClass:[ReuseDataBase class]]);
            
            NSString * reuseIdentifier = [reuseData reuseIdentifier];
            if (reuseIdentifier == nil) {
                reuseIdentifier = self.cellReuseIdentifier;
            }
            QLXCollectionViewCell * cell = [self dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
            assert(cell && [cell isKindOfClass:[QLXCollectionViewCell class]]); //没有继QLXCollectionViewCell或没有注册
            cell.collectionView = self;
            [cell reuseWithData:reuseData indexPath:indexPath];
            if (!self.pagingEnabled) {
                [cell refreshLayout];
            }
            cell.delegate = self.cellDelegate;
            return cell;
        }
    }
    return nil;
}



// The view that is returned must be retrieved from a call to -dequeueReusableSupplementaryViewOfKind:withReuseIdentifier:forIndexPath:
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if ([self.dataSourceDelegate respondsToSelector:@selector(collectionView:viewForSupplementaryElementOfKind:atIndexPath:)]) {
        return [self.dataSourceDelegate collectionView:collectionView viewForSupplementaryElementOfKind:kind atIndexPath:indexPath];
    }else {
        if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
            return [self getHeaderViewWithIndexPath:indexPath kind:kind];
        }else if([kind isEqualToString:UICollectionElementKindSectionFooter]){
            return [self getFooterViewWithIndexPath:indexPath kind:kind];
        }
   }
    return nil;
}


// private

-(QLXCollectionReusableView *) getHeaderViewWithIndexPath:(NSIndexPath *) indexPath kind:(NSString *)kind{
    if ([self.dataSourceDelegate respondsToSelector:@selector(headerDataList)] && [self.dataSourceDelegate headerDataList]){
        id data = [[self.dataSourceDelegate headerDataList] objectAtIndex:indexPath.section];
        if (data) {
            ReuseDataBase * reuseData = (ReuseDataBase *)data;
            assert([data isKindOfClass:[ReuseDataBase class]]);
            
            NSString * reuseIdentifier = [reuseData reuseIdentifier];
            if (reuseIdentifier == nil) {
                reuseIdentifier = self.headerReuseIdentifier;
            }
            QLXCollectionReusableView * view = [self dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
            assert(view && [view isKindOfClass:[QLXCollectionReusableView class]]);
            view.collectionView = self;
            [view reuseWithData:reuseData section:indexPath.section isHeader:true];
            view.delegate = self.headerDelegate;
            [view refreshLayout];
            return view;
        }
        
    }
    return nil;
}

-(QLXCollectionReusableView *)  getFooterViewWithIndexPath:(NSIndexPath *) indexPath kind:(NSString *)kind{
    if ([self.dataSourceDelegate respondsToSelector:@selector(footerDataList)] && [self.dataSourceDelegate footerDataList]){
        id data = [[self.dataSourceDelegate footerDataList] objectAtIndex:indexPath.section];
        if (data) {
            ReuseDataBase * reuseData = (ReuseDataBase *)data;
            assert([data isKindOfClass:[ReuseDataBase class]]);
            
            NSString * reuseIdentifier = [reuseData reuseIdentifier];
            if (reuseIdentifier == nil) {
                reuseIdentifier = self.footerReuseIdentifier;
            }
            QLXCollectionReusableView * view = [self dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
            assert(view && [view isKindOfClass:[QLXCollectionReusableView class]]);
            view.collectionView = self;
            [view reuseWithData:reuseData section:indexPath.section isHeader:false];
            view.delegate = self.footerDelegate;
            [view refreshLayout];
            return view;
        }
    }
    return nil;
}


#pragma mark UICollectionViewDelegateFlowLayout


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.layoutDelegate respondsToSelector:@selector(collectionView:layout:sizeForItemAtIndexPath:)]) {
        return [self.layoutDelegate collectionView:collectionView layout:collectionViewLayout sizeForItemAtIndexPath:indexPath];
    }else {
        id data = [[self getSecionDataListWithSection:indexPath.section] objectAtIndex:indexPath.row];
        if (data) {
            ReuseDataBase * reuseData = ((ReuseDataBase *)data);
            assert([data isKindOfClass:[ReuseDataBase class]]);//要继承ReuseDataBase
            QLXCollectionViewCell * cacheCell = [self getCacheCellWithReuseIdentifier:[reuseData reuseIdentifier]];
            if (reuseData.height == 0 || reuseData.width == 0) {
                [cacheCell reuseWithData:reuseData indexPath:indexPath];
                CGSize size =  [cacheCell cellSize];
                reuseData.width = size.width;
                reuseData.height = size.height;
                return size;
            }
            return CGSizeMake(reuseData.width, reuseData.height);
        }
    }
    return CGSizeZero;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    if ([self.layoutDelegate respondsToSelector:@selector(collectionView:layout:insetForSectionAtIndex:)]) {
        return [self.layoutDelegate collectionView:collectionView layout:collectionViewLayout insetForSectionAtIndex:section];
    }
    return UIEdgeInsetsMake(0, 0, 0, 0);
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    if ([self.layoutDelegate respondsToSelector:@selector(collectionView:layout:minimumLineSpacingForSectionAtIndex:)]) {
        return [self.layoutDelegate collectionView:collectionView layout:collectionViewLayout minimumLineSpacingForSectionAtIndex:section];
    }
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    if ([self.layoutDelegate respondsToSelector:@selector(collectionView:layout:minimumInteritemSpacingForSectionAtIndex:)]) {
        return [self.layoutDelegate collectionView:collectionView layout:collectionViewLayout minimumInteritemSpacingForSectionAtIndex:section];
    }
    return 0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if ([self.layoutDelegate respondsToSelector:@selector(collectionView:layout:referenceSizeForHeaderInSection:)]) {
        return [self.layoutDelegate collectionView:collectionView layout:collectionViewLayout referenceSizeForHeaderInSection:section];
    }else {
        if ([self.dataSourceDelegate respondsToSelector:@selector(headerDataList)] && [self.dataSourceDelegate headerDataList]) {
            id data = [[self.dataSourceDelegate headerDataList] objectAtIndex:section];
            if (data) {
                ReuseDataBase * reuseData = ((ReuseDataBase *)data);
                assert([data isKindOfClass:[ReuseDataBase class]]);//要继承ReuseDataBase
                
                QLXCollectionReusableView * cacheHeader = [self getCacheHeaderWithReuseIdentifier:[reuseData reuseIdentifier]];
                if (reuseData.height == 0) {
                    [cacheHeader reuseWithData:reuseData section:section isHeader:true];
                    CGFloat height = [cacheHeader viewHeight];
                    reuseData.height = height;
                    return CGSizeMake(self.width, height);
                }
                return CGSizeMake(self.width, reuseData.height);
            }
        }
    }
    return CGSizeZero;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    if ([self.layoutDelegate respondsToSelector:@selector(collectionView:layout:referenceSizeForFooterInSection:)]) {
        return [self.layoutDelegate collectionView:collectionView layout:collectionViewLayout referenceSizeForFooterInSection:section];
    }else {
        if ([self.dataSourceDelegate respondsToSelector:@selector(footerDataList)] && [self.dataSourceDelegate footerDataList]) {
            id data = [[self.dataSourceDelegate footerDataList] objectAtIndex:section];
            if (data) {
                ReuseDataBase * reuseData = ((ReuseDataBase *)data);
                assert([data isKindOfClass:[ReuseDataBase class]]);//要继承ReuseDataBase
                
                QLXCollectionReusableView * cacheFooter = [self getCacheFooterWithReuseIdentifier:[reuseData reuseIdentifier]];
                if (reuseData.height == 0) {
                    [cacheFooter reuseWithData:reuseData section:section isHeader:false];
                    CGFloat height = [cacheFooter viewHeight];
                    reuseData.height = height;
                    return CGSizeMake(self.width, height);
                }
                return CGSizeMake(self.width, reuseData.height);
            }
        }
    }
    return CGSizeZero;
}

// 缓存一个cell 来 测量相应cell 的 size

-(NSMutableDictionary *)cacheCellDic{
    if (!_cacheCellDic) {
        _cacheCellDic = [NSMutableDictionary new];
    }
    return _cacheCellDic;
}

-(NSMutableDictionary *)cacheHeaderDic{
    if (!_cacheHeaderDic) {
        _cacheHeaderDic= [NSMutableDictionary new];
    }
    return _cacheHeaderDic;
}

-(NSMutableDictionary *)cacheFooterDic{
    if (!_cacheFooterDic) {
        _cacheFooterDic = [NSMutableDictionary new];
    }
    return _cacheFooterDic;
}

/**
 *  获得cell 缓存
 */
-(QLXCollectionViewCell *) getCacheCellWithReuseIdentifier:(NSString *)identifier{
    if (identifier == nil) {
        identifier = self.cellReuseIdentifier;
    }
    QLXCollectionViewCell * cacheCell = [self.cacheCellDic objectForKey:identifier];
    if (!cacheCell) {
        [self registerCellClass:NSClassFromString(identifier)];
        cacheCell = [[NSClassFromString(identifier) alloc] init];
        assert(cacheCell);  //identifier 错误 不是类名
        assert([cacheCell isKindOfClass:[QLXCollectionViewCell class]]);
        cacheCell.collectionView = self;
        [self.cacheCellDic setObject:cacheCell forKey:identifier];
    }
    return cacheCell;
}

-(QLXCollectionReusableView *) getCacheHeaderWithReuseIdentifier:(NSString *)identifier{
    if (identifier == nil) {
        identifier = self.headerReuseIdentifier;
    }
    QLXCollectionReusableView * cacheHeader = [self.cacheHeaderDic objectForKey:identifier];
    if (!cacheHeader) {
        [self registerHeaderClass:NSClassFromString(identifier)];
        cacheHeader = [[NSClassFromString(identifier) alloc] init];
        assert(cacheHeader);  //identifier 错误 不是类名
        assert([cacheHeader isKindOfClass:[QLXCollectionReusableView class]]);
        cacheHeader.collectionView = self;
        [self.cacheHeaderDic setObject:cacheHeader forKey:identifier];
    }
    return cacheHeader;
}

-(QLXCollectionReusableView *) getCacheFooterWithReuseIdentifier:(NSString *)identifier{
    if (identifier == nil) {
        identifier = self.footerReuseIdentifier;
    }
    QLXCollectionReusableView * cacheFooter = [self.cacheFooterDic objectForKey:identifier];
    if (!cacheFooter) {
        [self registerFooterClass:NSClassFromString(identifier)];
        cacheFooter = [[NSClassFromString(identifier) alloc] init];
        assert(cacheFooter);  //identifier 错误 不是类名
        assert([cacheFooter isKindOfClass:[QLXCollectionReusableView class]]);
        cacheFooter.collectionView = self;
        [self.cacheFooterDic setObject:cacheFooter forKey:identifier];
    }
    return cacheFooter;
}


//

-(void) addRefreshFooter:(QLXRefreshFooterView *)footer{
    [self addRefreshFooterWithTarget:self refreshingAction:@selector(footerRefresh) footer:footer];
}

-(void) addRefreshHeader:(QLXRefreshHeaderView *)header{
    [self addRefreshHeaderWithTarget:self refreshingAction:@selector(headerRefresh) header:header];
}



-(void) headerRefresh{
    if (self.refreshFooter.resultState == QLXRefreshResultNoMoreData ) {
        [self.refreshFooter endRefreshingWithResult:QLXRefreshResultNoMoreData];
    }else {
        [self.refreshFooter endRefreshingWithResult:QLXRefreshResultSuccess];
    }
    //下拉刷新
    [self refreshCollectionViewDropRefresh:self];
}

-(void) footerRefresh{
    if([self.refreshHeader isRefreshing]){
        [self.refreshHeader endRefreshingWithResult:QLXRefreshResultFail];
    }
    [self refreshCollectionViewUpRefresh:self];
}

-(void) endRefreshWithResult:(QLXRefreshResult) result{
    [self reloadData];
    [self.refreshFooter endRefreshingWithResult:result];
    if([self.refreshHeader isRefreshing]){
        [self.refreshHeader endRefreshingWithResult:result];
    }
}

-(void) beginRefresh{
    [self.refreshFooter endRefreshingWithResult:QLXRefreshResultSuccess];
    [self headerBeginRefresh];
}

-(void) beginRefreshHeader{
    [self.refreshFooter endRefreshingWithResult:QLXRefreshResultSuccess];
    [self headerBeginRefresh];
}

-(void) beginRefreshFooter{
    if ([self.refreshHeader isRefreshing]) {
        [self.refreshHeader endRefreshingWithResult:QLXRefreshResultFail];
    }
    [self footerBeginRefresh];
}

-(void) requestFailure{
    [self endRefreshWithResult:QLXRefreshResultFail];
}

-(void) requestSuccess{
    [self endRefreshWithResult:QLXRefreshResultSuccess];
}

-(void) requestNoMoreData{
    [self endRefreshWithResult:QLXRefreshResultNoMoreData];
}

//下拉刷新
- (void)refreshCollectionViewDropRefresh:(QLXCollectionView *)collectionView{
    if ([self.collectionViewDelegate respondsToSelector:@selector(refreshCollectionViewDropRefresh:)]) {
        [self.collectionViewDelegate refreshCollectionViewDropRefresh:collectionView];
    }
}
//上拉刷新
- (void)refreshCollectionViewUpRefresh:(QLXCollectionView *)collectionView;{
    if ([self.collectionViewDelegate respondsToSelector:@selector(refreshCollectionViewUpRefresh:)]) {
        [self.collectionViewDelegate refreshCollectionViewUpRefresh:collectionView];
    }
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.collectionViewDelegate respondsToSelector:@selector(collectionView:shouldHighlightItemAtIndexPath:)]) {
        return [self.collectionViewDelegate collectionView:collectionView shouldHighlightItemAtIndexPath:indexPath];
    }
    return true;
}

- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.collectionViewDelegate respondsToSelector:@selector(collectionView:didHighlightItemAtIndexPath:)]) {
        [self.collectionViewDelegate collectionView:collectionView didHighlightItemAtIndexPath:indexPath];
    }
    self.highlighted = true;
}

- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.collectionViewDelegate respondsToSelector:@selector(collectionView:didUnhighlightItemAtIndexPath:)]) {
        [self.collectionViewDelegate collectionView:collectionView didUnhighlightItemAtIndexPath:indexPath];
    }
    self.highlighted = false;
}
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.collectionViewDelegate respondsToSelector:@selector(collectionView:shouldSelectItemAtIndexPath:)]) {
        return [self.collectionViewDelegate collectionView:collectionView shouldSelectItemAtIndexPath:indexPath];
    }
    return true;
}
- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.collectionViewDelegate respondsToSelector:@selector(collectionView:shouldDeselectItemAtIndexPath:)]) {
        return [self.collectionViewDelegate collectionView:collectionView shouldDeselectItemAtIndexPath:indexPath];
    }
    return true;
}// called when the user taps on an already-selected item in multi-select mode
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.collectionViewDelegate respondsToSelector:@selector(collectionView:didSelectItemAtIndexPath:)]) {
        [self.collectionViewDelegate collectionView:collectionView didSelectItemAtIndexPath:indexPath];
    }
    
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.collectionViewDelegate respondsToSelector:@selector(collectionView:didDeselectItemAtIndexPath:)]) {
        [self.collectionViewDelegate collectionView:collectionView didDeselectItemAtIndexPath:indexPath];
    }
}


#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if ([self.collectionViewDelegate respondsToSelector:@selector(scrollViewDidScroll:)]) {
        [self.collectionViewDelegate scrollViewDidScroll:scrollView];
    }
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if ([self.collectionViewDelegate respondsToSelector:@selector(scrollViewWillBeginDragging:)]) {
        [self.collectionViewDelegate scrollViewWillBeginDragging:scrollView];
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if ([self.collectionViewDelegate respondsToSelector:@selector(scrollViewDidEndDecelerating:)]) {
        [self.collectionViewDelegate scrollViewDidEndDecelerating:scrollView];
    }
    if (self.adEnable) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(autoMoveNextPage) object:nil];
        [self performSelector:@selector(autoMoveNextPage) withObject:nil afterDelay:2];
    }
}

-(void)selectItemAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated scrollPosition:(UICollectionViewScrollPosition)scrollPosition{
    [super selectItemAtIndexPath:indexPath animated:animated scrollPosition:scrollPosition];
}

-(void)setDelegate:(id<UICollectionViewDelegate>)delegate{
    if (((id)delegate) == self) {
        [super setDelegate:delegate];
    }else {
        self.collectionViewDelegate = (id<QLXCollectionViewDelegate>)delegate;
    }
}

-(void)setAdEnable:(BOOL)adEnable{
    _adEnable = adEnable;
    if (adEnable) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(autoMoveNextPage) object:nil];
        [self performSelector:@selector(autoMoveNextPage) withObject:nil afterDelay:2];
    }else {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(autoMoveNextPage) object:nil];
    }
}

-(void) autoMoveNextPage{
    if (self.adEnable) {
        if(self.isDecelerating == false && self.isTracking == false ){
            
            CGFloat offset =fmax(0,fmin( self.offsetX + self.width,self.contentW - self.width));
            if (self.offsetX + self.width + 1 > self.contentW ) {
                offset = 0;
            }
            [self setContentOffset:CGPointMake(offset, 0) animated:true];
        }
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(autoMoveNextPage) object:nil];
        [self performSelector:@selector(autoMoveNextPage) withObject:nil afterDelay:2];
    }
}

-(void)onExit{
    [super onExit];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(autoMoveNextPage) object:nil];
}
//-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
//    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(autoMoveNextPage) object:nil];
//    [self performSelector:@selector(autoMoveNextPage) withObject:nil afterDelay:2];
//}


//
//- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(8_0);
//- (void)collectionView:(UICollectionView *)collectionView willDisplaySupplementaryView:(UICollectionReusableView *)view forElementKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(8_0);
//- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath;
//- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingSupplementaryView:(UICollectionReusableView *)view forElementOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath;


@end
