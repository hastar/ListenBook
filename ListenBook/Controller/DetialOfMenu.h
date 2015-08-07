//
//  DetialOfMenu.h
//  HomeCooking
//
//  Created by lanou on 15/6/19.
//  Copyright (c) 2015年 yxy. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^MyBlock) (NSString *,NSString*);
@interface DetialOfMenu : UICollectionViewController
@property (nonatomic,strong)NSString *urlStr;
@property (nonatomic,copy)MyBlock block;
@end
