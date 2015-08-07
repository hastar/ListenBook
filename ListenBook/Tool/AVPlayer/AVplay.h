//
//  AVplay.h
//  MusicPlayer-B
//
//  Created by lanou on 15/7/17.
//  Copyright (c) 2015年 www.lanou3g.com. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>
@class AVBookModel;

@interface AVplay : AVPlayer
@property (nonatomic,strong) AVPlayer *avPlayer;
@property (nonatomic,retain) AVPlayerItem *playerItem;//播放的曲目
@property (nonatomic,retain) AVBookModel *ssModel;//曲目信息
@property (nonatomic,strong) NSMutableArray *itemsArray;//存放歌曲的数组
@property (nonatomic,assign) NSInteger itemNumber;//播放的索引
@property (nonatomic) int num;


+(AVplay *)shareInstance;//单例模式
-(void)putItemsArray:(NSMutableArray *)itemsArray andItemNumber:(NSInteger)itemNumber;//设置播放列表
-(void)nextItem:(BOOL)isPlay;//下一曲
-(void)lastItem:(BOOL)isPlay;//上一曲
-(void)playAndPauseItem;//播放
-(void)circulatePlay;//循环播放
-(void)singleCyclePlay;//单曲循环
-(void)randomPlay:(AVBookModel *)ssModel;//随机播放

@end
