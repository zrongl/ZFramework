//
//  TNavigationViewController.m
//  TGod
//
//  Created by yangyang on 14/12/17.
//  Copyright (c) 2014年 LaShou. All rights reserved.
//

#import "BaseNavigationController.h"

@interface BaseNavigationController ()

@end

@implementation BaseNavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bg"] forBarMetrics:UIBarMetricsDefault];
}

@end
