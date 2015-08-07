
//
//  MyCollectionViewCell.m
//  Lesson21UI
//
//  Created by lanou on 15/6/10.
//  Copyright (c) 2015年 yxy. All rights reserved.
//

#import "MenuViewCell.h"
#import "Header.h"
@implementation MenuViewCell

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
    
        CGFloat w = (SW-50)/4;
        self.picture = [[UIImageView alloc]initWithFrame: CGRectMake(0, 0, w, w)];
        self.picture.backgroundColor = [UIColor yellowColor];
        [self.contentView addSubview:self.picture];
        
        self.title = [[UILabel alloc]initWithFrame:CGRectMake(0, w, w, 30)];
        self.title.font = [UIFont systemFontOfSize:14];
        self.title.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.title];
        
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
    }
    return self;
    
    
    
}



@end
