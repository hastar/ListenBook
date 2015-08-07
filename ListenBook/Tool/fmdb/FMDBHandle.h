//
//  FoodHandle.h
//  HomeCooking
//
//  Created by lanou on 15/6/29.
//  Copyright (c) 2015年 yxy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CollectData.h"
@interface FMDBHandle : NSObject
+ (NSArray *)AllDatas;
+ (CollectData*)collectData:(NSString *)name;
+ (void)addData:(CollectData *)collect;
+ (void)deleteData:(NSString *)name;
+ (BOOL)isHaveData:(NSString *)name;
+ (void)deleteAllDatas;
@end
