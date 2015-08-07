//
//  BookModel.m
//  ListenBook
//
//  Created by lanou on 15/7/20.
//  Copyright (c) 2015年 yxy. All rights reserved.
//

#import "BookModel.h"

@implementation BookModel
//-(void)dealloc
//{
//    NSLog(@"BookModel释放了");
//}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}
-(NSString *)description
{
    return  [NSString stringWithFormat:@"%@-%@-%@-%@-%@-%@-%@",_announcer,_name,_lastUpdateTime,_cover,_id,_sections,_hot];
}
@end
