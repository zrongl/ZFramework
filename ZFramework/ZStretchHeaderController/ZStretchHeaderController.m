//
//  ZStretchHeaderController.m
//  ZFramework
//
//  Created by ronglei on 15/10/1.
//  Copyright © 2015年 ronglei. All rights reserved.
//

#import "ZStretchHeaderController.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "UIImage+ImageEffects.h"
#import "UIView+ZAddition.h"
#import "ZConstant.h"

#import "ViewController.h"

#define kStretchViewHeight  230

@interface ZStretchHeaderController ()<UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate>

@property (strong, nonatomic) UIView *headerView;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIImageView *stretchImageView;
@property (strong, nonatomic) UIImageView *navigationBackgoundView;

@end

@implementation ZStretchHeaderController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // 滑动切换时 navigationBar正常显示
    self.fd_prefersNavigationBarHidden = YES;
    
    [self customStretchImageView];
    [self setupTableView];
    [self customNavigationBar];
}

/**
 *  拉伸的图片背景
 */
- (void)customStretchImageView
{
    _stretchImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kMainBoundsWidth, kStretchViewHeight)];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"header_bg" ofType:@"png"];
    UIImage *headerImage = [UIImage imageWithContentsOfFile:path];
    dispatch_async(dispatch_get_main_queue(), ^{
        _stretchImageView.image = headerImage;
    });
    _stretchImageView.clipsToBounds = YES;
    [self.view addSubview:_stretchImageView];
}

/**
 *  自定义headerView包括 头像以及其它信息等
 */
- (void)setupTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kMainBoundsWidth, kMainBoundsHeight)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.clipsToBounds = YES;
    _tableView.backgroundColor = [UIColor clearColor];
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainBoundsWidth, kStretchViewHeight)];
    headerView.backgroundColor = [UIColor clearColor];
    UIImageView *headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake((headerView.width - 70)/2, 84, 70, 70)];
    headerImageView.image = [UIImage imageNamed:@"header.png"];
    headerImageView.layer.cornerRadius = 35.f;
    [headerView addSubview:headerImageView];
    _tableView.tableHeaderView = headerView;
    [self.view addSubview:_tableView];
}

/**
 *  自定义navigation bar包括返回按钮，标题，右侧按钮
 */
- (void)customNavigationBar
{
    UIView *navigationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainBoundsWidth, 64)];
    navigationView.backgroundColor = [UIColor clearColor];
    _navigationBackgoundView = [[UIImageView alloc] initWithFrame:navigationView.bounds];
    _navigationBackgoundView.backgroundColor = [UIColor clearColor];
    _navigationBackgoundView.image = [UIImage imageNamed:@"nav_bg.png"];
    _navigationBackgoundView.alpha = 0;
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 19, kMainBoundsWidth, 44)];
    titleLabel.text = @"我的";
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:20.f];
    [_navigationBackgoundView addSubview:titleLabel];
    [navigationView addSubview:_navigationBackgoundView];
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setFrame:CGRectMake(0, 20, 50, 44)];
    [backButton setImage:[UIImage imageNamed:@"nav_back.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [navigationView addSubview:backButton];
    [self.view addSubview:navigationView];
}

- (void)backButtonClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDeleagte
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.textLabel.text = @"TableView";
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    ViewController *vc = [[ViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetY = scrollView.contentOffset.y;
    _navigationBackgoundView.alpha = offsetY/(kStretchViewHeight - 64);
    if (offsetY >= 0) {
        _stretchImageView.y = -offsetY;
    }else{
        CGRect frame = _stretchImageView.frame;
        CGFloat widthOffset = kMainBoundsWidth*offsetY/kStretchViewHeight;
        frame.origin.y = 0;
        frame.origin.x = widthOffset/2;
        frame.size.height = kStretchViewHeight - offsetY;
        frame.size.width =  kMainBoundsWidth - widthOffset;
        _stretchImageView.frame = frame;
    }
}

@end
