//
//  BookModel.h
//  ListenBook
//
//  Created by lanou on 15/7/20.
//  Copyright (c) 2015年 yxy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BookModel : NSObject
@property(nonatomic,strong)NSString *announcer;
@property(nonatomic,strong)NSString *lastUpdateTime;
@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSString *cover;
@property(nonatomic,strong)NSNumber *id;
@property(nonatomic,strong)NSNumber *sections;
@property(nonatomic,strong)NSNumber *hot;
@end
