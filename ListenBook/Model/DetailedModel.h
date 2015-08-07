//
//  DetailedModel.h
//  ListenBook
//
//  Created by lanou on 15/7/20.
//  Copyright (c) 2015年 yxy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DetailedModel : NSObject
@property(nonatomic,strong)NSString *announcer;
@property(nonatomic,strong)NSString *author;
@property(nonatomic,strong)NSString *desc;
@property(nonatomic,strong)NSString *type;
@property(nonatomic,strong)NSString *update;
@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSString *cover;
@property(nonatomic,strong)NSString *commentMean;

@property(nonatomic,strong)NSNumber *id;
@property(nonatomic,strong)NSNumber *sections;
@property(nonatomic,strong)NSNumber *play;
@property(nonatomic,strong)NSNumber *state;
@property(nonatomic,strong)NSNumber *commentCount;

@property(nonatomic,strong)NSDictionary *user;
@end
