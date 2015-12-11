//
//  HttpRequestTool+Config.m
//  fcuhConsumer
//
//  Created by Peter on 15/10/14.
//  Copyright (c) 2015年 avatar. All rights reserved.
//

#import "HttpRequestTool+Config.h"




@implementation HttpRequestTool(Config)

- (void)loadMapping
{
    //添加新的请求类型后，请在此字典内增加服务器返回数据的class信息。
    
    self.requestCmdAndResultClassMapping =
    @{
     // DRequestCmdKey(EHttpRequestCmd_HomePageBannerList)      :   [HomePageADBannerResult class],
    };
}

- (NSString*)requestURLWithCmd:(EHttpRequestCmd)requestCmd
{
    
    NSString *result = [self requestHeader];
    
    switch (requestCmd){
        case EHttpRequestCmd_HomePageBannerList:
        {
            result = [result stringByAppendingString:@"city/banner"];
            break;
        }
        default:
            break;
    }
    return result;
}

-(NSString *)requestHeader
{
    NSString *result = @"https://api.user.fcuh.com/v2/";
    // 在 init 函数中修改_severType值来配置服务器地址
    switch (self.severType)
    {
        case ServerType_Release:
            result = @"https://api.user.fcuh.com/v2/";
            break;
        case ServerType_JDebug:
            result = @"http://api.user.jdebug.fcuh.com/v2/";
            break;
        case ServerType_Develop:
            result = @"http://api.user.local.fcuh.com/v2/";
            break;
        case ServerType_Debug:
            result = @"http://api.user.ltest.fcuh.com/v2/";
            break;
        case ServerType_Custom:
            result = [self customRequestBaseURL];
            break;
        default:
            assert(0);// serverType is none
            break;
    }
    return  result;
}


@end
