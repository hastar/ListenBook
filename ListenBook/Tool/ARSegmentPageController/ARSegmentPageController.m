//
//  ARSegmentPageController.m
//  ARSegmentPager
//
//  Created by August on 15/3/28.
//  Copyright (c) 2015年 August. All rights reserved.
//

#import "ARSegmentPageController.h"
#import "ARSegmentView.h"
#import "TableViewController.h"
#import "CHTumblrMenuView.h"
#import "DataHandle.h"
#import "Header.h"
#import "DetialOfMenu.h"
#import "AppDelegate.h"
#import "MONActivityIndicatorView.h"
#import "Colours.h"
#import "Reachability.h"
#import "HMNetworkTool.h"

const void* _ARSEGMENTPAGE_CURRNTPAGE_SCROLLVIEWOFFSET = &_ARSEGMENTPAGE_CURRNTPAGE_SCROLLVIEWOFFSET;

@interface ARSegmentPageController ()
@property (nonatomic, strong) UIView<ARSegmentPageControllerHeaderProtocol> *headerView;
@property (nonatomic, strong) ARSegmentView *segmentView;
@property (nonatomic, strong) NSMutableArray *controllers;
@property (nonatomic, assign) CGFloat segmentToInset;

@property (nonatomic, weak) UIViewController<ARSegmentControllerDelegate> *currentDisplayController;
@property (nonatomic, strong) NSLayoutConstraint *headerHeightConstraint;

@property (nonatomic,strong)NSArray *bookListArray;
@property (nonatomic,strong)NSString *title;
@property (nonatomic,strong)NSDictionary *urlDic;
@property (nonatomic,strong)NSDictionary *urlTopDic;
@property (nonatomic,strong)NSString *currentUrl;
@property (nonatomic,strong)NSDictionary *imageDic;
@property (nonatomic,strong)NSString *urlTop;
@property (nonatomic,strong)NSArray *headerImageArray;
@property (nonatomic)int flag;
@property (nonatomic,strong)MONActivityIndicatorView *indicatorView;
@end

@implementation ARSegmentPageController
-(NSArray *)headerImageArray
{
    if (!_headerImageArray) {
        _headerImageArray = [[NSArray alloc]initWithObjects:@"",@"header5.jpg",@"header8.jpg",@"header9.jpg",@"header10.jpg",@"header11.jpg",@"header7.jpg",@"header12.jpg",@"header13.jpg",@"header6.jpg",@"header15.jpg",@"header14.jpg",@"header16.jpg",@"header17.jpg",@"header4.jpg", nil];
    }
    return _headerImageArray;
}
-(NSArray *)bookListArray
{
    if (!_bookListArray) {
        _bookListArray = [[NSArray alloc]initWithObjects:@"",@"有声小说",@"综艺娱乐",@"文学名著",@"职业技能",@"外语学习",@"时事热点",@"商业财经",@"健康养生",@"时尚生活",@"少儿天地",@"曲艺戏曲",@"相声评书",@"静夜思听",@"人文社科", nil];
    }
    return _bookListArray;
}
-(NSDictionary *)urlDic
{
    if (!_urlDic) {
        _urlDic = [NSDictionary dictionaryWithObjectsAndKeys:ysxs,@"有声小说",zyyl,@"综艺娱乐",wxmz,@"文学名著",zyjn,@"职业技能",wyxx,@"外语学习",ssrd,@"时事热点",sycj,@"商业财经",jkys,@"健康养生",sssh,@"时尚生活",setd,@"少儿天地",qyxq,@"曲艺戏曲",xsps,@"相声评书",jyst,@"静夜思听",rwsk,@"人文社科", nil];
    }
    return _urlDic;
}
-(NSDictionary *)urlTopDic
{
    if (!_urlTopDic) {
        _urlTopDic = [NSDictionary dictionaryWithObjectsAndKeys:ysxstop,@"有声小说",zyyltop,@"综艺娱乐",wxmztop,@"文学名著",zyjntop,@"职业技能",wyxxtop,@"外语学习",ssrdtop,@"时事热点",sycjtop,@"商业财经",jkystop,@"健康养生",ssshtop,@"时尚生活",setdtop,@"少儿天地",qyxqtop,@"曲艺戏曲",xspstop,@"相声评书",jysttop,@"静夜思听",rwsktop,@"人文社科", nil];
    }
    return _urlTopDic;
}
-(NSDictionary *)imageDic
{
    if (!_imageDic) {
        _imageDic = [NSDictionary dictionaryWithObjectsAndKeys:@"iconfont-ysxs.png",@"有声小说",@"iconfont-106.png",@"综艺娱乐",@"iconfont-wenxueqimeng.png",@"文学名著",@"iconfont-lingdai.png",@"职业技能",@"iconfont-abcfill.png",@"外语学习",@"iconfont-icon02.png",@"时事热点",@"iconfont-shangyerenshi.png",@"商业财经",@"iconfont-jiankangyangsheng.png",@"健康养生",@"iconfont-shishangfushi.png",@"时尚生活",@"iconfont-muma.png",@"少儿天地",@"iconfont-kuaiban.png",@"曲艺戏曲",@"iconfont-fzst-ping.png",@"相声评书",@"iconfont-yezonghui.png",@"静夜思听",@"iconfont-feiyongkemu.png",@"人文社科", nil];
    }
    return _imageDic;
}
-(instancetype)initWithControllers:(UIViewController<ARSegmentControllerDelegate> *)controller, ...
{
    self = [super init];
    if (self) {
        NSAssert(controller != nil, @"the first controller must not be nil!");
        [self _setUp];
        UIViewController<ARSegmentControllerDelegate> *eachController;
        va_list argumentList;
        if (controller)
        {
            [self.controllers addObject: controller];
            va_start(argumentList, controller);
            while ((eachController = va_arg(argumentList, id)))
            {
                [self.controllers addObject:eachController];
            }
            va_end(argumentList);
        }
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self _setUp];
    }
    return self;
}

-(instancetype)init
{
    self = [super init];
    if (self) {
        [self _setUp];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImage *leftBarButton = [UIImage imageNamed:@"iconfont-fanhui"];
    leftBarButton = [leftBarButton imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:leftBarButton style:UIBarButtonItemStylePlain target:self action:@selector(leftAction)];
    
    UIImage *rightBarButton = [UIImage imageNamed:@"iconfont-mulu@2x"];
    rightBarButton = [rightBarButton imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:rightBarButton style:UIBarButtonItemStylePlain target:self action:@selector(pushToCatalogue)];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"maoboli-2.jpg"]];
    //*********************************************************************
    
    TableViewController *table = [[TableViewController alloc]init];
    table.title = @"推荐";
    TableViewController *table1 = [[TableViewController alloc]init];
    table1.title = @"最新";
    TableViewController *table2 = [[TableViewController alloc]init];
    table2.title = @"热门";
    [self setViewControllers:@[table,table1,table2]];
    
    //*********************************************************************
    
    [self _baseConfigs];
    [self _baseLayout];
    if (self.arrayIndex == 9) {
        [self showMenu];
    }
    self.flag = 1;
    
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
    
    self.headerView.imageV.image = [UIImage imageNamed:@"header6.jpg"];
}
-(void)viewDidAppear:(BOOL)animated
{
    if (self.arrayIndex != 9 && self.flag == 1){
        self.flag = 0;
        self.title = [self.bookListArray objectAtIndex:self.arrayIndex];
        self.urlTop = self.urlTopDic[self.title];
        self.navigationItem.title = self.title;
        self.currentUrl = [self.urlDic objectForKey:self.title];
        self.headerView.imageV.image = [UIImage imageNamed:self.headerImageArray[self.arrayIndex]];
        [self setCurrentUrlForTableViews];
    }
    [self.indicatorView stopAnimating];
}
-(void)leftAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)pushToCatalogue
{
    if (self.title == nil) {
        return;
    }
    
    CGFloat w = (SW-50)/4;
    
    UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc]init];
    flowlayout.itemSize = CGSizeMake(w, w+30);
    flowlayout.minimumInteritemSpacing = 5;
    flowlayout.minimumLineSpacing = 10;
    flowlayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowlayout.sectionInset = UIEdgeInsetsMake(20, 10, 30, 10);//上、左、下、右
    
    DetialOfMenu *detailOfMenu = [[DetialOfMenu alloc]initWithCollectionViewLayout:flowlayout];
    detailOfMenu.urlStr = self.urlTop;
    __weak typeof(self) weakSelf = self;
    detailOfMenu.block = ^(NSString *title,NSString *urlStr){
        weakSelf.title = title;
        weakSelf.currentUrl = urlStr;
        [weakSelf setCurrentUrlForTableViews];
    };
    
    [self.navigationController pushViewController:detailOfMenu animated:YES];
}
-(void)setCurrentUrlForTableViews
{
    if([HMNetworkTool isEnableWIFI]||[HMNetworkTool isEnable3G]){
        //推荐table
        [self.controllers[0] setUrlName:self.currentUrl];
        [self.controllers[0] getBooksArray:self.currentUrl];
        //最新table
        NSString *zxUrl = [self.currentUrl stringByReplacingOccurrencesOfString:@"sort=2" withString:@"sort=1"];
        [self.controllers[1] setUrlName:zxUrl];
        [self.controllers[1] getBooksArray:zxUrl];
        //热门table
        NSString *rmUrl = [self.currentUrl stringByReplacingOccurrencesOfString:@"sort=2" withString:@"sort=0"];
        [self.controllers[2] setUrlName:rmUrl];
        [self.controllers[2] getBooksArray:rmUrl];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"请求失败，网路链接异常" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
}
- (void)showMenu
{
    __weak typeof(self) weakSelf = self;
    CHTumblrMenuView *menuView = [[CHTumblrMenuView alloc] init];
    for (NSString *title in self.imageDic) {
        [menuView addMenuItemWithTitle:title andIcon:[UIImage imageNamed:self.imageDic[title]] andSelectedBlock:^{
            weakSelf.title = title;
            weakSelf.urlTop = weakSelf.urlTopDic[weakSelf.title];
            weakSelf.currentUrl = [weakSelf.urlDic objectForKey:weakSelf.title];
            [weakSelf setCurrentUrlForTableViews];
        }];
    }
    [menuView addMenuItemWithTitle:@"退出" andIcon:[UIImage imageNamed:@"iconfont-tuichu"] andSelectedBlock:^{
        weakSelf.title = @"有声小说";
        weakSelf.currentUrl = [weakSelf.urlDic objectForKey:@"有声小说"];
        [weakSelf setCurrentUrlForTableViews];
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
    [menuView show];
}
#pragma mark - public methods

-(void)setViewControllers:(NSArray *)viewControllers
{
    [self.controllers removeAllObjects];
    [self.controllers addObjectsFromArray:viewControllers];
}

#pragma mark - override methods

-(UIView<ARSegmentPageControllerHeaderProtocol> *)customHeaderView
{
    return [[ARSegmentPageHeader alloc] init];
}

#pragma mark - private methdos

-(void)_setUp
{
    self.headerHeight = SW /2;
    self.segmentHeight = 44;
    self.segmentToInset = SW /2;
    self.segmentMiniTopInset = 0;
    self.controllers = [NSMutableArray array];
}
-(void)_baseConfigs
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    if ([self.view respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        self.view.preservesSuperviewLayoutMargins = YES;
    }
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.headerView = [self customHeaderView];
    self.headerView.clipsToBounds = YES;
    
    [self.view addSubview:self.headerView];
    
    self.segmentView = [[ARSegmentView alloc] init];
    self.segmentView.barTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"maoboli-2.jpg"]];
    self.segmentView.tintColor = [UIColor skyBlueColor];
    [self.segmentView.segmentControl addTarget:self action:@selector(segmentControlDidChangedValue:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.segmentView];
    
    //all segment title and controllers
    [self.controllers enumerateObjectsUsingBlock:^(UIViewController<ARSegmentControllerDelegate> *controller, NSUInteger idx, BOOL *stop) {
        NSString *title = [controller segmentTitle];
        
        [self.segmentView.segmentControl insertSegmentWithTitle:title
                                                        atIndex:idx
                                                       animated:NO];
    }];
    
    self.segmentView.segmentControl.selectedSegmentIndex = 0;
    UIViewController<ARSegmentControllerDelegate> *controller = self.controllers[0];
    [controller willMoveToParentViewController:self];
    [self.view insertSubview:controller.view atIndex:0];
    [self addChildViewController:controller];
    [controller didMoveToParentViewController:self];
    
    [self _layoutControllerWithController:controller];
    [self addObserverForPageController:controller];
    
    self.currentDisplayController = self.controllers[0];
}

-(void)_baseLayout
{
    //header
    self.headerView.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.headerHeightConstraint = [NSLayoutConstraint constraintWithItem:self.headerView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1 constant:self.headerHeight];
    [self.headerView addConstraint:self.headerHeightConstraint];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.headerView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.headerView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.headerView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
    
    //segment
    self.segmentView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.segmentView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.segmentView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.segmentView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.headerView attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    
    [self.segmentView addConstraint:[NSLayoutConstraint constraintWithItem:self.segmentView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1 constant:self.segmentHeight]];
}

-(void)_layoutControllerWithController:(UIViewController<ARSegmentControllerDelegate> *)pageController
{
    UIView *pageView = pageController.view;
    if ([pageView respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        pageView.preservesSuperviewLayoutMargins = YES;
    }
    pageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:pageView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:pageView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]];
    
    UIScrollView *scrollView = [self scrollViewInPageController:pageController];
    if (scrollView) {
        scrollView.alwaysBounceVertical = YES;
        CGFloat topInset = self.headerHeight+self.segmentHeight;
        //fixed bootom tabbar inset
        CGFloat bottomInset = 0;
        if (self.tabBarController.tabBar.hidden == NO) {
            bottomInset = CGRectGetHeight(self.tabBarController.tabBar.bounds);
        }
        
        [scrollView setContentInset:UIEdgeInsetsMake(topInset, 0, bottomInset, 0)];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:pageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:pageView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    }else{
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:pageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.segmentView attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:pageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeHeight multiplier:1 constant:-self.segmentHeight]];
    }
    
}

-(UIScrollView *)scrollViewInPageController:(UIViewController <ARSegmentControllerDelegate> *)controller
{
    if ([controller respondsToSelector:@selector(streachScrollView)]) {
        return [controller streachScrollView];
    }else if ([controller.view isKindOfClass:[UIScrollView class]]){
        return (UIScrollView *)controller.view;
    }else{
        return nil;
    }
}

#pragma mark - add / remove obsever for page scrollView

-(void)addObserverForPageController:(UIViewController <ARSegmentControllerDelegate> *)controller
{
    UIScrollView *scrollView = [self scrollViewInPageController:controller];
    if (scrollView != nil) {
        [scrollView addObserver:self forKeyPath:NSStringFromSelector(@selector(contentOffset)) options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:&_ARSEGMENTPAGE_CURRNTPAGE_SCROLLVIEWOFFSET];
    }
}

-(void)removeObseverForPageController:(UIViewController <ARSegmentControllerDelegate> *)controller
{
    UIScrollView *scrollView = [self scrollViewInPageController:controller];
    if (scrollView != nil) {
        @try {
            [scrollView removeObserver:self forKeyPath:NSStringFromSelector(@selector(contentOffset))];
        }
        @catch (NSException *exception) {
            NSLog(@"exception is %@",exception);
        }
        @finally {
            
        }
    }
}

#pragma mark - obsever delegate methods

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == _ARSEGMENTPAGE_CURRNTPAGE_SCROLLVIEWOFFSET) {
        //NSLog(@"offset: %@\nheader: %f\nmini inset = %f", change, self.headerHeightConstraint.constant, self.segmentToInset);
        CGPoint offset = [change[NSKeyValueChangeNewKey] CGPointValue];
        CGFloat offsetY = offset.y;
        CGPoint oldOffset = [change[NSKeyValueChangeOldKey] CGPointValue];
        CGFloat oldOffsetY = oldOffset.y;
        CGFloat deltaOfOffsetY = offset.y - oldOffsetY;
        CGFloat offsetYWithSegment = offset.y + self.segmentHeight;
        
        if (deltaOfOffsetY > 0) {
            // 当滑动是向上滑动时
            // 跟随移动的偏移量进行变化
            // NOTE:直接相减有可能constant会变成负数，进而被系统强行移除，导致header悬停的位置错乱或者crash
            if (self.headerHeightConstraint.constant - deltaOfOffsetY <= 0) {
                self.headerHeightConstraint.constant = self.segmentMiniTopInset;
            } else {
                self.headerHeightConstraint.constant -= deltaOfOffsetY;
            }
            // 如果到达顶部固定区域，那么不继续滑动
            if (self.headerHeightConstraint.constant <= self.segmentMiniTopInset) {
                self.headerHeightConstraint.constant = self.segmentMiniTopInset;
            }
        } else {
            // 当向下滑动时
            // 如果列表已经滚动到屏幕上方
            // 那么保持顶部栏在顶部
            if (offsetY > 0) {
                if (self.headerHeightConstraint.constant <= self.segmentMiniTopInset) {
                    self.headerHeightConstraint.constant = self.segmentMiniTopInset;
                }
            } else {
                // 如果列表顶部已经进入屏幕
                // 如果顶部栏已经到达底部
                if (self.headerHeightConstraint.constant >= self.headerHeight) {
                    // 如果当前列表滚到了顶部栏的底部
                    // 那么顶部栏继续跟随变大，否这保持不变
                    if (-offsetYWithSegment > self.headerHeight) {
                        self.headerHeightConstraint.constant = -offsetYWithSegment;
                    } else {
                        self.headerHeightConstraint.constant = self.headerHeight;
                    }
                } else {
                    // 在顶部拦未到达底部的情况下
                    // 如果列表还没滚动到顶部栏底部，那么什么都不做
                    // 如果已经到达顶部栏底部，那么顶部栏跟随滚动
                    if (self.headerHeightConstraint.constant < -offsetYWithSegment) {
                        self.headerHeightConstraint.constant -= deltaOfOffsetY;
                    }
                }
            }
        }
        // 更新 `segmentToInset` 变量，让外部的 kvo 知道顶部栏位置的变化
        self.segmentToInset = self.headerHeightConstraint.constant;
    }
}

#pragma mark - event methods

-(void)segmentControlDidChangedValue:(UISegmentedControl *)sender
{
    //remove obsever
    [self removeObseverForPageController:self.currentDisplayController];
    
    //add new controller
    NSUInteger index = [sender selectedSegmentIndex];
    UIViewController<ARSegmentControllerDelegate> *controller = self.controllers[index];
    
    [self.currentDisplayController willMoveToParentViewController:nil];
    [self.currentDisplayController.view removeFromSuperview];
    [self.currentDisplayController removeFromParentViewController];
    [self.currentDisplayController didMoveToParentViewController:nil];
    
    [controller willMoveToParentViewController:self];
    [self.view insertSubview:controller.view atIndex:0];
    [self addChildViewController:controller];
    [controller didMoveToParentViewController:self];
    
    // reset current controller
    self.currentDisplayController = controller;
    //layout new controller
    [self _layoutControllerWithController:controller];
    
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
    
    //trigger to fixed header constraint
    UIScrollView *scrollView = [self scrollViewInPageController:controller];
    if (self.headerHeightConstraint.constant != self.headerHeight) {
        if (scrollView.contentOffset.y >= -(self.segmentHeight + self.headerHeight) && scrollView.contentOffset.y <= -self.segmentHeight) {
            [scrollView setContentOffset:CGPointMake(0, -self.segmentHeight - self.headerHeightConstraint.constant)];
        }
    }
    //add obsever
    [self addObserverForPageController:self.currentDisplayController];
}

#pragma mark - manage memory methods

-(void)dealloc
{
    [self removeObseverForPageController:self.currentDisplayController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
