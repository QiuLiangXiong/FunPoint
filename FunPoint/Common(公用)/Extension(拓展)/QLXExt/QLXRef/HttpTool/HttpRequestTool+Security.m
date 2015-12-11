//
//  HttpRequestTool+Security.m
//  fcuhConsumer
//
//  Created by Peter on 15/10/14.
//  Copyright (c) 2015年 avatar. All rights reserved.
//

#import "HttpRequestTool+Security.h"

#import <CommonCrypto/CommonHMAC.h>

//#define CC_MD5_DIGEST_LENGTH (32)
#define APP_KEY @"3>0xvZcf4)w=,:b200>|d7VnYqyPF^B"

@implementation HttpRequestTool(Security)

+ (NSString *)generateSignWithDict:(NSDictionary *)params requestURL:(NSString*)url
{
    if([url hasPrefix:@"http://"])
    {
        url = [url substringFromIndex:7];
    }
    else if ([url hasPrefix:@"https://"])
    {
        url = [url substringFromIndex:8];
    }
    
    NSString* appKey = APP_KEY;
    
    NSArray *keys = [params allKeys];
    NSArray *sortedKeys = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSLiteralSearch];
    }];
    NSMutableString *str = [[NSMutableString alloc]init];
    
    if (url) {
        [str appendString:[NSString stringWithFormat:@"%@?", url]];
    }
    
    for (NSString *key in sortedKeys) {
        [str appendString:[NSString stringWithFormat:@"%@=%@&", key, [params objectForKey:key]]];
    }
    //[str deleteCharactersInRange:NSMakeRange([str length]-1, 1)];
    [str appendString:[NSString stringWithFormat:@"%@", appKey]];
    
    return [self MD5:str];
}

+ (NSString*)MD5:(NSString*)inputString
{
    const char* str = [inputString UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (uint32_t)(strlen(str)), result);
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
    {
        [ret appendFormat:@"%02x",result[i]];
    }
    
    return ret;
}

@end
