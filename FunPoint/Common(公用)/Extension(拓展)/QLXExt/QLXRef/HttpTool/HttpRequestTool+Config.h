//
//  HttpRequestTool+Config.h
//  fcuhConsumer
//
//  Created by Peter on 15/10/14.
//  Copyright (c) 2015年 avatar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpRequestTool.h"

@interface HttpRequestTool(Config)

- (void)loadMapping;

- (NSString*)requestURLWithCmd:(EHttpRequestCmd)requestCmd;

- (NSString *)requestHeader;

@end
