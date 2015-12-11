//
//  HttpRequestTool+Http.h
//  fcuhConsumer
//
//  Created by Peter on 15/10/14.
//  Copyright (c) 2015年 avatar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpRequestTool.h"

@interface HttpRequestTool(Http)

- (AFHTTPRequestOperation *)get:(NSString *)url params:(NSDictionary *)params success:(void (^)(id responseObj))success failure:(void (^)(NSError *error))failure;

- (AFHTTPRequestOperation *)post:(NSString *)url params:(NSDictionary *)params success:(void (^)(id responseObj))success failure:(void (^)(NSError *error))failure;

- (AFHTTPRequestOperation *)getWithUrl:(NSString *)url param:(id)param resultClass:(Class)resultClass success:(void (^)(id))success failure:(void (^)(NSError *))failure;

- (AFHTTPRequestOperation *)postWithUrl:(NSString *)url param:(id)param resultClass:(Class)resultClass success:(void (^)(id))success failure:(void (^)(NSError *))failure;

@end
