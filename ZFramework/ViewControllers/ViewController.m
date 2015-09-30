//
//  ViewController.m
//  ZFramework
//
//  Created by ronglei on 15/9/25.
//  Copyright © 2015年 ronglei. All rights reserved.
//

#import "ViewController.h"
#import "Macro.h"
#import "ZStarGradeView.h"
#import "ZHelper.h"
#import "stdlib.h"
#import "ZToastManager.h"

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavigationTitle:@"统计"];
    
    UIButton *button = [ZHelper createButtonWithTitle:@"推出" action:@selector(pushInTo) target:self];
    [self.view addSubview:button];
    
}

- (void)pushInTo
{
    ViewController3 *vc = [[ViewController3 alloc] init];
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
    
    for (NSInteger i = 0; i < 10; i++) {
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
    
    UIButton *button = [ZHelper createButtonWithTitle:@"评分" action:@selector(scoreChange) target:self];
    [self.view addSubview:button];
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
    
    UIButton *button = [ZHelper createButtonWithTitle:@"弹出" action:@selector(popTo) target:self];
    [self.view addSubview:button];
}

- (void)popTo
{
    ViewController4 *vc = [[ViewController4 alloc] init];
    ZNavigationController *nav = [[ZNavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}

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
