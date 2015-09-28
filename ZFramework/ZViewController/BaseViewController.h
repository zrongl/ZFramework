//
//  TBaseViewController.h
//  TGod
//
//  Created by Joven on 14/12/18.
//  Copyright (c) 2014年 LaShou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

- (void)setNavTitle:(NSString *)title;
- (void)setNavPullDownTitle:(NSString *)title;
- (void)setNavBackArrow;
- (void)setNavRightButtonWithImage:(NSString *)name action:(SEL)action;
- (void)setNavRightButtonWithTitle:(NSString *)title action:(SEL)action;
- (void)setNavLeftButtonWithTitle:(NSString *)title action:(SEL)action;
- (void)navBackButtonClicked:(UIButton *)sender;
- (void)navPullDownAction;

- (void)showNoDataView;
- (void)hideNoDataView;
- (void)showNoNetworkView;
- (void)hideNoNetworkView;
- (void)showProgressViewWithTitle:(NSString *)title;
- (void)hideProgressView;

@end
