//
//  TwoViewController.m
//  ListenBook
//
//  Created by lanou on 15/7/15.
//  Copyright (c) 2015年 yxy. All rights reserved.
//

#import "SearchViewCtrl.h"
#import "Header.h"
#import "TableViewController.h"
#import "BRFlabbyTableViewCell.h"
#import "UIView+Extension.h"
#import "DataHandle.h"
#import "BookModel.h"
#import "MJRefresh.h"
#import "UIImageView+WebCache.h"
#import "DetialBookCtrl.h"
#import "MONActivityIndicatorView.h"
#import "Reachability.h"
#import "HMNetworkTool.h"

@interface SearchViewCtrl ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UISearchBar *Myseachbar;
@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)NSString *urlName;
@property (strong, nonatomic)NSMutableArray *books;
@property (nonatomic, strong)MONActivityIndicatorView *indicatorView;
@end

@implementation SearchViewCtrl
static int pagenum = 1;
-(NSMutableArray *)books
{
    if (!_books) {
        _books = [[NSMutableArray alloc]initWithCapacity:1];
    }
    return _books;
}
-(void)initSearchBar{
    self.Myseachbar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, SW, 40)];
    self.Myseachbar.keyboardType = UIKeyboardTypeDefault;
    self.Myseachbar.placeholder = @"书名：如 花千骨／哈哈／追风筝的人／京剧";
    self.Myseachbar.delegate = self;
    self.Myseachbar.hidden = YES;
    self.Myseachbar.barTintColor = [UIColor whiteColor];
    [self.view addSubview:self.Myseachbar];
}
-(void)initTableView{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SW, SH-60) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}
-(void)initIndicatorView{
    self.indicatorView = [[MONActivityIndicatorView alloc] init];
    self.indicatorView.numberOfCircles = 5;
    self.indicatorView.radius = 10;
    self.indicatorView.internalSpacing = 6;
    self.indicatorView.duration = 0.5;
    self.indicatorView.delay = 0.2;
    self.indicatorView.center = self.view.center;
    [self.view addSubview:self.indicatorView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"搜索";
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"maoboli-2.jpg"]];
    UIImage *searchImage = [UIImage imageNamed:@"iconfont-sousuo1"];
    searchImage = [searchImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.rightBarButtonItem  = [[UIBarButtonItem alloc]initWithImage:searchImage style:UIBarButtonItemStylePlain target:self action:@selector(search)];
    
    //初始化表视图
    [self initTableView];
    
    //初始化搜索框
    [self initSearchBar];
    
    //初始化活动指示器
    [self initIndicatorView];
    
    //上下拉刷新
    [self refreshDown];
    [self refreshUp];
    
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BRFlabbyTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"BRFlabbyTableViewCellIdentifier"];
}
#pragma mark UITableView + 下拉刷新 传统
- (void)refreshDown
{
    __weak typeof(self) weakSelf = self;
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    [self.tableView addLegendHeaderWithRefreshingBlock:^{
        [weakSelf loadNewData];
    }];
    
    // 马上进入刷新状态
    [self.tableView.legendHeader beginRefreshing];
}
#pragma mark UITableView + 上拉刷新 传统
- (void)refreshUp
{
    __weak typeof(self) weakSelf = self;
    [self.tableView addLegendFooterWithRefreshingBlock:^{
        [weakSelf loadMoreData];
    }];
    // 马上进入刷新状态
    [self.tableView.legendFooter beginRefreshing];
}
#pragma mark 上拉加载更多数据
- (void)loadMoreData
{
    // 1.添加数据
    pagenum++;
    NSString *number = [NSString stringWithFormat:@"pageNum=%d",pagenum];
    
    NSString *urlStr = [self.urlName stringByReplacingOccurrencesOfString:@"pageNum=1" withString:number];
    NSDictionary *dic = [DataHandle DictionaryWithData:[DataHandle DataWithURLStr:urlStr]];
    if (dic == nil) {
        pagenum--;
        if(pagenum !=1){
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"请求失败，网路链接异常或者没数据" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
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
    for (int i = 0; i<5; i++) {
        // [self.data insertObject:MJRandomData atIndex:0];
    }
    
    // 2.模拟2秒后刷新表格UI（真实开发中，可以移除这段gcd代码）
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [self.tableView reloadData];
        
        // 拿到当前的下拉刷新控件，结束刷新状态
        [self.tableView.header endRefreshing];
    });
}

-(void)search
{
    if (self.Myseachbar.hidden == YES)
        self.Myseachbar.hidden = NO;
    else{
        self.Myseachbar.hidden = YES;
        [self.Myseachbar resignFirstResponder];
    }
}
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton = YES;
    for(id cc in [[searchBar subviews][0] subviews]){
        if([cc isKindOfClass:[UIButton class]]){
            UIButton *btn = (UIButton *)cc;
            [btn setTitle:@"取消"  forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            searchBar.keyboardType = UIKeyboardTypeDefault;
        }
    }
}
-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton = NO;
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    if ([HMNetworkTool isEnableWIFI]||[HMNetworkTool isEnable3G]) {
        NSString *keyWord = [searchBar.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *bookUrl = [SearchBook stringByReplacingOccurrencesOfString:@"%E7%9B%98%E9%BE%99" withString:keyWord];
        self.urlName = bookUrl;
        [self getBooksArray:bookUrl];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"网络连接失败，请检查网络" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    [searchBar resignFirstResponder];
    self.Myseachbar.hidden = YES;
}
- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar{
    [searchBar resignFirstResponder];
    self.Myseachbar.hidden = YES;
}
-(void)getBooksArray:(NSString *)url
{
    [self.books removeAllObjects];
    [[SDImageCache sharedImageCache] clearMemory];
    pagenum = 1;
    NSDictionary *dic = [DataHandle DictionaryWithData:[DataHandle DataWithURLStr:url]];
    
    NSArray *array = dic[@"list"];
    if (array.count == 0) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"对不起，没有相关书籍" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    for (NSDictionary *dic in array) {
        BookModel *book = [[BookModel alloc]init];
        [book setValuesForKeysWithDictionary:dic];
        [self.books addObject:book];
    }
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DetialBookCtrl *bookCtrl = [[DetialBookCtrl alloc]init];
    bookCtrl.idStr = [[self.books[indexPath.row] id] stringValue];
    [self.navigationController pushViewController:bookCtrl animated:YES];
}
@end
