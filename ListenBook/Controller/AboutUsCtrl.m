//
//  AboutUsCtrl.m
//  ListenBook
//
//  Created by lanou on 15/7/28.
//  Copyright (c) 2015年 yxy. All rights reserved.
//

#import "AboutUsCtrl.h"
#import "Header.h"
#import "UIView+Extension.h"
@interface AboutUsCtrl ()
@property(nonatomic,strong)UIImageView *centerView;
@end

@implementation AboutUsCtrl

-(void)aboutUs
{
    UIImageView *iconView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 8, self.centerView.width/3, self.centerView.height/3)];
    iconView.x = self.centerView.width/3;
    iconView.image = [UIImage imageNamed:@"aboutUs"];
    [self.centerView addSubview:iconView];
    
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(self.centerView.width/3, self.centerView.width/3+9, self.centerView.width/3, 20)];
    title.text = @"彩虹听书";
    title.textAlignment = NSTextAlignmentCenter;
    title.textColor = [UIColor whiteColor];
    title.font = [UIFont systemFontOfSize:14];
    [self.centerView addSubview:title];
    
    UILabel *title1 = [[UILabel alloc]initWithFrame:CGRectMake(self.centerView.width/3, self.centerView.width/3+30, self.centerView.width/3, 20)];
    title1.text = @"版本:1.0";
    title1.textAlignment = NSTextAlignmentCenter;
    title1.textColor = [UIColor whiteColor];
    title1.font = [UIFont systemFontOfSize:14];
    [self.centerView addSubview:title1];
    
    UILabel *title2 = [[UILabel alloc]initWithFrame:CGRectMake(8, self.centerView.width/3+60, self.centerView.width-16, 70)];
    title2.text = @"       彩虹听书收集了大量的有声读物，是您休闲、娱乐、拓展视野的最佳选择。有任何建议请联系我们，我们会尽最大努力优化。";
    title2.numberOfLines = 0;
    //title2.textAlignment = NSTextAlignmentCenter;
    title2.textColor = [UIColor whiteColor];
    title2.font = [UIFont systemFontOfSize:14];
    [self.centerView addSubview:title2];

    UILabel *title3 = [[UILabel alloc]initWithFrame:CGRectMake(0, self.centerView.width - 30, self.centerView.width, 20)];
    title3.text = @"电子邮箱：302695255@qq.com";
    title3.textAlignment = NSTextAlignmentCenter;
    title3.textColor = [UIColor whiteColor];
    title3.font = [UIFont systemFontOfSize:14];
    [self.centerView addSubview:title3];
}
-(void)copyright
{
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, self.centerView.width, 30)];
    title.text = @"版权声明";
    title.textAlignment = NSTextAlignmentCenter;
    title.textColor = [UIColor whiteColor];
    title.font = [UIFont systemFontOfSize:24];
    [self.centerView addSubview:title];

    UILabel *title2 = [[UILabel alloc]initWithFrame:CGRectMake(8, 45, self.centerView.width-16, 170)];
    title2.text = @"       本App所有内容，包括文字、图片、音频等均在网上搜集。访问者可将App提供的内容用于个人学习，研究或观赏，以及其他非商业性或盈利性用途。但同时应遵守著作权法及相关权利人的合法权益。除此以外将本App任何内容用于其他用途时，须征得本App及相关权利人的书面许可。本App内容原作者如不愿意在本App刊登内容，请及时通知本App，予以删除。";
    title2.numberOfLines = 0;
    title2.textColor = [UIColor whiteColor];
    title2.font = [UIFont systemFontOfSize:14];
    [self.centerView addSubview:title2];
    
    UILabel *title1 = [[UILabel alloc]initWithFrame:CGRectMake(0, self.centerView.width - 40, self.centerView.width, 20)];
    title1.text = @"电子邮箱：302695255@qq.com";
    title1.textAlignment = NSTextAlignmentCenter;
    title1.textColor = [UIColor whiteColor];
    title1.font = [UIFont systemFontOfSize:14];
    [self.centerView addSubview:title1];
    
    UILabel *title3 = [[UILabel alloc]initWithFrame:CGRectMake(0, self.centerView.width - 20, self.centerView.width, 20)];
    title3.text = @"  Copyright (c) 2015年 彩虹听书. All rights reserved.";
    title3.textAlignment = NSTextAlignmentCenter;
    title3.textColor = [UIColor whiteColor];
    title3.font = [UIFont systemFontOfSize:10];
    [self.centerView addSubview:title3];
}
-(void)setCentreImageView
{
    self.centerView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SW*4/5, SW*4/5)];
    self.centerView.center = self.view.center;
    self.centerView.y -= 64;
    self.centerView.layer.cornerRadius = 20;
    self.centerView.layer.masksToBounds = YES;
    [self.view addSubview:self.centerView];
    
    //在背景图上面加入了模糊化效果
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *effectview = [[UIVisualEffectView alloc] initWithEffect:blur];
    effectview.frame = CGRectMake(0, 0, SW*4/5, SW*4/5);
    [self.centerView addSubview:effectview];
    
    if (self.flag == 0)
    {
        [self aboutUs];
    }
    else
    {
        [self copyright];
    }
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"maoboli-2.jpg"]];
    self.navigationController.navigationBar.TintColor = [UIColor whiteColor];
    
    [self setCentreImageView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
