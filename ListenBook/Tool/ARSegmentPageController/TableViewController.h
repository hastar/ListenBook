//
//  TableViewController.h
//  ARSegmentPager
//
//  Created by August on 15/3/28.
//  Copyright (c) 2015年 August. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ARSegmentPageController.h"

@interface TableViewController : UITableViewController<ARSegmentControllerDelegate>
@property(nonatomic,strong)NSString *title;
@property(nonatomic,strong)NSString *urlName;
-(void)getBooksArray:(NSString *)url;
@end
