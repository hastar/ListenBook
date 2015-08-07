//
//  HMNetworkTool.h
//  02-网络状态监测（掌握）
//
//  Created by apple on 14-9-22.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HMNetworkTool : NSObject
/**
 *  是否WIFI
 */
+ (BOOL)isEnableWIFI;

/**
 *  是否3G
 */
+ (BOOL)isEnable3G;
@end
