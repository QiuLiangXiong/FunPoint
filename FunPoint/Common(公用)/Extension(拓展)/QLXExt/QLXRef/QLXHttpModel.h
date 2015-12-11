//
//  QLXHttpModel.h
//  fcuhConsumer
//
//  Created by 邱良雄 on 15/8/20.
//  Copyright (c) 2015年 avatar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseResult.h"
#import "BaseParam.h"
#import "HttpTool/HttpRequestTool.h"

typedef  enum{
    HttpModelTypePage,  // 分页数据类型
    HttpModelTypePlain  // 普通类型
}HttpModelType;
@protocol  QLXHttpModelDelegate;

@interface QLXHttpModel : NSObject

@property (nonatomic, assign) HttpModelType modelType;
@property (nonatomic, strong) NSMutableArray * data;            //数据
@property (nonatomic, weak) id<QLXHttpModelDelegate> delegate;
@property (nonatomic, strong) BaseResult * resultData;
@property (nonatomic, assign,getter=isRequesting) BOOL requesting;
@property (nonatomic, assign) int totalCount;     //总数目
@property (nonatomic, assign) int totalPage;      //总页数
@property (nonatomic, strong) NSError * error;
/**
 * 初始化 可被继承
 */
-(void) initConfigs;
/**
 * 加载
 */
-(void) requestToLoad;
/**
 * 加载更多
 */
-(void) requestToLoadMore;
/**
 * 请求参数
 * 可重写
 */
-(BaseParam *) requestParam;
/**
 * 请求命令 get post
 * 一定重写
 */
-(EHttpRequestCmd) requestCmd;
/**
 * 请求方式  get 和 post 两种
 * 可重写
 * 默认 get
 */
-(EHttpRequestType) requestType;

/**
 *  model 类型  分页  和 普通两种 默认为分页
 *
 *  @return
 */
-(HttpModelType)modelType;
/**
 *  请求数据完成回调
 *
 *  @param result 返回数据
 *  @param error  错误信息
 *
 *  @return 是否发送请求数据完成代理
 */
- (BOOL) requestDidFinishWithResult:(BaseResult *) result error:(NSError * ) error;
/**
 *  执行代理  通知 代理
 *
 *  @param error 错误信息
 */
-(void) requestFinishWithError:(NSString *) error;
/**
 *  分页数据 获取
 *
 *  @param index 第几个
 *
 *  @return 该条数据
 */
-(id) getDataWithIndex:(NSInteger) index;


/**
 *  数据请求回来  要添加到数组的时候回调
 *
 *  @param result
 */
-(void) requestFinishToAddData:(BaseResult *) result;

/**
 *  对于服务器传来的数据 可以自己进行修改后在当做服务器的数据  一般用于产生测试数据
 *
 *  @param result
 *
 *  @return 默认不修改
 */
-(BaseResult *) modifyRequestFinishDataWithResult:(BaseResult *)result;


// 是否请求完毕
+(BOOL) isRequestDoneWithAllModel:(QLXHttpModel *)model , ... NS_REQUIRES_NIL_TERMINATION ;
// 获取error
+(NSError *) getErrorWithAllModel:(QLXHttpModel *)model , ... NS_REQUIRES_NIL_TERMINATION;


@end

@protocol QLXHttpModelDelegate <NSObject>

@optional
/**
 *  //请求完成 回调
 *
 *  @param data  请求返回数据
 *  @param more  是否还有更多数据（对于分页数据来说）
 *  @param error 返回的错误信息 如果是有  则为请求失败
 */
-(void) requestDidFinishWithData:(id) data hasMore:(BOOL) more error:(NSString *) error;

-(void) model:(QLXHttpModel *)model requestDidFinishWithData:(id) data hasMore:(BOOL) more error:(NSString *) error;

@end
