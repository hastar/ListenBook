//
//  MusicDetailCtrl.h
//  ListenBook
//
//  Created by lanou on 15/7/24.
//  Copyright (c) 2015年 yxy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewCtrl.h"
@interface MusicDetailCtrl : BaseViewCtrl

@property(nonatomic,strong)NSMutableArray *itemArray; //存放节目的数组
@property(nonatomic,assign)NSInteger itemNumber;//节目的索引

@property (strong, nonatomic)UIButton *sYiQuButton;
@property (strong, nonatomic)UIButton *boFangButton;
@property (strong, nonatomic)UIButton *xYiQuButton;

@end
