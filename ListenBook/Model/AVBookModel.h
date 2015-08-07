//
//  SSongModel.h
//  MusicPlayer-B
//
//  Created by lanou on 15/7/11.
//  Copyright (c) 2015年 www.lanou3g.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AVBookModel : NSObject

@property(nonatomic,strong)NSString *book_name;
@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSString *path;
@property(nonatomic,strong)UIImage  *image;
@property(nonatomic,strong)NSString *book_url;

@end
