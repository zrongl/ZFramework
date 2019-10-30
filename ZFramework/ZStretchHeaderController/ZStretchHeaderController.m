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
#import "ZStretchCell.h"
#import "ViewController.h"

#define kStretchViewHeight  230

@interface ZStretchHeaderController ()<UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate>

@property (strong, nonatomic) UIView *headerView;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataSource;
@property (strong, nonatomic) UIImageView *stretchImageView;
@property (strong, nonatomic) UIImageView *navigationBackgoundView;

@end

@implementation ZStretchHeaderController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // animated设置为YES使得手势滑动正常
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupTableView];
    [self customStretchImageView];
    [self customNavigationBar];
    
    [self generateDataSource];

}

- (void)generateDataSource
{
    _dataSource = [NSMutableArray array];
    for (int i = 0; i < 300; i++) {
        NSString *str = [NSString stringWithFormat:@"%d Async Display Test ✺◟(∗❛ัᴗ❛ั∗)◞✺ ✺◟(∗❛ัᴗ❛ั∗)◞✺ 😀😖😐😣😡🚖🚌🚋🎊💖💗💛💙🏨🏦🏫 Async Display Test ✺◟(∗❛ัᴗ❛ั∗)◞✺ ✺◟(∗❛ัᴗ❛ั∗)◞✺ 😀😖😐😣😡🚖🚌🚋🎊💖💗💛💙🏨🏦🏫",i];
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:str];
        text.font = [UIFont systemFontOfSize:10];
        text.lineSpacing = 0;
        text.strokeWidth = @(-3);
//        text.strokeColor = [UIColor redColor];
//        text.lineHeightMultiple = 1;
//        text.maximumLineHeight = 12;
//        text.minimumLineHeight = 12;
        
        [_dataSource addObject:text];
    }
    
    [_tableView reloadData];
}

/**
 *  拉伸的图片背景
 */
- (void)customStretchImageView
{
    _stretchImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kStretchViewHeight)];
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
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.clipsToBounds = YES;
    _tableView.backgroundColor = [UIColor clearColor];
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kStretchViewHeight)];
    headerView.clipsToBounds = YES;
    headerView.backgroundColor = [UIColor clearColor];
    UIImageView *headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake((headerView.width - 70)/2, 84, 70, 70)];
    headerImageView.image = [UIImage imageNamed:@"headr.png"];
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
    UIView *navigationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
    navigationView.backgroundColor = [UIColor clearColor];
    _navigationBackgoundView = [[UIImageView alloc] initWithFrame:navigationView.bounds];
    _navigationBackgoundView.backgroundColor = [UIColor clearColor];
    _navigationBackgoundView.image = [UIImage imageNamed:@"nav_bg.png"];
    _navigationBackgoundView.alpha = 0;
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 19, kScreenWidth, 44)];
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
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ZStretchCell *cell = [ZStretchCell cellForTableView:tableView];
    [cell setTextString:_dataSource[indexPath.row]];
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
        CGFloat widthOffset = kScreenWidth*offsetY/kStretchViewHeight;
        frame.origin.y = 0;
        frame.origin.x = widthOffset/2;
        frame.size.height = kStretchViewHeight - offsetY;
        frame.size.width =  kScreenWidth - widthOffset;
        _stretchImageView.frame = frame;
    }
}

@end
