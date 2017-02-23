//
//  AppDelegate.m
//  ZFramework
//
//  Created by ronglei on 15/9/25.
//  Copyright © 2015年 ronglei. All rights reserved.
//

#import "ZFPSLabel.h"
#import "AppDelegate.h"
#import "ViewController.h"
#import "ZViewController.h"
#import "ZTabBarController.h"

@implementation AppDelegate
// 当应用程序启动完毕的时候就会调用(系统自动调用)
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSLog(@"didFinishLaunchingWithOptions");
    [ZNavigationController customizeAppearanceForiOS7];
    _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _window.rootViewController = [[ZTabBarController alloc] init];
    [_window makeKeyAndVisible];
    [_window addSubview:[ZFPSLabel new]];
    
    return YES;
}

// 即将失去活动状态的时候调用(失去焦点, 不可交互)
- (void)applicationWillResignActive:(UIApplication *)application
{
    NSLog(@"ResignActive");
}

// 重新获取焦点(能够和用户交互)
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    NSLog(@"BecomeActive");
}

// 应用程序进入后台的时候调用
// 一般在该方法中保存应用程序的数据, 以及状态
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    NSLog(@"Background");
}

// 应用程序即将进入前台的时候调用
// 一般在该方法中恢复应用程序的数据,以及状态
- (void)applicationWillEnterForeground:(UIApplication *)application
{
    NSLog(@"Foreground");
}

// 应用程序即将被销毁的时候会调用该方法
// 注意:如果应用程序处于挂起状态的时候无法调用该方法
- (void)applicationWillTerminate:(UIApplication *)application
{
}

// 应用程序接收到内存警告的时候就会调用
// 一般在该方法中释放掉不需要的内存
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
    NSLog(@"MemoryWarning");
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSLog(@"%s deviceToken %@",__func__,deviceToken);
    
    NSString *token = [NSString stringWithFormat:@"%@", deviceToken];
    token = [token substringWithRange:NSMakeRange(1, [token length] - 2)];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSLog(@"\ntoken %@", token);
}

@end
