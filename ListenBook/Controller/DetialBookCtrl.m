//
//  DetialBookCtrl.m
//  ListenBook
//
//  Created by lanou on 15/7/22.
//  Copyright (c) 2015年 yxy. All rights reserved.
//

#import "DetialBookCtrl.h"
#import "BookCell.h"
#import "Header.h"
#import "DetailedModel.h"
#import "DataHandle.h"
#import "UIImageView+WebCache.h"
#import "ContentCell.h"
#import "Colours.h"
#import "AppDelegate.h"
#import "MONActivityIndicatorView.h"
#import "AVplay.h"
#import "MusicDetailCtrl.h"
#import "AVBookModel.h"
#import "FMDBHandle.h"
#import "UMSocial.h"
#import "Reachability.h"
#import "HMNetworkTool.h"

@interface DetialBookCtrl ()
{
    int flag;
}
@property (nonatomic, strong)UIImageView *collect;
@property (nonatomic, strong)DetailedModel *bookInfo;
@property (nonatomic ,strong)NSMutableArray *itemsArray;
@property (nonatomic, strong)MONActivityIndicatorView *indicatorView;
@end

@implementation DetialBookCtrl
-(NSMutableArray *)itemsArray
{
    if (!_itemsArray) {
        _itemsArray = [[NSMutableArray alloc]initWithCapacity:1];
    }
    return _itemsArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BookCell class]) bundle:nil] forCellReuseIdentifier:@"BookCell"];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ContentCell class]) bundle:nil] forCellReuseIdentifier:@"ContentCell"];
    
    self.navigationController.navigationBar.tintColor =[UIColor whiteColor];
    
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
    
    self.tableView.estimatedRowHeight = 44.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"maoboli-2.jpg"]];
    
    flag = 1;
}
-(void)viewDidAppear:(BOOL)animated
{
    if (flag == 1) {
        //申请书的简介数据
        NSString *strUrl = [BookInfo stringByReplacingOccurrencesOfString:@"id=3782" withString:[NSString stringWithFormat:@"id=%@",self.idStr]];
        NSDictionary *dic = [DataHandle DictionaryWithData:[DataHandle DataWithURLStr:strUrl]];
        if (dic == nil)
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"网络连接失败，请检查网络" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            [self.indicatorView stopAnimating];
            return;
        }
        
        self.bookInfo = [[DetailedModel alloc]init];
        [self.bookInfo setValuesForKeysWithDictionary:dic];
        [self.tableView reloadData];
        
        //申请书的音频数据（一次50集）
        NSString *bookUrl = [BaseBook stringByReplacingOccurrencesOfString:@"bookId=3890" withString:[NSString stringWithFormat:@"bookId=%@",self.idStr]];
        NSDictionary *dic1 = [DataHandle DictionaryWithData:[DataHandle DataWithURLStr:bookUrl]];
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.bookInfo.cover]];
        NSMutableArray *arrayBooks = [dic1 objectForKey:@"list"];
        if (arrayBooks.count == 0)
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"网络连接失败，请检查网络" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            [self.indicatorView stopAnimating];
            return;
        }
        for (NSDictionary *itemDic in arrayBooks) {
            AVBookModel *bookModel = [[AVBookModel alloc]init];
            [bookModel setValuesForKeysWithDictionary:itemDic];
            bookModel.book_name = self.bookInfo.name;
            bookModel.image = [UIImage imageWithData:data];
            bookModel.book_url = bookUrl;
            [self.itemsArray addObject:bookModel];
        }
        
        flag = 0;
        
        [self.indicatorView stopAnimating];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        BookCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BookCell" forIndexPath:indexPath];
        UIImageView *imageV = (UIImageView*)[cell viewWithTag:1];
        [imageV sd_setImageWithURL:[NSURL URLWithString:self.bookInfo.cover] placeholderImage:[UIImage imageNamed:@"replace"]];
        
        UILabel *name = (UILabel*)[cell viewWithTag:2];
        name.text = self.bookInfo.name;
        UILabel *type = (UILabel*)[cell viewWithTag:8];
        type.text = self.bookInfo.type;
        UILabel *author = (UILabel*)[cell viewWithTag:10];
        author.text = self.bookInfo.author;
        UILabel *announcer = (UILabel*)[cell viewWithTag:11];
        announcer.text = self.bookInfo.announcer;
        UILabel *state = (UILabel*)[cell viewWithTag:12];
        if ([self.bookInfo.state intValue] == 1)
            state.text = @"连载";
        else
            state.text = @"完结";
        UILabel *sections = (UILabel*)[cell viewWithTag:13];
        sections.text = [self.bookInfo.sections stringValue];
        UILabel *play = (UILabel*)[cell viewWithTag:14];
        if ([self.bookInfo.play intValue] >= 10000) {
            NSString *hotStr = [NSString stringWithFormat:@"%.1f万",[self.bookInfo.play intValue]/10000.0];
            play.text = hotStr;
        }
        else{
            play.text = [self.bookInfo.play stringValue];
        }
        float num = [self.bookInfo.commentMean floatValue];
        int number = (int)num;
        int i;
        for ( i = 0; i < number; i++) {
            UIImageView *star = (UIImageView*)[cell viewWithTag:3+i];
            star.image = [UIImage imageNamed:@"iconfont-iconxing"];
        }
        if (num > (float)number) {
            UIImageView *star1 = (UIImageView*)[cell viewWithTag:3+i];
            UIImageView *starban = [[UIImageView alloc]initWithFrame:star1.bounds];
            starban.image = [UIImage imageNamed:@"iconfont-iconxingban"];
            [star1 addSubview:starban];
        }
        
        cell.backgroundColor = [UIColor clearColor];
        return cell;
    }
    else {
        ContentCell *cell1 = [tableView dequeueReusableCellWithIdentifier:@"ContentCell" forIndexPath:indexPath];
        cell1.selectionStyle = UITableViewCellSelectionStyleNone;
        UILabel *date = (UILabel*)[cell1 viewWithTag:10];
        date.text = self.bookInfo.update;
        UILabel *content = (UILabel*)[cell1 viewWithTag:20];
        content.text = self.bookInfo.desc;
        cell1.backgroundColor = [UIColor clearColor];
        return cell1;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0 && ([HMNetworkTool isEnable3G]||[HMNetworkTool isEnableWIFI])) {
        AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
        [[AVplay shareInstance] putItemsArray:self.itemsArray andItemNumber:0];
        UITabBarController *tabbar = (UITabBarController *)appDelegate.window.rootViewController;
        tabbar.selectedIndex = 2;
        [self popoverPresentationController];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0)
        return 37;
    else
        return 0;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SW, 36)];
    
    UIButton *LBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    LBtn.frame = CGRectMake(0, 0, SW/2, 36);
    [LBtn addTarget:self action:@selector(LBtnAction) forControlEvents:UIControlEventTouchUpInside];
    LBtn.backgroundColor = [UIColor clearColor];
    self.collect = [[UIImageView alloc]initWithFrame:CGRectMake(SW/4-28, 9, 18, 18)];
    
    if ([FMDBHandle isHaveData:self.bookInfo.name]) {
        self.collect.image = [UIImage imageNamed:@"iconfont-wuxingshi"];
        self.collect.tag = 1;
    }
    else
    {
        self.collect.image = [UIImage imageNamed:@"iconfont-wuxingkong"];
        self.collect.tag = 0;
    }
    
    [LBtn addSubview:self.collect];
    
    UILabel *collectL = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.collect.frame)+4, 9, 40, 18)];
    collectL.text= @"收藏";
    [LBtn addSubview:collectL];
    
    //*******************************************************************************
    
    UIButton *RBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    RBtn.frame = CGRectMake(SW/2, 0, SW/2, 36);
    [RBtn addTarget:self action:@selector(RBtnAction) forControlEvents:UIControlEventTouchUpInside];
    RBtn.backgroundColor = [UIColor clearColor];
    UIImageView *share = [[UIImageView alloc]initWithFrame:CGRectMake(SW/4-28, 9, 18, 18)];
    share.image = [UIImage imageNamed:@"iconfont-fenxiangan"];
    [RBtn addSubview:share];
    
    UILabel *shareL = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(share.frame)+4, 9, 40, 18)];
    shareL.text= @"分享";
    [RBtn addSubview:shareL];
    
    //*******************************************************************************
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(LBtn.frame), 4, 1, 29)];
    line.backgroundColor= [UIColor grayColor];
    
    [footerView addSubview:LBtn];
    [footerView addSubview:RBtn];
    [footerView addSubview:line];
    return footerView;
}
-(void)LBtnAction
{
    if (self.collect.tag == 0) {
        if (self.bookInfo.name != nil) {
            CollectData *data = [[CollectData alloc]init];
            self.collect.image = [UIImage imageNamed:@"iconfont-wuxingshi"];
            
            data.name = self.bookInfo.name;
            data.idStr = self.idStr;
            [FMDBHandle addData:data];
            
            self.collect.tag = 1;
        }
    }
    else
    {
        CollectData *data = [[CollectData alloc]init];
        self.collect.image = [UIImage imageNamed:@"iconfont-wuxingkong"];
        
        data.name = self.bookInfo.name;
        data.idStr = self.idStr;
        [FMDBHandle deleteData:data.name];
        
        self.collect.tag = 0;
    }
}
-(void)RBtnAction
{
    if (self.bookInfo.name != nil) {
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.bookInfo.cover]]];
    [UMSocialSnsService presentSnsIconSheetView:self appKey:AppKey shareText:  [self limitLenght:self.bookInfo.desc] shareImage:image shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToTencent,UMShareToRenren, UMShareToDouban, UMShareToFacebook, UMShareToTwitter,  nil] delegate:nil];
    }
}

-(NSString*)limitLenght:(NSString*)str
{
    if ([str length]>=120) {
        str = [[str substringToIndex:120] stringByAppendingString:@"..."];
    }
    return str;
}
//-(void)viewWillAppear:(BOOL)animated
//{
//    self.hidesBottomBarWhenPushed = YES;
//}
@end
