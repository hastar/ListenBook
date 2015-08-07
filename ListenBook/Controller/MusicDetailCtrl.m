//
//  MusicDetailCtrl.m
//  ListenBook
//
//  Created by lanou on 15/7/24.
//  Copyright (c) 2015年 yxy. All rights reserved.
//

#import "MusicDetailCtrl.h"
#import <AVFoundation/AVFoundation.h>
#import "AVplay.h"
#import "Header.h"
#import "AVBookModel.h"
#import "CircleImageModel.h"
#import "UIImageView+WebCache.h"
#import "AppDelegate.h"
#import "MJRefresh.h"
#import "DataHandle.h"
#import "Reachability.h"
#import "HMNetworkTool.h"

// 适配比例
#define KHeightScale ([UIScreen mainScreen].bounds.size.height/667.)
#define KWidthScale ([UIScreen mainScreen].bounds.size.width/375.)


@interface MusicDetailCtrl ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,assign) int flag;
//转动的图片
@property (nonatomic,strong) UIImageView *circleImageView;
//转动图片下的唱片
@property (nonatomic,strong) UIImageView *cpImageView;
//背景图
@property (strong, nonatomic) UIImageView *bacImageView;
//slide进度条
@property (strong,nonatomic) UISlider *slider;

//透明背景蒙版视图
@property (strong,nonatomic) UIView *bacView;

@property (nonatomic,strong) UIPageControl *pageCtrl;

//定义转动图片的定时器
@property (nonatomic,strong) NSTimer *timer;//设置定时器
//观察者
@property (nonatomic,retain) id playbackTimeObserver;

//显示歌曲时间
@property (nonatomic,strong) UILabel *timeLabel;
@property (nonatomic,strong) UILabel *currentTimeLabel;

@property(nonatomic,strong)UITableView *tableView;
@end

@implementation MusicDetailCtrl
static int pagenum = 1;
-(void)initButton
{
    _flag = 0;
    self.boFangButton = [UIButton buttonWithType:UIButtonTypeSystem];
    if (SH < 500) {
        self.boFangButton.frame = CGRectMake(KWidthScale*(375/2-25), 667*KHeightScale-173, 50*KWidthScale, 50*KWidthScale);
    }
    else{
        self.boFangButton.frame = CGRectMake(KWidthScale*(375/2-25), 667*KHeightScale-193, 50*KWidthScale, 50*KWidthScale);
    }
    [self.boFangButton setBackgroundImage:[UIImage imageNamed:@"zanting.png"] forState:UIControlStateNormal];
    [self.boFangButton addTarget:self action:@selector(boFangButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.boFangButton];
    
    self.sYiQuButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.sYiQuButton.frame = CGRectMake(CGRectGetMinX(self.boFangButton.frame)-72, CGRectGetMidY(self.boFangButton.frame)-16, 32*KWidthScale, 32*KWidthScale);
    [self.sYiQuButton setBackgroundImage:[UIImage imageNamed:@"shangyiqu.png"] forState:UIControlStateNormal];
    [self.sYiQuButton addTarget:self action:@selector(sYiQuButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.sYiQuButton];
    
    self.xYiQuButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.xYiQuButton.frame = CGRectMake(CGRectGetMaxX(self.boFangButton.frame)+40, CGRectGetMidY(self.boFangButton.frame)-16, 32*KWidthScale,32*KWidthScale);
    [self.xYiQuButton setBackgroundImage:[UIImage imageNamed:@"xiayiqu.png"] forState:UIControlStateNormal];
    [self.xYiQuButton addTarget:self action:@selector(xYiQuButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.xYiQuButton];
}
#pragma mark 背景图片加转图初始化
-(void)initBacImageView
{
    _bacImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 375*KWidthScale, 667*KHeightScale-49)] ;
    //UIImageView的contentMode为UIViewContentModeScaleAspectFit
    _bacImageView.contentMode = UIViewContentModeScaleAspectFill;
    _bacImageView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:_bacImageView];
    
    //在背景图上面加入了模糊化效果
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *effectview = [[UIVisualEffectView alloc] initWithEffect:blur];
    effectview.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height - 20);
    [_bacImageView addSubview:effectview];
    
    //放在中间
    _cpImageView = [[UIImageView alloc] initWithFrame:CGRectMake(72.5*KWidthScale, 40*KHeightScale, 230*KWidthScale,230*KWidthScale )];
    _cpImageView.image = [UIImage imageNamed:@"changpian.png"];
    
    [self.view addSubview:_cpImageView];
}

-(void)initCircleImageView
{
    self.circleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 375*KWidthScale/3+20, 375*KWidthScale/3+20)];
    self.circleImageView.center = _cpImageView.center;
    //self.circleImageView.backgroundColor = [UIColor whiteColor];
    [self.circleImageView.layer setMasksToBounds:YES];
    self.circleImageView.layer.cornerRadius = (375*KWidthScale/3+20)/2;
    [self.view addSubview:_circleImageView];
}

-(void)initSlider
{
    //进度条
    if (SH < 500) {
        self.slider = [[UISlider alloc] initWithFrame:CGRectMake(35*KWidthScale, 667*KHeightScale-200,300*KWidthScale,20*KHeightScale)];
    }
    else{
        self.slider = [[UISlider alloc] initWithFrame:CGRectMake(35*KWidthScale, 667*KHeightScale-230,300*KWidthScale,20*KHeightScale)];
    }
    self.slider.userInteractionEnabled = NO;
    self.slider.maximumTrackTintColor = [UIColor grayColor];
    self.slider.minimumTrackTintColor = [UIColor whiteColor];
    [self.slider setThumbImage:[UIImage imageNamed:@"yuanshixin.png"] forState:UIControlStateNormal];
    
    
    //在进度条下面加入了模糊化效果
    //UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    //UIVisualEffectView *effectview = [[UIVisualEffectView alloc] initWithEffect:blur];
    //effectview.frame = CGRectMake(0, CGRectGetMidY(self.slider.frame), SW,SH-CGRectGetMidY(self.slider.frame));
    
    //[self.view addSubview:effectview];
    [self.view addSubview:self.slider];
}
-(void)initPage
{
    self.pageCtrl = [[UIPageControl alloc]initWithFrame:CGRectMake(KWidthScale*(375/2-25), CGRectGetMinY(self.slider.frame)-20, 50*KWidthScale, 20*KHeightScale)];
    self.pageCtrl.numberOfPages = 2;
    self.pageCtrl.currentPage = 1;
    self.pageCtrl.currentPageIndicatorTintColor = [UIColor whiteColor];
    self.pageCtrl.pageIndicatorTintColor = [UIColor grayColor];
    [self.view addSubview:self.pageCtrl];
}
-(void)initSongTime
{
    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(340*KWidthScale, CGRectGetMidY(self.slider.frame)-5, 40*KWidthScale, 10*KHeightScale)];
    self.timeLabel.font = [UIFont systemFontOfSize:10*KHeightScale];
    self.timeLabel.textColor = [UIColor whiteColor];
    self.timeLabel.text = @"00:00";
    [self.view addSubview:self.timeLabel];
    
    self.currentTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(5*KWidthScale, CGRectGetMinY(self.timeLabel.frame), 40*KWidthScale, 10*KHeightScale)];
    self.currentTimeLabel.font = [UIFont systemFontOfSize:10*KHeightScale];
    self.currentTimeLabel.textColor = [UIColor whiteColor];
    self.currentTimeLabel.text = @"00:00";
    [self.view addSubview:self.currentTimeLabel];
}
-(void)initTableView{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(-SW,0,SW, CGRectGetMinY(self.pageCtrl.frame)) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    //添加右滑手势
    UISwipeGestureRecognizer *swipeGR = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeGRAction:)];
    swipeGR.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeGR];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"播放";
    //背景图片初始化
    [self initBacImageView];
    
    //初始化圆唱片
    [self initCircleImageView];
    
    //初始化进度条
    [self initSlider];
    
    //初始化button
    [self initButton];
    
    //初始化时间
    [self initSongTime];
    
    //初始化页面控制器
    [self initPage];
    
    //初始化表示图
    [self initTableView];
    
    //设置默认背景
    self.circleImageView.image =  [UIImage imageNamed:@"maoboli-2.jpg"];
    self.bacImageView.image = self.circleImageView.image;
    
    //添加右滑手势
    UISwipeGestureRecognizer *swipeGR = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeGRAction:)];
    swipeGR.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeGR];
    
    // 注册添加播放结束通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(playDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    
    //设置定时器
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.007 target:self selector:@selector(rotationAction) userInfo:nil repeats:YES];
    
    //上下拉刷新
    [self refreshDown];
    [self refreshUp];
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
        //申请书的音频数据（一次50集）
        pagenum++;
        NSString *number = [NSString stringWithFormat:@"pageNum=%d",pagenum];
        AVBookModel *bookMod = self.itemArray[0];
        
        NSString *bookUrl = [bookMod.book_url stringByReplacingOccurrencesOfString:@"pageNum=1" withString:number];
        NSDictionary *dic1 = [DataHandle DictionaryWithData:[DataHandle DataWithURLStr:bookUrl]];
        
        NSMutableArray *arrayBooks = [dic1 objectForKey:@"list"];
        if (arrayBooks.count == 0) {
            pagenum--;
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"亲，断网了或者已经是最后一集了！" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            [self.tableView.footer endRefreshing];
        }
        for (NSDictionary *itemDic in arrayBooks) {
            AVBookModel *bookModel = [[AVBookModel alloc]init];
            [bookModel setValuesForKeysWithDictionary:itemDic];
            bookModel.book_name = bookMod.name;
            bookModel.book_url = bookMod.book_url;
            [self.itemArray addObject:bookModel];
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
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [self.tableView reloadData];
        
        // 拿到当前的下拉刷新控件，结束刷新状态
        [self.tableView.header endRefreshing];
    });
}
-(void)swipeGRAction:(UISwipeGestureRecognizer*)swipeGR
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    
    CGRect rect = self.tableView.frame;
    if (swipeGR.direction == UISwipeGestureRecognizerDirectionLeft) {
        rect.origin.x = -SW;
        self.pageCtrl.currentPage = 1;
        self.circleImageView.alpha = 1.0;
        self.cpImageView.alpha = 1.0;
    }
    else{
        rect.origin.x = 0;
        self.pageCtrl.currentPage = 0;
        self.circleImageView.alpha = 0.0;
        self.cpImageView.alpha = 0.0;
    }
    self.tableView.frame = rect;
    [UIView commitAnimations];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma -mark 播放结束的动作 通知--------------------------------------------
- (void)playDidEnd:(NSNotification *)notification
{
    if ([notification.name isEqualToString:AVPlayerItemDidPlayToEndTimeNotification])
    {
        //移除通知
        [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
        [self.slider addTarget:self action:@selector(changeTime) forControlEvents:UIControlEventTouchUpInside];
        
        NSLog(@"歌曲放完了");
        
        [self xYiQuButton:nil];
        
        //添加通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    }
}
#pragma -mark 播放
- (void)playButtonAction
{
    if (_flag == 0)
    {
        [[AVplay shareInstance] play];
        [_timer setFireDate:[NSDate distantPast]];
    }
    else if(_flag == 1)
    {
        [[AVplay shareInstance] pause];
        [_timer setFireDate:[NSDate distantFuture]];
    }
}

#pragma -mark 上一曲
- (void)sYiQuButton:(id)sender
{
    self.itemNumber -= self.itemNumber;
    if (self.itemNumber <= -1)
    {
        self.itemNumber = self.itemArray.count-1;
    }
    
    if ([HMNetworkTool isEnableWIFI]||[HMNetworkTool isEnable3G]) {
        
        //移除观察者
        [[AVplay shareInstance] removeTimeObserver:self.playbackTimeObserver];
        //播放上一曲
        [[AVplay shareInstance] lastItem:YES];
        
        AVBookModel *ssModel = [[AVBookModel alloc] init];
        ssModel = [AVplay shareInstance].itemsArray[[AVplay shareInstance].itemNumber];
        self.navigationItem.title = ssModel.name;
        
        [self monitoringPlayback:[AVplay shareInstance].playerItem];// 监听播放状态
    }
}

#pragma -mark 下一曲
- (void)xYiQuButton:(id)sender
{
    
    self.itemNumber += self.itemNumber;
    if (self.itemNumber >= self.itemArray.count-1)
    {
        self.itemNumber = 0;
    }
    
    if ([HMNetworkTool isEnableWIFI]||[HMNetworkTool isEnable3G]) {
        
        //移除观察者
        [[AVplay shareInstance] removeTimeObserver:self.playbackTimeObserver];
        //下一曲
        [[AVplay shareInstance] nextItem:YES];
        
        AVBookModel *ssModel = [[AVBookModel alloc] init];
        ssModel = [AVplay shareInstance].itemsArray[[AVplay shareInstance].itemNumber];
        self.navigationItem.title = ssModel.name;
        
        [self monitoringPlayback:[AVplay shareInstance].playerItem];// 监听播放状态
    }
}

#pragma -mark 时间转换 ----------------------------------------------------------------------
- (NSString *)convertTime:(CGFloat)second
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:second];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    if (second/3600 >= 1)
    {
        [formatter setDateFormat:@"HH:mm:ss"];
    } else {
        [formatter setDateFormat:@"mm:ss"];
    }
    NSString *showtimeNew = [formatter stringFromDate:date];
    
    //超过一小时 小时部分需要减8个时区
    if (second/3600 >= 1) {
        NSMutableArray *timeArray = (NSMutableArray *)[showtimeNew componentsSeparatedByString:@":"];
        int HH = [timeArray[0] intValue];
        HH -= 8;
        timeArray[0] = [NSString stringWithFormat:@"%d",HH];
        
        showtimeNew = [timeArray componentsJoinedByString:@":"];
    }
    return showtimeNew;
}

//手动拖动滑块
- (void)changeTime
{
    if ([HMNetworkTool isEnableWIFI]||[HMNetworkTool isEnable3G]) {
        CGFloat percent = self.slider.value/self.slider.maximumValue;
        CGFloat totalSecond = [AVplay shareInstance].playerItem.duration.value/[AVplay shareInstance].playerItem.duration.timescale;
        NSTimeInterval currentTime = totalSecond * percent;
        CMTime ctime = CMTimeMake(currentTime, 1);
        [[AVplay shareInstance].playerItem seekToTime:ctime];
        [[AVplay shareInstance] play];
    }
}

#pragma -mark 观察/调节播放时长 --------------------------------------------------------------
- (void)monitoringPlayback:(AVPlayerItem*)playerItem
{
    __block MusicDetailCtrl *weakSelf = self;
    self.playbackTimeObserver = [[AVplay shareInstance] addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:NULL usingBlock:^(CMTime time) {
        CGFloat currentSecond = playerItem.currentTime.value/playerItem.currentTime.timescale;// 计算当前在第几秒
        CGFloat totalSecond = playerItem.duration.value/playerItem.duration.timescale;
        
        //NSLog(@"current----%f",currentSecond);
        //NSLog(@"totalSecond----%f",totalSecond);
        
        [weakSelf.slider setValue:(currentSecond/totalSecond) animated:YES];
        NSString *timeString = [weakSelf convertTime:currentSecond];
        NSString *totalTimeString = [weakSelf convertTime:totalSecond];
        
        weakSelf.currentTimeLabel.text = [NSString stringWithFormat:@"%@",timeString];
        weakSelf.timeLabel.text = [NSString stringWithFormat:@"%@",totalTimeString];
        //NSLog(@"%@-%@",timeString,totalTimeString);
    }];
}

- (void)boFangButton:(id)sender {
    
    _flag++;
    if (_flag == 2)
    {
        _flag = 0;
    }
    
    if (_flag == 1)
    {
        [sender setBackgroundImage:[UIImage imageNamed:@"bof.png"] forState:UIControlStateNormal];
        [[AVplay shareInstance] pause];
        [_timer setFireDate:[NSDate distantFuture]];
    }
    else
        if (_flag == 0)
        {
            [sender setBackgroundImage:[UIImage imageNamed:@"zanting.png"] forState:UIControlStateNormal];
            [[AVplay shareInstance] play];
            [_timer setFireDate:[NSDate distantPast]];
        }
}
#pragma -mark 定时器方法 -----------------------------------------------------------------------------
- (void)rotationAction
{
    self.circleImageView.transform = CGAffineTransformRotate(self.circleImageView.transform,M_PI/1200);
}

//音乐播放器后台播放
-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (![self.itemArray isEqualToArray:[AVplay shareInstance].itemsArray]) {
        pagenum = 1;
    }
    
    [self changePlayerItem];
    
    //后台相关
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
}

//更换曲目时调用
-(void)changePlayerItem
{
    if ([AVplay shareInstance].itemsArray != nil) {
        
        //移除观察者
        [[AVplay shareInstance] removeTimeObserver:self.playbackTimeObserver];
        
        //播放
        self.itemNumber = [AVplay shareInstance].itemNumber;
        self.itemArray = [AVplay shareInstance].itemsArray;
        
        //监听播放状态
        [self monitoringPlayback:[AVplay shareInstance].playerItem];
        
        [self.slider addTarget:self action:@selector(changeTime) forControlEvents:UIControlEventTouchUpInside];
        self.slider.userInteractionEnabled = YES;
        
        //如果获取不到图片就在本地随机找一张放上去
        AVBookModel *bookModel = self.itemArray[0];
        UIImage *image = bookModel.image;
        self.circleImageView.image = image;
        self.bacImageView.image = self.circleImageView.image;
        
        _flag = 0;
        [self.boFangButton setBackgroundImage:[UIImage imageNamed:@"zanting.png"] forState:UIControlStateNormal];
        [[AVplay shareInstance] play];
        self.navigationItem.title = [self.itemArray[self.itemNumber] name];
        [_timer setFireDate:[NSDate distantPast]];
        
        [self.tableView reloadData];
    }
}
-(void)viewDidDisappear:(BOOL)animated
{
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    [self resignFirstResponder];
    
    [super viewDidDisappear:animated];
}
- (void)remoteControlReceivedWithEvent: (UIEvent *) receivedEvent
{
    if (receivedEvent.type == UIEventTypeRemoteControl) {
        switch (receivedEvent.subtype)
        {
            case UIEventSubtypeRemoteControlPause:
                [self boFangButton:self.boFangButton];
                break;
            case UIEventSubtypeRemoteControlPlay:
                [self boFangButton:self.boFangButton];
                break;
            case UIEventSubtypeRemoteControlPreviousTrack:
                [self sYiQuButton:self.sYiQuButton];
                break;
            case UIEventSubtypeRemoteControlNextTrack:
                [self xYiQuButton:self.xYiQuButton];
                break;
            default:
                break;
        }
    }
}

#pragma mark - table代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.itemArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.backgroundColor = [UIColor  clearColor];
    
    AVBookModel *bookModel = self.itemArray[indexPath.row];
    cell.textLabel.text = bookModel.name;
    cell.textLabel.textColor = [UIColor whiteColor];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    
    self.pageCtrl.currentPage = 1;
    CGRect rect = tableView.frame;
    rect.origin.x = -SW;
    tableView.frame = rect;
    
    self.circleImageView.alpha = 1.0;
    self.cpImageView.alpha = 1.0;
    
    [UIView commitAnimations];
    
    if ([HMNetworkTool isEnable3G]||[HMNetworkTool isEnableWIFI]) {
        [[AVplay shareInstance] putItemsArray:self.itemArray andItemNumber:indexPath.row];
        [self changePlayerItem];
    }
}
@end
