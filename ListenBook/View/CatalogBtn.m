//
//  CatalogBtn.m
//  ListenBook
//
//  Created by lanou on 15/7/15.
//  Copyright (c) 2015年 yxy. All rights reserved.
//

#import "CatalogBtn.h"
#import "UIImage+NJ.h"
#import "Colours.h"
@implementation CatalogBtn
- (instancetype)initWithFrame:(CGRect)frame AndImageIcon:(NSString*)name AndTitle:(NSString*)title
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIImageView *ImageV = [[UIImageView alloc]initWithFrame:CGRectMake(9, 9, frame.size.height*3/4 - 18, frame.size.height*3/4-18)];
        ImageV.image =[UIImage imageNamed:name];
        ImageV.userInteractionEnabled = NO;
        [self addSubview:ImageV];
        
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, frame.size.height*3/4 , frame.size.width , frame.size.height/4)];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.font = [UIFont systemFontOfSize:14];
        lab.text = title;
        lab.textColor = [UIColor grayColor];
        [self addSubview:lab];
        
        ImageV.center = CGPointMake(lab.center.x, ImageV.center.y);
        
        self.showsTouchWhenHighlighted = YES;
        
        self.layer.cornerRadius = 10;
        self.layer.masksToBounds = YES;
        self.backgroundColor = [UIColor clearColor];
        
        [self addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}
-(void)btnAction:(UIButton*)btn
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%ld",(long)btn.tag],@"tag", nil];

    [[NSNotificationCenter defaultCenter] postNotificationName:@"Btn-BookVC" object:nil userInfo:dic];
}
@end
