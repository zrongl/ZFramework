//
//  ViewController.m
//  ZFramework
//
//  Created by ronglei on 15/9/25.
//  Copyright © 2015年 ronglei. All rights reserved.
//

#import "ViewController.h"
#import "ZConstant.h"
#import "stdlib.h"
#import "ZHelper.h"
#import "ListModel.h"
#import "ZToastManager.h"
#import "ZLocationView.h"
#import "ZStarGradeView.h"
#import "UIView+ZAddition.h"
#import "ZStretchHeaderController.h"
#import "ZPullTableView.h"
#import <CoreLocation/CoreLocation.h>
#import "ZPhotoBrowserController.h"
#import "ZPhoto.h"

#import "ZDemo.h"

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
//    ViewController3 *vc = [[ViewController3 alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
    
    NSArray *networkImages=@[
                             @"http://www.netbian.com/d/file/20150519/f2897426d8747f2704f3d1e4c2e33fc2.jpg",
                             @"http://www.netbian.com/d/file/20130502/701d50ab1c8ca5b5a7515b0098b7c3f3.jpg",
                             @"http://www.netbian.com/d/file/20110418/48d30d13ae088fd80fde8b4f6f4e73f9.jpg",
                             @"http://www.netbian.com/d/file/20150318/869f76bbd095942d8ca03ad4ad45fc80.jpg",
                             @"http://www.netbian.com/d/file/20110424/b69ac12af595efc2473a93bc26c276b2.jpg",
                             
                             @"http://www.netbian.com/d/file/20140522/3e939daa0343d438195b710902590ea0.jpg",
                             
                             @"http://www.netbian.com/d/file/20141018/7ccbfeb9f47a729ffd6ac45115a647a3.jpg",
                             
                             @"http://www.netbian.com/d/file/20140724/fefe4f48b5563da35ff3e5b6aa091af4.jpg",
                             
                             @"http://www.netbian.com/d/file/20140529/95e170155a843061397b4bbcb1cefc50.jpg"
                             ];
//    NSArray *networkImages= @[@"http://ww3.sinaimg.cn/bmiddle/8e88b0c1gw1e9lpr0nly5j20pf0gygo6.jpg",
//                              @"http://ww4.sinaimg.cn/bmiddle/8e88b0c1gw1e9lpr1d0vyj20pf0gytcj.jpg",
//                              @"http://ww3.sinaimg.cn/bmiddle/8e88b0c1gw1e9lpr1xydcj20gy0o9q6s.jpg",
//                              @"http://ww2.sinaimg.cn/bmiddle/8e88b0c1gw1e9lpr2n1jjj20gy0o9tcc.jpg",
//                              @"http://ww2.sinaimg.cn/bmiddle/8e88b0c1gw1e9lpr39ht9j20gy0o6q74.jpg",
//                              @"http://ww3.sinaimg.cn/bmiddle/8e88b0c1gw1e9lpr3xvtlj20gy0obadv.jpg",
//                              @"http://ww4.sinaimg.cn/bmiddle/8e88b0c1gw1e9lpr4nndfj20gy0o9q6i.jpg",
//                              @"http://ww3.sinaimg.cn/bmiddle/8e88b0c1gw1e9lpr57tn9j20gy0obn0f.jpg"];
    NSMutableArray *array = [NSMutableArray array];
    for (NSString *url in networkImages) {
        ZPhoto *photo = [[ZPhoto alloc] init];
        photo.url = url;
        [array addObject:photo];
    }
    
    ZPhotoBrowserController *vc = [[ZPhotoBrowserController alloc] init];
    vc.photosArray = array;
    vc.currentPhotoIndex = 3;
    [self.navigationController pushViewController:vc animated:YES];
}

@end

@implementation ViewController1

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavigationTitle:@"清算"];
    [self showLoadingViewWithTitle:@"正在加载..."];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue setMaxConcurrentOperationCount:1];
    
    for (NSInteger i = 0; i < 3; i++) {
        [ZToastManager toastWithMessage:@"请求失败，请稍后重试" stady:2.f];
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
    BarberDetailViewController *vc = [[BarberDetailViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)scoreChange
{
    [_starView setGradeWithScore:xRandom(10) scoreSystem:10 animation:YES];
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
    StoreListViewController *vc = [[StoreListViewController alloc] init];
    ZNavigationController *nav = [[ZNavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}

@end

#import "LoginRequest.h"

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
