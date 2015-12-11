//
//  QLXHttpModel.m
//  fcuhConsumer
//
//  Created by 邱良雄 on 15/8/20.
//  Copyright (c) 2015年 avatar. All rights reserved.
//

#import "QLXHttpModel.h"
#import "PageBaseParam.h"
#import "PageBaseResult.h"
#import "QLXExt.h"
#import "HTTPBase.h"
@interface QLXHttpModel()

@property (nonatomic, assign) int currentPage;    //当前页
@property (nonatomic, assign) int pageSize;       //每页数目

@property (nonatomic, weak)  AFHTTPRequestOperation * requestOperation;

@end

@implementation QLXHttpModel

-(instancetype)init{
    self = [super init];
    if (self) {
        [self initConfigs];
    }
    return self;
}

-(void) initConfigs{
    self.modelType = HttpModelTypePage;
    self.pageSize = 10;
    // self.totalPage = 10;//待
    self.data = [NSMutableArray new];
}

#pragma mark - 子类重写
//必写
-(BaseParam *) requestParam{
    return [BaseParam param];
}

//必写
-(EHttpRequestCmd) requestCmd{
    assert(0);
    return EHttpRequestCmd_MaxCount;
}

//按照需要写
-(EHttpRequestType) requestType{
    return EHttpRequestTypePost;
}

// -------------分界线----------------
// 子类可继承
- (BOOL) requestDidFinishWithResult:(BaseResult *) result error:(NSError * ) error{
    if (error == nil) {
        if (self.modelType == HttpModelTypePage ) {
            PageBaseResult * pageResult = (PageBaseResult *)result;
            if (self.currentPage == 0) {
                [self.data removeAllObjects];
            }
            self.currentPage++;
            self.totalPage = pageResult.pageCount;
            self.totalCount = pageResult.totalCount;
            [self requestFinishToAddData:result];
        }
        self.resultData = result;
    }
    self.error = error;
    return true;
}

-(void) requestFinishToAddData:(BaseResult *) result{
    PageBaseResult * pageResult = (PageBaseResult *)result;
    [self.data addObjectsFromArray:pageResult.list];
}

//加载
-(void) requestToLoad{
    self.currentPage = 0;
    [self request];
}

//加载更多
-(void) requestToLoadMore{
    [self request];
}

//向服务器请求
-(void) requestToServerWithParam:(BaseParam *) param{
    EHttpRequestCmd cmd = [self requestCmd];
    EHttpRequestType requestType = [self requestType];
    if (cmd < EHttpRequestCmd_MaxCount && param != nil) {
        kBlockWeakSelf;
        if (self.requesting) {
            [self.requestOperation cancel];
        }
        self.requesting = true;
        self.requestOperation = [[HttpRequestTool defaultTool] httpRequestWithCmd:cmd requestType:requestType param:param success:^(BaseResult *result) {
            
            weakSelf.requesting = false;
            BaseResult * modifyResult = [self modifyRequestFinishDataWithResult:result];  // 默认不修改
            if ([weakSelf requestDidFinishWithResult:modifyResult error:nil]) {
                [weakSelf requestFinishWithError:nil];
            }
        } failure:^(NSError *error) {
            if (error.code == (long)-999) {
            }else {
                weakSelf.requesting = false;
                if ([weakSelf requestDidFinishWithResult:nil error:error]) {
                    [weakSelf requestFinishWithError:error.domain];
                }
            }
        }];
    }
}


//请求
-(void) request{
    BaseParam * param = [self requestParam];
    param.timestamp = [HTTPBase shareHttpBase].timeStamp;
    param.token = [HTTPBase shareHttpBase].token;
    if (self.modelType == HttpModelTypePage ) {
        assert([param isKindOfClass:[PageBaseParam class]]);// 需要继承 PageBaseParam 类
        PageBaseParam * pageParam = (PageBaseParam *) param;
        pageParam.page = self.currentPage + 1;
        // pageParam.pageSize = self.pageSize;
    }
    [self requestToServerWithParam:param];
}
// 执行代理方法
-(void) requestFinishWithError:(NSString *) error{
    if ([self.delegate respondsToSelector:@selector(requestDidFinishWithData:hasMore:error:)]) {
        if (self.modelType == HttpModelTypePage) {
            [self.delegate requestDidFinishWithData:self.data hasMore:[self isHaveMore] error:error];
        }else {
            [self.delegate requestDidFinishWithData:self.resultData hasMore:[self isHaveMore] error:error];
        }
        
    }
    
    if ([self.delegate respondsToSelector:@selector(model:requestDidFinishWithData:hasMore:error:)]) {
        if (self.modelType == HttpModelTypePage) {
            [self.delegate model:self requestDidFinishWithData:self.data hasMore:[self isHaveMore] error:error];
            
        }else {
            [self.delegate model:self requestDidFinishWithData:self.resultData hasMore:[self isHaveMore] error:error];
        }
    }
}

-(id) getDataWithIndex:(NSInteger) index{
    return [self.data objectAtIndex:index];
}

-(HttpModelType)modelType{
    return _modelType;
}

-(void)dealloc{
    if (self.requesting) {
        [self.requestOperation cancel];
    }
}

-(BaseResult *) modifyRequestFinishDataWithResult:(BaseResult *)result{
    return result;   // 默认不修改
}

-(BOOL) isHaveMore{
    if (self.resultData) {
        return !self.resultData.noMoreData;
    }
    return false;
}
// 是否请求完毕
+(BOOL) isRequestDoneWithAllModel:(QLXHttpModel *)model , ...{
    BOOL result = true;
    va_list arguments;
    id eachObject;
    if (model) {
        va_start(arguments, model);
        if (model.isRequesting) {
            result = false;
        }
        while ((eachObject = va_arg(arguments, id))) {
            if ([eachObject isKindOfClass:[QLXHttpModel class]]) {
                QLXHttpModel * m = (QLXHttpModel *)eachObject;
                if (m.requesting) {
                    result = false;
                    break;
                }
            }
        }
        va_end(arguments);
    }
    return result;
}
// 获取error
+(NSError *) getErrorWithAllModel:(QLXHttpModel *)model , ...{
    NSError * error = nil;
    va_list arguments;
    id eachObject;
    
    if (model) {
        va_start(arguments, model);
        if (model.error) {
            error = model.error;
        }

        while ((eachObject = va_arg(arguments, id))) {
            if ([eachObject isKindOfClass:[QLXHttpModel class]]) {
                QLXHttpModel * m = (QLXHttpModel *)eachObject;
                if (m.error) {
                    error = m.error;
                    break;
                }
            }
        }
        va_end(arguments);
    }
    return error;
}



@end

