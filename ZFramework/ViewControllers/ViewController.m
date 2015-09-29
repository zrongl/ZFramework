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

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavigationTitle:@"统计"];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 220, 32);
    button.layer.cornerRadius = 5.f;
    button.backgroundColor = kThemeColor;
    button.center = self.view.center;
    [button setTitle:@"推出" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(pushInTo) forControlEvents:UIControlEventTouchUpInside];
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
    
    _starView = [[ZStarGradeView alloc] initWithFrame:CGRectMake(30, 100, 110, 17)
                                                           grayImage:[UIImage imageNamed:@"star_gray.png"]
                                                          lightImage:[UIImage imageNamed:@"star_light"]];
    [self.view addSubview:_starView];
    
    UIButton *button = [ZHelper createButtonWithPoint:CGPointMake(118, 200) title:@"改变分数" action:@selector(scoreChange) target:self];
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
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 220, 32);
    button.layer.cornerRadius = 5.f;
    button.backgroundColor = kThemeColor;
    button.center = self.view.center;
    [button setTitle:@"弹出" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(popTo) forControlEvents:UIControlEventTouchUpInside];
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
