//
//  HTTPHeader.m
//  VeryFavorable
//
//  Created by 谭云杰 on 15/3/31.
//  Copyright (c) 2015年 谭云杰. All rights reserved.
//

#import "HTTPBase.h"

@interface HTTPBase()

@property (nonatomic, copy) NSString *uuid;
@property (nonatomic, copy) NSString *appVer;

@end

@implementation HTTPBase

+ (instancetype)shareHttpBase
{
    static HTTPBase *shareHttpBase = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        shareHttpBase = [[self alloc] init];
    });
    
    return shareHttpBase;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.uuid = nil;
    }
    
    return self;
}

- (NSString*)token
{
    return nil;
}

- (NSString *)appId
{
    return nil;
}

- (NSString *)deviceType
{
    return nil;
}

- (NSString *)appVersion
{
    return nil;;
}

- (NSString *)deviceId
{
    return _uuid;
}

- (long)timeStamp
{
    return 0;
}

@end
