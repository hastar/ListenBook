//
//  TabBarViewController.m
//  ListenBook
//
//  Created by lanou on 15/7/15.
//  Copyright (c) 2015年 yxy. All rights reserved.
//

#import "TabBarViewController.h"
#import "BookViewCtrl.h"
#import "SearchViewCtrl.h"
#import "CollectViewCtrl.h"
#import "MineViewCtrl.h"
#import "Colours.h"
#import "MusicDetailCtrl.h"
@interface TabBarViewController ()

@end

@implementation TabBarViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"书城";
    UIImage *bookIcon = [UIImage imageNamed:@"iconfont-book.png"];
    bookIcon = [bookIcon imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *searchIcon = [UIImage imageNamed:@"iconfont-sousuo.png"];
    searchIcon = [searchIcon imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *markIcon = [UIImage imageNamed:@"iconfont-bofangjilu.png"];
    markIcon = [markIcon imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *mineIcon = [UIImage imageNamed:@"iconfont-wode.png"];
    mineIcon = [mineIcon imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.viewControllers = [NSArray arrayWithObjects:
                            [self viewControllerWithTabTitle:@"书城" image:bookIcon],
                            [self viewControllerWithTabTitle:@"搜索" image:searchIcon],
                            [self viewControllerWithTabTitle:@"播放" image:markIcon],
                            [self viewControllerWithTabTitle:@"关于" image:mineIcon], nil];
}

-(UIViewController*) viewControllerWithTabTitle:(NSString*) title image:(UIImage*)image
{
    if ([title isEqualToString:@"书城"]) {
        BookViewCtrl *book = [[BookViewCtrl alloc]init];
        book.tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:image tag:0];
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:book];
        [nav.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
        nav.navigationBar.translucent = NO;
        return nav;
    }
    if ([title isEqualToString:@"搜索"]) {
        SearchViewCtrl *search = [[SearchViewCtrl alloc]init];
        search.tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:image tag:0];
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:search];
        [nav.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
        nav.navigationBar.translucent = NO;
        return nav;
    }
    if ([title isEqualToString:@"播放"]) {
        
        MusicDetailCtrl *musicDetail = [[MusicDetailCtrl alloc]init];
        musicDetail.tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:image tag:0];
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:musicDetail];
        nav.navigationBar.barTintColor = [UIColor skyBlueColor];
        [nav.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
        nav.navigationBar.translucent = NO;
        return nav;
    }
    if ([title isEqualToString:@"关于"]) {
        
        MineViewCtrl *mine = [[MineViewCtrl alloc]init];
        mine.tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:image tag:0];
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:mine];
        [nav.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
        nav.navigationBar.translucent = NO;
        return nav;
    }
    return nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
