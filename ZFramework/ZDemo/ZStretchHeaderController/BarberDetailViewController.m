//
//  BarberDetailViewController.m
//  BeautyLaudApp
//
//  Created by ronglei on 15/10/9.
//  Copyright © 2015年 LaShou. All rights reserved.
//

#import "ZConstant.h"
#import "ZAdditions.h"
#import "UIImage+ImageEffects.h"

#import "BarberDetailViewController.h"

#import "BarberHeaderView.h"
#import "BarberIntroCell.h"
#import "BarberRequest.h"

#import "BarberServeCell.h"
#import "BarberServeModel.h"
#import "BarberWorksCell.h"
#import "BarberWorkView.h"
#import "BarberWorkModel.h"

#import "StoreModel.h"
#import "StoreCell.h"
#import "StoreRequest.h"

#import "UIImageView+AFNetworking.h"

#define kStretchViewHeight  217
#define kBarberIntroCellKey     @"1801"
#define kStoreInfoCellKey       @"1802"
#define kServeItemCellKey       @"1803"
#define kBarberWorksCellKey     @"1804"

@interface BarberDetailViewController ()<UITableViewDataSource, UITableViewDelegate, BarberServeCellDelegate,BarberWorkViewDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIImageView *stretchImageView;
@property (strong, nonatomic) UIImageView *navigationBackgoundView;
@property (strong, nonatomic) UIView *appointView;
@property (strong, nonatomic) BarberHeaderView *headerView;

@property (strong, nonatomic) BarberModel *barberModel;
@property (strong, nonatomic) StoreModel *storeModel;
@property (strong, nonatomic) NSArray *servesArray;
@property (assign, nonatomic) BOOL isShowAllBarberServes;
@property (strong, nonatomic) NSArray *worksArray;

@property (strong, nonatomic) NSMutableArray *cellKeyArray;

@end

@implementation BarberDetailViewController

// 系统navigation bar隐藏及显示操作
- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupDatas];
    
    [self customStretchImageView];
    [self setupTableView];
    [self customNavigationBar];
    
    [self requestBarberDetail];
    [self requestSotreInfo];
    [self requestBarberServeList];
    [self requestBarberWorks];
}

- (void)setupDatas
{
    _cellKeyArray = [[NSMutableArray alloc] init];
    _isShowAllBarberServes = NO;
}

- (void)updateCellKeyArray
{
    [_cellKeyArray removeAllObjects];
    if (_barberModel) {
        [_cellKeyArray addObject:kBarberIntroCellKey];
    }
    if (_storeModel){
        [_cellKeyArray addObject:kStoreInfoCellKey];
    }
    if (_servesArray && _servesArray.count > 0){
        [_cellKeyArray addObject:kServeItemCellKey];
    }
    if (_worksArray && _worksArray.count > 0){
        [_cellKeyArray addObject:kBarberWorksCellKey];
    }
    
    [_tableView reloadData];
}

/**
 *  拉伸的图片背景
 */
- (void)customStretchImageView
{
    _stretchImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kMainBoundsWidth, kStretchViewHeight)];
    _stretchImageView.image = [[UIImage imageNamed:@"barber_header.png"] applyLightEffect];
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
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _headerView = [[BarberHeaderView alloc] initWithFrame:CGRectMake(0, 0, kMainBoundsWidth, kStretchViewHeight)];
    _tableView.tableHeaderView = _headerView;
    [self.view addSubview:_tableView];
}

/**
 *  自定义navigation bar包括返回按钮，标题，右侧按钮
 */
- (void)customNavigationBar
{
    UIView *navigationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainBoundsWidth, 64)];
    _navigationBackgoundView = [[UIImageView alloc] initWithFrame:navigationView.bounds];
    _navigationBackgoundView.image = [UIImage imageNamed:@"nav_bg.png"];
    _navigationBackgoundView.alpha = 0;
    [navigationView addSubview:_navigationBackgoundView];
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setFrame:CGRectMake(0, 27, 50, 30)];
    [backButton setImage:[UIImage imageNamed:@"nav_back.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [navigationView addSubview:backButton];
    
    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    shareButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [shareButton setFrame:CGRectMake(kMainBoundsWidth - 4 - 50, 27, 50, 30)];
    [shareButton setTitle:@"分享" forState:UIControlStateNormal];
    [shareButton addTarget:self action:@selector(shareButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [navigationView addSubview:shareButton];
    
    [self.view addSubview:navigationView];
}

- (void)backButtonClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)shareButtonClicked:(id)sender
{
    
}

- (void)requestBarberDetail
{
    BarberRequest *request = [[BarberRequest alloc] initWithBarberId:@""];
    [request requestonSuccess:^(ZBaseRequest *request) {
        _barberModel = [BarberModel objectWithKeyValues:[request.resultDic objectForKey:@"data"]];
        [_headerView setModel:_barberModel];
        [self updateCellKeyArray];
    }
                     onFailed:^(ZBaseRequest *request, NSError *error) {
                         
                     }];
}

- (void)requestSotreInfo
{
    StoreRequest *request = [[StoreRequest alloc] initWithItemId:@"" targetId:@"" barberId:@""];
    [request requestonSuccess:^(ZBaseRequest *request) {
        _storeModel = [StoreModel objectWithKeyValues:[request.resultDic objectForKey:@"data"]];
        [self updateCellKeyArray];
    }
                     onFailed:^(ZBaseRequest *request, NSError *error) {
                         
                     }];
}

- (void)requestBarberServeList
{
    BarberServeRequest *request = [[BarberServeRequest alloc] initWithBarberId:@""];
    [request requestonSuccess:^(ZBaseRequest *request) {
        _servesArray = [BarberServeModel objectsArrayWithKeyValuesArray:[request.resultDic objectForKey:@"data"]];
        [self updateCellKeyArray];
    }
                     onFailed:^(ZBaseRequest *request, NSError *error) {
        
                     }];
}

- (void)requestBarberWorks
{
    BarberWorksRequest *request = [[BarberWorksRequest alloc] initWithBarberId:@""];
    [request requestonSuccess:^(ZBaseRequest *request) {
        _worksArray = [BarberWorkModel objectsArrayWithKeyValuesArray:[request.resultDic objectForKey:@"data"]];
        [self updateCellKeyArray];
    }
                     onFailed:^(ZBaseRequest *request, NSError *error) {
                         
                     }];
}

#pragma mark - UITableViewDeleagte
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _cellKeyArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0;
    NSString *cellKey = [_cellKeyArray objectAtIndex:indexPath.row];
    switch ([cellKey intValue]) {
        case 1801:
            height = [BarberIntroCell heightOfIntroCellFrom:_barberModel];
            break;
        case 1802:
            height = [StoreCell heightOfInfoCellFrom:_storeModel];
            break;
        case 1803:
            height = [BarberServeCell heithOfBarberServesCellFrom:_servesArray.count isShowAll:_isShowAllBarberServes];
            break;
        case 1804:
            height = 37 + 8 + (96+20)*kMainBoundsWidth/320.f + 8 + 8;
            break;
        default:
            break;
    }
    
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    NSString *cellKey = [_cellKeyArray objectAtIndex:indexPath.row];
    switch ([cellKey intValue]) {
        case 1801:{
            BarberIntroCell *retCell = [tableView dequeueReusableCellWithIdentifier:kBarberIntroCellKey];
            if (!retCell) {
                retCell = [[BarberIntroCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kBarberIntroCellKey];
            }
            [retCell setModel:_barberModel];
            
            cell = retCell;
            break;
        }
        case 1802:{
            StoreCell *retCell = [tableView dequeueReusableCellWithIdentifier:kStoreInfoCellKey];
            if (!retCell) {
                retCell = [[StoreCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kStoreInfoCellKey];
            }
            [retCell setModel:_storeModel];
            
            cell = retCell;
            break;
        }
        case 1803:{
            BarberServeCell *retCell = [tableView dequeueReusableCellWithIdentifier:kServeItemCellKey];
            if (!retCell) {
                retCell = [[BarberServeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kServeItemCellKey];
                retCell.delegate = self;
            }
            [retCell updateCellWith:_servesArray isShowAll:_isShowAllBarberServes];
            
            cell = retCell;
            break;
        }
        case 1804:{
            BarberWorksCell *retCell = [tableView dequeueReusableCellWithIdentifier:kBarberWorksCellKey];
            if (!retCell) {
                retCell = [[BarberWorksCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kBarberWorksCellKey];
                retCell.leftView.delegate = self;
                retCell.midView.delegate = self;
                retCell.rightView.delegate = self;
            }
            [retCell setWorksArray:_worksArray];
            
            cell = retCell;
            break;
        }
        default:
            break;
    }
    
    return cell;
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

#pragma mark - BarberWorkViewDelegate
- (void)didSelectWork:(BarberWorkModel *)model
{
    
}

#pragma mark - 
- (void)showAllBarberServes
{
    _isShowAllBarberServes = YES;
    [_tableView reloadData];
}

@end
