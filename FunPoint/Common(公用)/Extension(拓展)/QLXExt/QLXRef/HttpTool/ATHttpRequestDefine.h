//
//  ATHttpRequestDefine.h
//  fcuhMerchant
//
//  Created by 王永鹏 on 15/4/2.
//  Copyright (c) 2015年 averta. All rights reserved.
//

typedef enum
{
    //首页信息
    EHttpRequestCmd_HomePageBannerList,     //首页banner图片
    EHttpRequestCmd_MaxCount                // Cmd最大数

}EHttpRequestCmd;


#define DRequestCmdKey(cmd) [NSString stringWithFormat:@"%d", cmd]

