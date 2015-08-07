//
//  AVplay.m
//  MusicPlayer-B
//
//  Created by lanou on 15/7/17.
//  Copyright (c) 2015年 www.lanou3g.com. All rights reserved.
//

#import "AVplay.h"
#import "AVBookModel.h"
#import "UIImageView+WebCache.h"
//#import "AFNetworking.h"
#import "CircleImageModel.h"
@class MusicDetailViewController;

#define picURL @"http://lp.music.ttpod.com/pic/down?artist="

@interface AVplay ()

@property (nonatomic,strong) UIImageView *circleImageView;
@property (nonatomic,strong) UIImageView *bacImageView;
@property (nonatomic,strong) NSMutableArray *circleImageArray;

@end
@implementation AVplay
//GCD方式
+(AVplay *)shareInstance
{
    static AVplay *musicPlayer = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        musicPlayer = [[AVplay alloc] init];
    });
    return musicPlayer;
}
//设置播放列表
-(void)putItemsArray:(NSMutableArray *)itemsArray andItemNumber:(NSInteger)itemNumber{
    
    self.itemsArray = itemsArray;
    self.itemNumber = itemNumber;
    
    self.ssModel = self.itemsArray[self.itemNumber];
    AVAsset *asset = [AVURLAsset URLAssetWithURL:[NSURL URLWithString:self.ssModel.path] options:nil];
    self.playerItem = [AVPlayerItem playerItemWithAsset:asset];
    [self replaceCurrentItemWithPlayerItem:self.playerItem];
    //[self play];
}
//下一曲
-(void)nextItem:(BOOL)isPlay
{
    self.ssModel = [[AVBookModel alloc] init];
    
    if (self.itemNumber == self.itemsArray.count - 1)
    {
        self.itemNumber = 0;
        self.ssModel = [self.itemsArray firstObject];
        
    }
    else
    {
        self.itemNumber++;
        self.ssModel = self.itemsArray[self.itemNumber];
    }
    
    //方法一
    AVAsset *asset = [AVURLAsset URLAssetWithURL:[NSURL URLWithString:self.ssModel.path] options:nil];
    self.playerItem = [AVPlayerItem playerItemWithAsset:asset];
    
    //方法二
    //self.playerItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:self.ssModel.path]];这个方法更简单
    
    //替换当前正在播放的音乐
    [self replaceCurrentItemWithPlayerItem:self.playerItem];
    
    if (isPlay)
    {
        [self play];
    }
}

-(void)lastItem:(BOOL)isPlay
{
    //移除通知
//    [[NSNotificationCenter defaultCenter]removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:self.playerItem];
    self.ssModel = [[AVBookModel alloc] init];
    
    if (self.itemNumber == 0)
    {
        self.itemNumber = self.itemsArray.count - 1;
        self.ssModel = [self.itemsArray lastObject];
    }
    else
    {
        self.itemNumber--;
        self.ssModel = self.itemsArray[self.itemNumber];
    }
    AVAsset *asset = [AVURLAsset URLAssetWithURL:[NSURL URLWithString:self.ssModel.path] options:nil ];
    self.playerItem = [AVPlayerItem playerItemWithAsset:asset];
    [self replaceCurrentItemWithPlayerItem:self.playerItem];
//    //添加通知
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(itemPlayDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.playerItem];
    if (isPlay)
    {
        [self play];
    }
}


#pragma -mark 暂停和播放
-(void)playAndPauseItem
{
    if (self.rate == 1.0)
        [self pause];
    else
        [self play];
}

#pragma -mark 单曲循环
-(void)singleCyclePlay
{
    //移除通知
    [[NSNotificationCenter defaultCenter]removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:self.playerItem];
    self.ssModel = self.itemsArray[self.itemNumber];
    
    AVAsset *asset = [AVURLAsset URLAssetWithURL:[NSURL URLWithString:self.ssModel.path] options:nil];
    self.playerItem = [AVPlayerItem playerItemWithAsset:asset];
    [self replaceCurrentItemWithPlayerItem:self.playerItem];
    
    //添加播放结束的通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(playDidEndAndSingleCyle:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.playerItem];
    [self play];
    
    
}

#pragma -mark 随机播放
-(void)randomPlay:(AVBookModel *)ssModel
{
    //移除通知
//    [[NSNotificationCenter defaultCenter]removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:self.playerItem];
//    self.ssModel = self.itemsArray[arc4random()%self.itemsArray.count];
    
    AVAsset *asset = [AVURLAsset URLAssetWithURL:[NSURL URLWithString:ssModel.path] options:nil];
    self.playerItem = [AVPlayerItem playerItemWithAsset:asset];
    [self replaceCurrentItemWithPlayerItem:self.playerItem];
    
    //添加播放结束的通知
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(playDidEndAndRandom:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.playerItem];
    [self play];
}

-(void)circulatePlay//循环播放
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(itemPlayDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.playerItem];
}

- (void)itemPlayDidEnd:(NSNotification *)notification//循环播放的方法
{
    if ([notification.name isEqualToString:AVPlayerItemDidPlayToEndTimeNotification])
    {
        if (_num == 2)
        {
            [self nextItem:YES];
        }
        else if (_num == 1)
        {
            [self singleCyclePlay];
        }
        else if (_num == 0)
        {
//            [self randomPlay:(SSongModel *)];
        }
      
    }
}


-(void)playDidEndAndSingleCyle:(NSNotification *)notification//单曲循环
{
    if ([notification.name isEqualToString:AVPlayerItemDidPlayToEndTimeNotification])
    {
        if (_num == 2)
        {
            [self nextItem:YES];
        }
        else if (_num == 1)
        {
            [self singleCyclePlay];
        }
        else if (_num == 0)
        {
//            [self randomPlay];
        }
   
    }
}
-(void)playDidEndAndRandom:(NSNotification *)notification//随机播放
{
    if ([notification.name isEqualToString:AVPlayerItemDidPlayToEndTimeNotification])
    {
        if (_num == 2)
        {
            [self nextItem:YES];
        }
        else if (_num == 1)
        {
            [self singleCyclePlay];
        }
        else if (_num == 0)
        {
//            [self randomPlay];
        }
    }
}
@end
