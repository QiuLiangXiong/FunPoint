//
//  HTTPHeader.h
//  VeryFavorable
//
//  Created by 谭云杰 on 15/3/31.
//  Copyright (c) 2015年 谭云杰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTTPBase : NSObject

@property (nonatomic,readonly) NSString *appId;          //客户端ID（1安卓、2ios、3web）
@property (nonatomic,readonly) NSString *deviceType;        //终端设备类型（1：android 2：iOS 3：web 4：wechat）
@property (nonatomic,readonly) NSString *appVersion;      //版本号
@property (nonatomic,readonly) NSString *deviceId;            //设备号
@property (nonatomic,readonly) NSString *token;          //令牌
@property (nonatomic,readonly) long timeStamp;      //请求的时间戳

+ (instancetype)shareHttpBase;

@end
