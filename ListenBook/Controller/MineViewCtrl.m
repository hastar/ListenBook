//
//  MineViewCtrl.m
//  ListenBook
//
//  Created by lanou on 15/7/15.
//  Copyright (c) 2015年 yxy. All rights reserved.
//

#import "MineViewCtrl.h"
#import "Header.h"
#import "CollectViewCtrl.h"
#import "WdCleanCaches.h"
#import "SDImageCache.h"
#import "AboutUsCtrl.h"
@interface MineViewCtrl ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSArray *array;
@property(nonatomic,strong)NSArray *iconArray;
@end

@implementation MineViewCtrl

-(NSArray *)array
{
    if (!_array) {
        _array = [NSArray arrayWithObjects:@"清除缓存",@"我的收藏",@"关于我们",@"版权声明", nil];
    }
    return _array;
}
-(NSArray *)iconArray
{
    if (!_iconArray) {
        _iconArray = [NSArray arrayWithObjects:@"iconfont-qingchuhuancun",@"iconfont-shoucang",@"iconfont-guanyuwomen",@"iconfont-copyright2", nil];
    }
    return _iconArray;
}
-(void)initTableView{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SW, SH-49) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"关于";
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"maoboli-2.jpg"]];

    [self initTableView];
}
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ID"];
    cell.backgroundColor = [UIColor clearColor];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    if (indexPath.section == 0) {
        cell.textLabel.text = self.array[indexPath.row];
        
        UIImage *markIcon = [UIImage imageNamed:self.iconArray[indexPath.row]];
        markIcon = [markIcon imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        cell.imageView.image = markIcon;
    }
    else{
        cell.textLabel.text = self.array[indexPath.row+2];
        
        UIImage *markIcon = [UIImage imageNamed:self.iconArray[indexPath.row+2]];
        markIcon = [markIcon imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        cell.imageView.image = markIcon;
    }
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (indexPath.row == 0 && indexPath.section==0) {
        double size = [WdCleanCaches sizeWithFilePaht:[WdCleanCaches CachesDirectory]];
        NSString *str = nil;
        if (size <= 5.0)
            str = [NSString stringWithFormat:@"亲，您的缓存只有：%.2lfM，不建议清理",size];
        else if (size <= 10.0)
            str = [NSString stringWithFormat:@"亲，您的缓存已达到：%.2lfM,请及时清理",size];
        else
            str = [NSString stringWithFormat:@"亲，您的缓存已达到：%.2lfM,请立即清理",size];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"是否清理？" message:str delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    }
    
    if (indexPath.row == 1 && indexPath.section==0) {
        CollectViewCtrl *collectVC = [[CollectViewCtrl alloc]init];
        [self.navigationController pushViewController:collectVC animated:YES];
    }
    
    if (indexPath.row == 0 && indexPath.section==1) {
        AboutUsCtrl *us = [[AboutUsCtrl alloc]init];
        us.flag = 0;
        [self.navigationController pushViewController:us animated:YES];
    }
    
    if (indexPath.row == 1 && indexPath.section==1) {
        AboutUsCtrl *us = [[AboutUsCtrl alloc]init];
        us.flag = 1;
        [self.navigationController pushViewController:us animated:YES];
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [[SDImageCache sharedImageCache] clearMemory];
        [[SDImageCache sharedImageCache] clearDisk];
        [WdCleanCaches clearCachesWithFilePath:[WdCleanCaches CachesDirectory]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
