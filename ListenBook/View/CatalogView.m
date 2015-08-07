//
//  CatalogView.m
//  ListenBook
//
//  Created by lanou on 15/7/15.
//  Copyright (c) 2015年 yxy. All rights reserved.
//

#import "CatalogView.h"
#import "CatalogBtn.h"
@implementation CatalogView
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        //self.image = [UIImage imageNamed:@"modal_background"];
        
        CatalogBtn *btn1 = [[CatalogBtn alloc]initWithFrame:CGRectMake(4, 6, (frame.size.width-16)/3, frame.size.height/3) AndImageIcon:@"iconfont-ysxs" AndTitle:@"有声小说"];
        btn1.tag = 1;
        [self addSubview:btn1];
        
        CatalogBtn *btn2 = [[CatalogBtn alloc]initWithFrame:CGRectMake(CGRectGetMaxX(btn1.frame)+4, CGRectGetMinY(btn1.frame), CGRectGetWidth(btn1.frame), CGRectGetHeight(btn1.frame)) AndImageIcon:@"iconfont-106" AndTitle:@"综艺娱乐"];
        btn2.tag = 2;
        [self addSubview:btn2];
        
        CatalogBtn *btn3 = [[CatalogBtn alloc]initWithFrame:CGRectMake(CGRectGetMaxX(btn2.frame)+4, CGRectGetMinY(btn2.frame), CGRectGetWidth(btn1.frame), CGRectGetHeight(btn1.frame)) AndImageIcon:@"iconfont-wenxueqimeng" AndTitle:@"文学名著"];
        btn3.tag = 3;
        [self addSubview:btn3];

        CatalogBtn *btn4 = [[CatalogBtn alloc]initWithFrame:CGRectMake(CGRectGetMinX(btn1.frame), CGRectGetMaxY(btn1.frame)+6, CGRectGetWidth(btn1.frame), CGRectGetHeight(btn1.frame)) AndImageIcon:@"iconfont-lingdai" AndTitle:@"职业技能"];
        btn4.tag = 4;
        [self addSubview:btn4];

        CatalogBtn *btn5 = [[CatalogBtn alloc]initWithFrame:CGRectMake(CGRectGetMaxX(btn4.frame)+4, CGRectGetMinY(btn4.frame), CGRectGetWidth(btn1.frame), CGRectGetHeight(btn1.frame)) AndImageIcon:@"iconfont-abcfill" AndTitle:@"外语学习"];
        btn5.tag = 5;
        [self addSubview:btn5];

        CatalogBtn *btn6 = [[CatalogBtn alloc]initWithFrame:CGRectMake(CGRectGetMaxX(btn5.frame)+4, CGRectGetMinY(btn5.frame), CGRectGetWidth(btn1.frame), CGRectGetHeight(btn1.frame)) AndImageIcon:@"iconfont-icon02" AndTitle:@"时事热点"];
        btn6.tag = 6;
        [self addSubview:btn6];
        
        CatalogBtn *btn7 = [[CatalogBtn alloc]initWithFrame:CGRectMake(CGRectGetMinX(btn4.frame), CGRectGetMaxY(btn4.frame)+6, CGRectGetWidth(btn1.frame), CGRectGetHeight(btn1.frame)) AndImageIcon:@"iconfont-shangyerenshi" AndTitle:@"商业财经"];
        btn7.tag = 7;
        [self addSubview:btn7];
        
        CatalogBtn *btn8 = [[CatalogBtn alloc]initWithFrame:CGRectMake(CGRectGetMaxX(btn7.frame)+4, CGRectGetMinY(btn7.frame), CGRectGetWidth(btn1.frame), CGRectGetHeight(btn1.frame)) AndImageIcon:@"iconfont-jiankangyangsheng" AndTitle:@"健康养生"];
        btn8.tag = 8;
        [self addSubview:btn8];
        
        CatalogBtn *btn9 = [[CatalogBtn alloc]initWithFrame:CGRectMake(CGRectGetMaxX(btn8.frame)+4, CGRectGetMinY(btn8.frame), CGRectGetWidth(btn1.frame), CGRectGetHeight(btn1.frame)) AndImageIcon:@"iconfont-gengduo" AndTitle:@"更多"];
        btn9.tag = 9;
        [self addSubview:btn9];

        self.userInteractionEnabled = YES;
    }
    return self;
}
@end
