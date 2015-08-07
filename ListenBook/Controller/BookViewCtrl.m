//
//  OneViewController.m
//  ListenBook
//
//  Created by lanou on 15/7/15.
//  Copyright (c) 2015年 yxy. All rights reserved.
//

#import "BookViewCtrl.h"
#import "Header.h"
#import "CatalogView.h"
#import "CycleScrollView.h"
#import "ARSegmentPageController.h"
#import "TableViewController.h"
#import "UIImage+ImageEffects.h"
#import "DetialBookCtrl.h"
@interface BookViewCtrl ()<ARSegmentControllerDelegate>
@property (nonatomic, strong) NSArray *imageURLs;
@property (nonatomic, strong) CatalogView *catalogView;
@property (nonatomic,strong)  CycleScrollView *mainScorllView;
@end

@implementation BookViewCtrl
- (void)dealloc
{
    //移除通知
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"Btn-BookVC" object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"书城";
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"maoboli-2.jpg"]];
    
    //**********************************  滚动展示区  *******************************************
    NSMutableArray *viewsArray = [@[] mutableCopy];
    NSArray *array = @[@"top12.jpg",@"top16.jpg",@"top8.jpg",@"top13.jpg",@"top9.jpg",@"top15.jpg"];
    for (int i = 0; i < 6; ++i) {
        UIImageView *tempLabel = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SW, SH/4)];
        tempLabel.image = [UIImage imageNamed:array[i]];;
        [viewsArray addObject:tempLabel];
    }
    self.mainScorllView = [[CycleScrollView alloc] initWithFrame:CGRectMake(0, 0,SW, SH/4) animationDuration:4];
    self.mainScorllView.backgroundColor = [[UIColor purpleColor] colorWithAlphaComponent:0.1];
    self.mainScorllView.fetchContentViewAtIndex = ^UIView *(NSInteger pageIndex){
        return viewsArray[pageIndex];
    };
    self.mainScorllView.totalPagesCount = ^NSInteger(void){
        return 6;
    };
    
    __weak BookViewCtrl *WeakSelf = self;
    self.mainScorllView.TapActionBlock = ^(NSInteger pageIndex){
        DetialBookCtrl *bookCtrl = [[DetialBookCtrl alloc]init];
        if (pageIndex == 0) {
            bookCtrl.idStr = MSid;
        }
        if (pageIndex == 1) {
            bookCtrl.idStr = HMid;
        }
        if (pageIndex == 2) {
            bookCtrl.idStr = HHid;
        }
        if (pageIndex == 3) {
            bookCtrl.idStr = JDid;
        }
        if (pageIndex == 4) {
            bookCtrl.idStr = QGid;
        }
        if (pageIndex == 5) {
            bookCtrl.idStr = TSid;
        }
        [WeakSelf.navigationController pushViewController:bookCtrl animated:YES];
    };
    [self.view addSubview:self.mainScorllView];
    
    //*************************************************************************************
    self.catalogView = [[CatalogView alloc]initWithFrame:CGRectMake(0, SH/4+5 , SW, SH*5/12)];
    [self.view addSubview:self.catalogView];
    
    //注册通知（那个页面接收，那个页面注册）
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doNotification:) name:@"Btn-BookVC" object:nil];
}
/**
 *  接收到通知时，跳转到详情页
 *  通知由主页6个按钮发出
 *  @param notification 参数是通知对象
 */
-(void)doNotification:(NSNotification *)notification
{
    ARSegmentPageController *pager = [[ARSegmentPageController alloc] init];
    pager.freezenHeaderWhenReachMaxHeaderHeight = YES;
    pager.segmentMiniTopInset = 64;
    
    NSDictionary *dic = notification.userInfo;
    NSInteger index = [[dic objectForKey:@"tag"] integerValue];
    pager.arrayIndex = index;
    
    [self.navigationController pushViewController:pager animated:YES];
}
-(NSString *)segmentTitle
{
    return @"";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
