//
//  TableViewController.m
//  ARSegmentPager
//
//  Created by August on 15/3/28.
//  Copyright (c) 2015年 August. All rights reserved.
//

#import "TableViewController.h"
#import "BRFlabbyTableViewCell.h"
#import "UIView+Extension.h"
#import "DataHandle.h"
#import "BookModel.h"
#import "MJRefresh.h"
#import "UIImageView+WebCache.h"
#import "DetialBookCtrl.h"
#import "Header.h"
#import "MONActivityIndicatorView.h"
#import "Reachability.h"
#import "HMNetworkTool.h"

@interface TableViewController ()
@property (strong, nonatomic)NSArray *cellColors;
@property (strong, nonatomic)NSMutableArray *books;
@property (nonatomic, strong)MONActivityIndicatorView *indicatorView;
@end

@implementation TableViewController
static int pagenum = 1;

-(NSMutableArray *)books
{
    if (!_books) {
        _books = [[NSMutableArray alloc]initWithCapacity:1];
    }
    return _books;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.indicatorView = [[MONActivityIndicatorView alloc] init];
    self.indicatorView.numberOfCircles = 5;
    self.indicatorView.radius = 10;
    self.indicatorView.internalSpacing = 6;
    self.indicatorView.duration = 0.5;
    self.indicatorView.delay = 0.2;
    self.indicatorView.center = self.view.center;
    [self.view addSubview:self.indicatorView];
    
    [self refreshDown];
    [self refreshUp];
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BRFlabbyTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"BRFlabbyTableViewCellIdentifier"];
}
#pragma mark UITableView + 下拉刷新 自定义
- (void)refreshDown
{
    [self.tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
}
#pragma mark UITableView + 上拉刷新 自定义
- (void)refreshUp
{
    [self.tableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}
#pragma mark 上拉加载更多数据
- (void)loadMoreData
{
    // 1.添加数据
    pagenum++;
    NSString *number = [NSString stringWithFormat:@"pageNum=%d",pagenum];
    NSString *urlStr1 = [self.urlName  stringByReplacingOccurrencesOfString:@"pageSize=10" withString:@"pageSize=30"];
    NSString *urlStr = [urlStr1 stringByReplacingOccurrencesOfString:@"pageNum=1" withString:number];
    NSDictionary *dic = [DataHandle DictionaryWithData:[DataHandle DataWithURLStr:urlStr]];
    if (dic == nil) {
        pagenum--;
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"请求失败，网路链接异常" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [self.tableView.footer endRefreshing];
        return ;
    }
    NSArray *array = dic[@"list"];
    for (NSDictionary *dic in array) {
        BookModel *book = [[BookModel alloc]init];
        [book setValuesForKeysWithDictionary:dic];
        [self.books addObject:book];
    }
    
    [self.tableView reloadData];
    // 拿到当前的上拉刷新控件，结束刷新状态
    [self.tableView.footer endRefreshing];
}

#pragma mark 下拉刷新数据
- (void)loadNewData
{
    // 1.添加假数据
    // 2.模拟2秒后刷新表格UI（真实开发中，可以移除这段gcd代码）
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [self.tableView reloadData];
        
        // 拿到当前的下拉刷新控件，结束刷新状态
        [self.tableView.header endRefreshing];
    });
}
-(void)getBooksArray:(NSString *)url
{
    [self.books removeAllObjects];
    [[SDImageCache sharedImageCache] clearMemory];
    pagenum = 1;
    NSString *urlStr = [url stringByReplacingOccurrencesOfString:@"pageSize=10" withString:@"pageSize=30"];
    NSDictionary *dic = [DataHandle DictionaryWithData:[DataHandle DataWithURLStr:urlStr]];
    if (dic == nil) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"请求失败，网路链接异常" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return ;
    }
    NSArray *array = dic[@"list"];
    for (NSDictionary *dic in array) {
        BookModel *book = [[BookModel alloc]init];
        [book setValuesForKeysWithDictionary:dic];
        [self.books addObject:book];
    }
    [self.tableView reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [self.books removeAllObjects];
    //[[SDImageCache sharedImageCache] clearDisk];
    [[SDImageCache sharedImageCache] clearMemory];
}

-(NSString *)segmentTitle
{
    return self.title;
}

-(UIScrollView *)streachScrollView
{
    return self.tableView;
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.books.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.tableView.frame.size.width/4;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BRFlabbyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BRFlabbyTableViewCellIdentifier" forIndexPath:indexPath];
    
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    cell.backgroundColor = [UIColor clearColor];
    BookModel *book = self.books[indexPath.row];
    UIImageView *imageV = (UIImageView*)[cell viewWithTag:6];
    [imageV sd_setImageWithURL:[NSURL URLWithString:book.cover] placeholderImage:[UIImage imageNamed:@"801.jpg"]];
    UILabel *label5 = (UILabel*)[cell viewWithTag:5];
    
    label5.text = [self rigthTimerStr:book.lastUpdateTime];
    UILabel *label4 = (UILabel*)[cell viewWithTag:4];
    label4.text = book.announcer;
    UILabel *label3 = (UILabel*)[cell viewWithTag:3];
    if ([book.hot intValue] >= 10000) {
        NSString *hotStr = [NSString stringWithFormat:@"%.1f万",[book.hot intValue]/10000.0];
        label3.text = hotStr;
    }
    else{
        label3.text = [book.hot stringValue];
    }
    UILabel *label2 = (UILabel*)[cell viewWithTag:2];
    label2.text = [book.sections stringValue];
    UILabel *label1 = (UILabel*)[cell viewWithTag:1];
    label1.text = book.name;
    
    return cell;
}
-(NSString*)rigthTimerStr:(NSString*)dateStr
{
    NSDateFormatter * formatter =[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate * date = [formatter dateFromString:dateStr];
    NSDate *nowDate = [NSDate date];
    NSTimeInterval timer = [nowDate timeIntervalSinceDate:date];
    if (timer < 60) {
        return @"刚刚";
    }else if(timer<3600){
        return [NSString stringWithFormat:@"%.f分钟前",timer/60];
    }else if(timer<3600*24){
        return [NSString stringWithFormat:@"%.f小时前",timer/3600];
    }else if(timer<3600*24*3){
        return [NSString stringWithFormat:@"%.f天前",timer/(3600*24)];
    }
    else if(timer<3600*24*30){
        NSString *subStr = [dateStr substringToIndex:10];
        NSString *subStr1 = [subStr substringFromIndex:5];
        return [[subStr1 stringByReplacingOccurrencesOfString:@"-" withString:@"月"] stringByAppendingString:@"日"];
    }
    else{
        NSString *subStr = [dateStr substringToIndex:10];
        return subStr;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetialBookCtrl *bookCtrl = [[DetialBookCtrl alloc]init];
    bookCtrl.idStr = [[self.books[indexPath.row] id] stringValue];
    [self.navigationController pushViewController:bookCtrl animated:YES];
}
@end
