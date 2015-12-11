//
//  HttpRequestTool.h
//  fcuhConsumer
//
//  Created by 王永鹏 on 15/6/9.
//  Copyright (c) 2015年 陈永楚. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ATHttpRequestDefine.h"
#import "BaseParam.h"
#import "AFHTTPRequestOperation.h"

@class BaseResult;

typedef enum
{
    EHttpRequestTypeGet, //Get
    EHttpRequestTypePost,//Post
    
}EHttpRequestType;

typedef NS_ENUM(NSUInteger, ServerType)
{
    ServerType_None,    // 默认空环境
    ServerType_Release, // 正式环境
    ServerType_JDebug,  // 联调环境
    ServerType_Develop, // 开发环境
    ServerType_Debug,   // 内测环境
    ServerType_Custom,// 自定义环境
};

@interface HttpRequestTool : NSObject

@property(nonatomic, strong)NSDictionary* requestCmdAndResultClassMapping;
@property (nonatomic, assign) ServerType severType;
@property (nonatomic, copy) NSString * customRequestBaseURL;

+ (instancetype)defaultTool;

/**
 *  获取推荐商家列表
 *
 *  @param  requestCmd  请求接口ID
 *  @param  requestType 网络请求类型，post或get
 *  @param  param       请求参数
 *  @param  success     请求成功后的回调（请将请求成功后想做的事情写到这个block中）
 *  @param  failure     请求失败后的回调（请将请求失败后想做的事情写到这个block中）
 */
- (AFHTTPRequestOperation *)httpRequestWithCmd:(EHttpRequestCmd)requestCmd requestType:(EHttpRequestType)requestType param:(BaseParam*)param success:(void (^)(BaseResult *result))success failure:(void (^)(NSError *error))failure;

/**
 *  获得环境名称
 *
 *  @return 
 */
-(NSString *)getServerTypeName;

@end
