//
//  DetialOfMenu.m
//  HomeCooking
//
//  Created by lanou on 15/6/19.
//  Copyright (c) 2015年 yxy. All rights reserved.
//
#import "MenuViewCell.h"
#import "UIImageView+WebCache.h"
#import "SDImageCache.h"
#import "DetialOfMenu.h"
#import "DataHandle.h"
#import "Header.h"
#import "Reachability.h"
#import "HMNetworkTool.h"
#import "MONActivityIndicatorView.h"
@interface DetialOfMenu ()
@property(nonatomic,strong)NSMutableArray *menu;
@property (nonatomic, strong)MONActivityIndicatorView *indicatorView;
@property(nonatomic,assign)int flag;
@end

@implementation DetialOfMenu

static NSString * const reuseIdentifier = @"Cell";

-(NSMutableArray *)menu
{
    if (!_menu) {
        _menu =  [[NSMutableArray alloc]initWithCapacity:1];
    }
    return _menu;
}
-(void)didReceiveMemoryWarning
{
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.tintColor =[UIColor whiteColor];

    self.collectionView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"maoboli-2.jpg"]];
    //**************************  首页视图初始化 *****************************************
    //self.collectionView.backgroundColor = [UIColor colorWithRed:128 green:128 blue:128 alpha:0.92];
    self.collectionView.showsVerticalScrollIndicator = NO;
    //self.navigationController.hidesBarsOnSwipe = YES;
    
    //****************************  注册Cell *******************************************
    [self.collectionView registerClass:[MenuViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    self.flag = 0;
    //活动指示器
    self.indicatorView = [[MONActivityIndicatorView alloc] init];
    self.indicatorView.numberOfCircles = 5;
    self.indicatorView.radius = 10;
    self.indicatorView.internalSpacing = 6;
    self.indicatorView.duration = 0.5;
    self.indicatorView.delay = 0.2;
    self.indicatorView.center = self.view.center;
    [self.view addSubview:self.indicatorView];
    [self.indicatorView startAnimating];
}

-(void)viewDidAppear:(BOOL)animated
{
    if (self.flag == 0) {
        NSDictionary *dic = [DataHandle DictionaryWithData:[DataHandle DataWithURLStr:self.urlStr]];
        self.menu = dic[@"list"];
        if (self.menu.count == 0) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"请求失败，网路链接异常" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
        [self.collectionView reloadData];
        self.flag = 1;
    }
    [self.indicatorView stopAnimating];
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.menu.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MenuViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    NSDictionary *dic = self.menu[indexPath.row];
    cell.title.text = dic[@"name"];
    [cell.picture sd_setImageWithURL:dic[@"cover"] placeholderImage:[UIImage imageNamed:@"800.jpg"]];
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = self.menu[indexPath.row];
    NSString *title = dic[@"name"];
    NSString *idStr = [dic[@"id"] stringValue];
    NSString *urlStr  = [ysxs stringByReplacingOccurrencesOfString:@"type=1" withString:[NSString stringWithFormat:@"type=%@",idStr]];
    self.block(title,urlStr);
    [self.navigationController popViewControllerAnimated:YES];
}
@end
