 //
//  HttpRequestTool.m
//  fcuhConsumer
//
//  Created by 王永鹏 on 15/6/9.
//  Copyright (c) 2015年 陈永楚. All rights reserved.
//

#import "HttpRequestTool.h"
#import "MJExtension.h"
#import "HttpRequestTool+Config.h"
#import "HttpRequestTool+Http.h"
#import "QLXExt.h"

@interface HttpRequestTool()
@property (nonatomic, strong)UINavigationController *navView;

@end

@implementation HttpRequestTool
@synthesize customRequestBaseURL = _customRequestBaseURL;
@synthesize severType = _severType;

+ (instancetype)defaultTool
{
    static HttpRequestTool *_defaultTool = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _defaultTool = [[self alloc] init];
    });
    
    return _defaultTool;
}

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        [self loadMapping];
    }
    
    return self;
}

- (AFHTTPRequestOperation *)httpRequestWithCmd:(EHttpRequestCmd)requestCmd requestType:(EHttpRequestType)requestType param:(BaseParam*)param success:(void (^)(BaseResult *result))success failure:(void (^)(NSError *error))failure
{
    AFHTTPRequestOperation *requestOperation = nil;
    
    NSString *requestURL = [self requestURLWithCmd:requestCmd];
    
    Class resultClass = [self.requestCmdAndResultClassMapping objectForKey:DRequestCmdKey(requestCmd)];
    
    if (nil == resultClass)
    {
        NSLog(@"好像返回参数的类型忘记填写或者填写错误了哟。");
        assert(0);
    }
    
    switch (requestType)
    {
        case EHttpRequestTypeGet:
        {//GET请求
            requestOperation = [self getWithUrl:requestURL param:param resultClass:resultClass success:success failure:failure];
        }
        break;
        case EHttpRequestTypePost:
        {//POST请求
            requestOperation = [self postWithUrl:requestURL param:param resultClass:resultClass success:success failure:failure];
        }
        break;
    
        default:
        break;
    }
    
    return requestOperation;
}

-(NSString *)customRequestBaseURL{
    if (!_customRequestBaseURL) {
        _customRequestBaseURL = [[NSUserDefaults standardUserDefaults] objectForKey:@"_customRequestBaseURL"];
        if ([NSURL URLWithString:_customRequestBaseURL] == nil) {
            _customRequestBaseURL = @"http://";
        }
    }
    return _customRequestBaseURL;
}

-(void)setCustomRequestBaseURL:(NSString *)customRequestBaseURL
{
    if ([_customRequestBaseURL isEqualToString:customRequestBaseURL] == false) {
        if ([customRequestBaseURL isUrl]){
            _customRequestBaseURL = customRequestBaseURL;
            [[NSUserDefaults standardUserDefaults] setObject:customRequestBaseURL forKey:@"_customRequestBaseURL"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
}


-(ServerType)severType{
    if (_severType == ServerType_None ) {
      #ifdef DEBUG
        NSInteger value =  [[NSUserDefaults standardUserDefaults] integerForKey:@"_severType"];
        if (value == 0) {
            _severType = ServerType_JDebug;
        }else {
            _severType = (ServerType)value;
        }
      #else
        _severType = ServerType_Release;
      #endif
    }
    return _severType;
}

#ifdef DEBUG
-(void)setSeverType:(ServerType)severType{
    _severType = severType;

    [[NSUserDefaults standardUserDefaults] setInteger:severType forKey:@"_severType"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
#endif

-(NSString *)getServerTypeName{
    NSString * result  ;
    switch (self.severType) {
        case ServerType_Release:
        {
            result = @"正式环境";
            break;
        }
        case ServerType_JDebug:
        {
            result = @"联调环境";
            break;
        }
        case ServerType_Develop:
        {
            result = @"开发环境";
            break;
        }
        case ServerType_Debug:
        {
            result = @"内测环境";
            break;
        }
        case ServerType_Custom:
        {
            result = @"自定义环境";
            break;
        }
        default:
        {
            assert(0);
            break;
        }
    }
    return result;
}




@end
