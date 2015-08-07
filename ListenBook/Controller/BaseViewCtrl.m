//
//  BaseViewCtrl.m
//  ListenBook
//
//  Created by lanou on 15/7/15.
//  Copyright (c) 2015年 yxy. All rights reserved.
//

#import "BaseViewCtrl.h"
#import "AppDelegate.h"
#import "Colours.h"
@interface BaseViewCtrl ()

@end

@implementation BaseViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.barTintColor = [UIColor skyBlueColor];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
