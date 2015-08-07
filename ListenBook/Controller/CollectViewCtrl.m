//
//  ThreeViewController.m
//  ListenBook
//
//  Created by lanou on 15/7/15.
//  Copyright (c) 2015年 yxy. All rights reserved.
//

#import "CollectViewCtrl.h"
#import "FMDBHandle.h"
#import "CollectData.h"
#import "DetialBookCtrl.h"
@interface CollectViewCtrl ()<UIAlertViewDelegate>
@property (nonatomic,strong)NSArray *dataArray;
@end

@implementation CollectViewCtrl
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"maoboli-2.jpg"]];
    self.navigationController.navigationBar.tintColor =[UIColor whiteColor];
    self.navigationItem.title = @"我的收藏";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(trashAll)];
}
-(void)trashAll
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"警告" message:@"确定清除所有收藏？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [FMDBHandle deleteAllDatas];
        self.dataArray = [FMDBHandle AllDatas];
        [self.tableView reloadData];
    }
}
-(void)viewDidAppear:(BOOL)animated
{
    self.dataArray = [FMDBHandle AllDatas];
    [self.tableView reloadData];
}
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.backgroundColor = [UIColor clearColor];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    cell.textLabel.text = [self.dataArray[indexPath.row] name];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    DetialBookCtrl *bookCtrl = [[DetialBookCtrl alloc]init];
    bookCtrl.idStr = [self.dataArray[indexPath.row] idStr];
    [self.navigationController pushViewController:bookCtrl animated:YES];
}
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [tableView beginUpdates];
        NSString *name = [self.dataArray[indexPath.row] name];
        [FMDBHandle deleteData:name];
        self.dataArray = [FMDBHandle AllDatas];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        [tableView endUpdates];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
