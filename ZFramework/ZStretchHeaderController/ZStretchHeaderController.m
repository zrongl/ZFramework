//
//  ZStretchHeaderController.m
//  ZFramework
//
//  Created by ronglei on 15/10/1.
//  Copyright © 2015年 ronglei. All rights reserved.
//

#import "ZStretchHeaderController.h"
#import "UIImage+ImageEffects.h"
#import "UIView+ZAddition.h"
#import "Macro.h"

@interface ZStretchHeaderController ()<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UIView *headerView;
@property (strong, nonatomic) UIView *navigationBar;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIImageView *headerImageView;
@property (strong, nonatomic) UIImageView *navigationBackgound;

@end

@implementation ZStretchHeaderController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    
    _headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kMainBoundsWidth, 200)];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"header_image" ofType:@"png"];
    UIImage *headerImage = [UIImage imageWithContentsOfFile:path];
    _headerImageView.image = headerImage;
    _headerImageView.clipsToBounds = YES;
    [self.view addSubview:_headerImageView];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kMainBoundsWidth, kMainBoundsHeight - 64)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.backgroundColor = [UIColor clearColor];
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainBoundsWidth, 200 - 64)];
    _headerView.backgroundColor = [UIColor clearColor];
    _tableView.tableHeaderView = _headerView;
    [self.view addSubview:_tableView];

    _navigationBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainBoundsWidth, 64)];
    _navigationBackgound = [[UIImageView alloc] initWithFrame:_navigationBar.bounds];
    _navigationBackgound.image = [UIImage imageNamed:@"nav_bg.png"];
//    imageView.image = [headerImage applyLightEffect];
    _navigationBackgound.alpha = 0;
    [_navigationBar addSubview:_navigationBackgound];
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setFrame:CGRectMake(0, 20, 50, 44)];
    [backButton setImage:[UIImage imageNamed:@"nav_back.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_navigationBar addSubview:backButton];
    [self.view addSubview:_navigationBar];
}

- (void)backButtonClicked:(id)sender
{
    self.navigationController.navigationBarHidden = NO;
    [super backButtonClicked:nil];
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
        cell.layer.borderWidth = 0.5f;
        cell.layer.borderColor = kThemeColor.CGColor;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.textLabel.text = @"TableView";
    
    return cell;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY >= 0) {
        _headerImageView.y = -offsetY;
        _navigationBackgound.alpha = (offsetY - 72)/64;
    }else{
        CGRect frame = _headerImageView.frame;
        CGFloat widthOffset = kMainBoundsWidth*offsetY/200;
        frame.origin.y = 0;
        frame.origin.x = widthOffset/2;
        frame.size.height = 200 - offsetY;
        frame.size.width =  kMainBoundsWidth - widthOffset;
        _headerImageView.frame = frame;
    }
}

@end