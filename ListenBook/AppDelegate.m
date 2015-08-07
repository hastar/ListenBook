//
//  AppDelegate.m
//  ListenBook
//
//  Created by lanou on 15/7/14.
//  Copyright (c) 2015年 yxy. All rights reserved.
//

#import "AppDelegate.h"
#import "TabBarViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "Colours.h"
#import "Reachability.h"
#import "HMNetworkTool.h"
@interface AppDelegate ()<UITabBarControllerDelegate>
{
    UIBackgroundTaskIdentifier bgTaskId;
}
@property(nonatomic,assign)BOOL isReachable;
@property(nonatomic,strong)Reachability *reachability;
@end

@implementation AppDelegate
- (void)dealloc
{
    [self.reachability stopNotifier];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    sleep(1);
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    [audioSession setActive:YES error:nil];
    
    self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    TabBarViewController *root = [[TabBarViewController alloc]init];
    root.tabBar.barTintColor = [UIColor skyBlueColor];
    root.tabBar.tintColor = [UIColor whiteColor];
    root.delegate = self;
    root.tabBar.translucent = NO;
    
    self.window.rootViewController = root;
    
    // 监听网络状态发生改变的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkStateChange) name:kReachabilityChangedNotification object:nil];
    // 获得Reachability对象
    self.reachability = [Reachability reachabilityForInternetConnection];
    // 开始监控网络
    [self.reachability startNotifier];
    
    return YES;
}
- (void)networkStateChange
{
    //NSLog(@"网络状态改变了");
    [self checkNetworkState];
}
/**
 *  监测网络状态
 */
- (void)checkNetworkState
{
    if ([HMNetworkTool isEnableWIFI]||[HMNetworkTool isEnable3G]) {
        self.isReachable = YES;
    } else {
        self.isReachable = NO;
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"网路链接异常,请检查网络" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    UIDevice* device = [UIDevice currentDevice];
    if ([device respondsToSelector:@selector(isMultitaskingSupported)])
    {
        if(device.multitaskingSupported)
        {
            if (bgTaskId == UIBackgroundTaskInvalid)
            {
                bgTaskId = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:NULL];
            }
        }
    }
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [application beginBackgroundTaskWithExpirationHandler:nil];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    if (bgTaskId != UIBackgroundTaskInvalid)
    {
        [[UIApplication sharedApplication] endBackgroundTask:bgTaskId];
        bgTaskId = UIBackgroundTaskInvalid;
    }
}

- (void)applicationWillTerminate:(UIApplication *)application {
  
}

@end
