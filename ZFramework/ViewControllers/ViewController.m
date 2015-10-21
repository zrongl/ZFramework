//
//  ViewController.m
//  ZFramework
//
//  Created by ronglei on 15/9/25.
//  Copyright © 2015年 ronglei. All rights reserved.
//

#import "ViewController.h"
#import "stdlib.h"
#import "ZLocationView.h"
#import "ZToastView.h"
#import "ZStarGradeView.h"
#import "ZPullTableView.h"
#import <CoreLocation/CoreLocation.h>

#import "ZDemoViewController.h"

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavigationTitle:@"统计"];
    
    UIButton *button = [ZHelper buttonWithFrame:CGRectMake((kMainBoundsWidth - 120)/2, kMainBoundsHeight*0.6, 120, 30) title:@"推出" action:@selector(pushInTo) target:self];
    [self.view addSubview:button];
    
}

- (void)pushInTo
{
    ZDemoViewController *vc = [[ZDemoViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end

@implementation ViewController1

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavigationTitle:@"清算"];
    [self showLoadingViewWithTitle:@"正在加载..."];
    
    for (NSInteger i = 0; i < 3; i++) {
        [ZToastView serialToastWithMessage:@"请稍候" stady:2];
    }
}

@end

@interface ViewController2()

@property (strong, nonatomic) ZStarGradeView *starView;

@end

@implementation ViewController2

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavigationTitle:@"我的"];
    
    _starView = [[ZStarGradeView alloc] initWithFrame:CGRectMake((kMainBoundsWidth - 200)/2, 100, 200, 25)
                                                           grayImage:[UIImage imageNamed:@"star_gray.png"]
                                                          lightImage:[UIImage imageNamed:@"star_light"]];
    [self.view addSubview:_starView];
    
    UIButton *button = [ZHelper buttonWithFrame:CGRectMake((kMainBoundsWidth - 120)/2, kMainBoundsHeight*0.6, 120, 30) title:@"评分" action:@selector(scoreChange) target:self];
    [self.view addSubview:button];
    UIButton *pushButton = [ZHelper buttonWithFrame:CGRectMake((kMainBoundsWidth - 120)/2, kMainBoundsHeight*0.6, 120, 30) title:@"推出" action:@selector(pushViewController) target:self];
    pushButton.y = button.bottom + 20.f;
    [self.view addSubview:pushButton];
    
    // location view
    if(![CLLocationManager locationServicesEnabled] ||
       [CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied){
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 90000
        UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"提示"
                                                                           message:@"需要开启定位服务,请到设置->隐私,打开定位服务"
                                                                    preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定"
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * _Nonnull action) {
                                                           
                                                       }];
        [alertView addAction:action];
        [self presentViewController:alertView animated:YES completion:nil];
#else
        UIAlertView *alvertView=[[UIAlertView alloc] initWithTitle:@"提示"
                                                           message:@"需要开启定位服务,请到设置->隐私,打开定位服务"
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles: nil];
        [alvertView show];
#endif
    }
    ZLocationView *loactionView = [[ZLocationView alloc] initWithFrame:CGRectMake(0, 0, kMainBoundsWidth, 28)];
    [self.view addSubview:loactionView];
}

- (void)pushViewController
{

}

- (void)scoreChange
{
    [_starView setGradeWithScore:fRandom(10) scoreSystem:10 animation:YES];
}

@end

@implementation ViewController3

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self customBackButton];
    [self setNavigationTitle:@"推视图"];
    UIButton *button = [ZHelper buttonWithFrame:CGRectMake((kMainBoundsWidth - 120)/2, kMainBoundsHeight*0.6, 120, 30) title:@"弹出" action:@selector(popTo) target:self];
    [self.view addSubview:button];
}

- (void)popTo
{

}

@end

@interface ViewController4()

@end

@implementation ViewController4

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self customDismissButton];
    [self setNavigationTitle:@"弹视图"];
    [self customRightButtonWithTitle:@"发送" action:nil];
}

@end
