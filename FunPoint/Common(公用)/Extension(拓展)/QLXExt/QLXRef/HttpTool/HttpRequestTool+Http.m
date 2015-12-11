//
//  HttpRequestTool+Http.m
//  fcuhConsumer
//
//  Created by Peter on 15/10/14.
//  Copyright (c) 2015年 avatar. All rights reserved.
//

#import "HttpRequestTool+Http.h"
#import "AFNetworking.h"
#import "HttpRequestTool+Security.h"
#import "HttpRequestTool+Error.h"
#import "MJExtension.h"

@implementation HttpRequestTool(Http)

- (AFHTTPRequestOperation *)get:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    // 1.获得请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    // 2.发送GET请求
    AFHTTPRequestOperation *requestOperation =
    [mgr GET:url parameters:params
     success:^(AFHTTPRequestOperation *operation, id responseObj) {
         if (success) {
             success(responseObj);
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         if (failure) {
             failure(error);
         }
     }];
    
    return requestOperation;
}

- (AFHTTPRequestOperation *)post:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    
    // 1.获得请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    // 2.发送POST请求
    AFHTTPRequestOperation *requestOperation =
    [mgr POST:url parameters:params
      success:^(AFHTTPRequestOperation *operation, id responseObj) {
          if (success) {
              success(responseObj);
          }
      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          if (failure) {
              failure(error);
          }
      }];
    
    return requestOperation;
}

- (AFHTTPRequestOperation *)getWithUrl:(NSString *)url param:(id)param resultClass:(Class)resultClass success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    NSMutableDictionary *params = [param mj_keyValues];
    
    NSString* sign = [HttpRequestTool generateSignWithDict:params requestURL:url];
    [params setValue:sign forKey:@"sign"];
    
    AFHTTPRequestOperation *requestOperation =
    [self get:url params:params success:^(id responseObj) {
        
        NSDictionary *rqDic = (NSDictionary *)responseObj;
        
        if (!rqDic) {
            if (failure){
                failure([[NSError alloc] initWithDomain:@"服务器错误" code:(-2) userInfo:nil]);
            }
            return ;
        }
        
//        if ([rqDic objectForKey:@"timestamp"] != nil){
//            NSTimeInterval time = [[rqDic objectForKey:@"timestamp"] doubleValue];
//        }
        
        int code = [[rqDic objectForKey:@"code"] intValue];
        
        if (0 == code){//获取数据成功
            id result = [resultClass mj_objectWithKeyValues:[rqDic objectForKey:@"data"]];
            success(result);
        }
    }
    failure:^(NSError *error) {
        if (failure) {
            failure([[NSError alloc] initWithDomain:@"网络错误，请查看网络是否连接" code:error.code userInfo:nil]);
        }
    }];
    
    return requestOperation;
}

- (AFHTTPRequestOperation *)postWithUrl:(NSString *)url param:(id)param resultClass:(Class)resultClass success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    NSMutableDictionary *params = [param mj_keyValues];
    
    NSString* sign = [HttpRequestTool generateSignWithDict:params requestURL:url];
    [params setValue:sign forKey:@"sign"];
    
    AFHTTPRequestOperation *requestOperation =
    [self post:url params:params success:^(id responseObj) {
        
        if ([responseObj isKindOfClass:[NSData class]])
        {
            responseObj = [NSJSONSerialization
                           JSONObjectWithData:responseObj
                           options:kNilOptions
                           error:nil];
        }
        
        NSDictionary *rqDic = (NSDictionary *)responseObj;
        
        if (!rqDic) {
            
            if (failure)
            {
                failure([[NSError alloc] initWithDomain:@"服务器错误" code:(-2) userInfo:nil]);
            }
            
            return ;
        }
        
       
        
        int code = [[rqDic objectForKey:@"code"] intValue];
        
        if (0 == code){//获取数据成功
            id result = [resultClass mj_objectWithKeyValues:[rqDic objectForKey:@"data"]];
            success(result);
        }else if (5 == code || 7 == code){
            if (failure){
                
                NSString* errMessage = [rqDic objectForKey:@"message"];
                
                NSError *error = [[NSError alloc] initWithDomain:errMessage code:code userInfo:nil];
                
                failure(error);
                
               
            }
        } 
        else{
            if (failure){
                NSString* errMessage = [rqDic objectForKey:@"message"];
                
                failure([[NSError alloc] initWithDomain:errMessage code:code userInfo:nil]);
            }
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure([[NSError alloc] initWithDomain:@"网络错误，请查看网络是否连接" code:error.code userInfo:nil]);
        }
    }];
    
    return requestOperation;
}

@end
