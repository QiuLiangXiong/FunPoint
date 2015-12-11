//
//  QLXHttpRequestManager.h
//  QLXExtDemo
//
//  Created by 邱良雄 on 15/12/1.
//  Copyright © 2015年 avatar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QLXExt.h"

@interface QLXHttpRequestManager : NSObject

singleInstanceDefine

/**
 *  get请求
 *
 *  @param url
 *  @param params
 *  @param success <#success description#>
 *  @param failure <#failure description#>
 *
 *  @return <#return value description#>
 */
- (AFHTTPRequestOperation *)get:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure;

- (AFHTTPRequestOperation *)post:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure;


/*
 *
 *  @brief  下载文件
 *
 *  @param paramDic   附加post参数
 *  @param requestURL 请求地址
 *  @param savedPath  保存 在磁盘的位置
 *  @param success    下载成功回调
 *  @param failure    下载失败回调
 *  @param progress   实时下载进度回调
 *
 *  @return
 */
- (AFHTTPRequestOperation *)downloadFileWithOption:(NSDictionary *)paramDic
                                     withInferface:(NSString*)requestURL
                                         savedPath:(NSString*)savedPath
                                   downloadSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                   downloadFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
                                          progress:(void (^)(float progress))progress;

@end
