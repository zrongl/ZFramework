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

@interface ViewController()

@property (strong, nonatomic) UIView *btn_1;
@property (strong, nonatomic) UIView *btn_2;
@property (strong, nonatomic) UIView *btn_3;
@property (strong, nonatomic) UIView *btn_4;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"统计"];
    
    UIButton *button = [ZHelper buttonWithFrame:CGRectMake((kMainBoundsWidth - 120)/2, kMainBoundsHeight*0.6, 120, 30) title:@"推出" action:@selector(pushInTo) target:self];
    [self.view addSubview:button];
    
    
    _btn_1 = [UIView new];
    _btn_1.backgroundColor = kMainColor;
    [self.view addSubview:_btn_1];
    _btn_2 = [UIView new];
    _btn_2.backgroundColor = [UIColor blackColor];
    [self.view addSubview:_btn_2];
    _btn_3 = [UIView new];
    _btn_3.backgroundColor = [UIColor redColor];
    [self.view addSubview:_btn_3];
    _btn_4 = [UIView new];
    _btn_4.backgroundColor = [UIColor greenColor];
    [self.view addSubview:_btn_4];
    
    [_btn_1 setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_btn_2 setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_btn_3 setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_btn_4 setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    CGSize winSize = CGSizeMake(kMainBoundsWidth, kMainBoundsHeight);
    CGFloat tpo = 100;
    CGFloat hpod = 100;
    CGFloat btnH = 40;
    CGFloat vpod = winSize.width*0.15-btnH;
    
    NSNumber* tp = [NSNumber numberWithFloat:tpo];
    NSNumber* hd = [NSNumber numberWithFloat:hpod];
    NSNumber* vd = [NSNumber numberWithFloat:vpod];
    NSNumber* bh = [NSNumber numberWithFloat:btnH];
    NSNumber* btm = [NSNumber numberWithFloat:vpod*2];
    
    NSDictionary *dict1 = NSDictionaryOfVariableBindings(_btn_1,_btn_2,_btn_3,_btn_4);
    NSDictionary *metrics = @{@"hPadding":hd,@"vPadding":vd,@"top":tp,@"btm":btm,@"btnHeight":bh};
    NSString *vfl1 = @"|-[_btn_1]-|";
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl1
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:dict1]];
    NSString *vfl2 = @"|-hPadding-[_btn_2]-hPadding-|";
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl2
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:dict1]];
    NSString *vfl3 = @"|-hPadding-[_btn_3]-hPadding-|";
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl3
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:dict1]];
    NSString *vfl4 = @"|-hPadding-[_btn_4]-hPadding-|";
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl4
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:dict1]];
    NSString *vfl5 = @"V:|-(<=top)-[_btn_1(btnHeight)][_btn_2(btnHeight)]-vPadding-[_btn_3(btnHeight)]-vPadding-[_btn_4(btnHeight)]-(>=btm)-|";
    if (_btn_1.hidden) {
        vfl5 = @"V:|-(<=top)-[_btn_2(btnHeight)]-vPadding-[_btn_3(btnHeight)]-vPadding-[_btn_4(btnHeight)]-(>=btm)-|";
    }
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl5
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:dict1]];
    
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
    [self setTitle:@"清算"];
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
    [self setTitle:@"我的"];
    
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
    [self setTitle:@"推视图"];
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
    [self setTitle:@"弹视图"];
    [self rightButtonItemWithTitle:@"发送" action:nil];
}

@end
