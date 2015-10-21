//
//  StoreListViewController.m
//  ZFramework
//
//  Created by ronglei on 15/10/14.
//  Copyright © 2015年 ronglei. All rights reserved.
//

#import "StoreListViewController.h"
#import "ZPullTableView.h"

#import "StoreModel.h"
#import "StoreListCell.h"
#import "ZBaseRequest.h"

@interface StoreListViewController()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) ZPullTableView *tableView;
@property (strong, nonatomic) NSMutableArray *storesArray;

@end

@implementation StoreListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupDatas];
    [self setupViews];


    [self sendRequest:YES];
    [_tableView refreshTableAction];
}

- (void)setupDatas
{
    _storesArray = [[NSMutableArray alloc] init];
}

- (void)setupViews
{
    [self customBackButton];
    [self setTitle:@"门店列表"];
    [self customRightButtonWithTitle:@"刷新" action:@selector(refresh:)];
    
    _tableView = [[ZPullTableView alloc] initWithFrame:CGRectMake(0, 0, kMainBoundsWidth, kMainBoundsHeight - 64)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = kBackgroundColor;
    _tableView.totalCount = 1000;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
}

- (void)refresh:(id)sender
{
    [_tableView refreshTableAction];
}

- (void)sendRequest:(BOOL)refresh
{
    if (refresh) {
        [_storesArray removeAllObjects];
    }
    NSArray *array = [StoreModel objectsArrayWithKeyValuesArray:[[[ZBaseRequest localDataFromPath:SourcePath(@"shop_list", @"json")] objectForKey:@"data"] objectForKey:@"result"]];
    [_storesArray addObjectsFromArray:array];
    [_tableView refreshData];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _storesArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kHairSalonImageHeight*kMainBoundsWidth/320 + 75;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    StoreListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StoreListCell"];
    if (!cell) {
        cell = [[StoreListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"StoreListCell"];
    }
    
    [cell setModel:[_storesArray objectAtIndex:indexPath.row]];
    
    return cell;
}

- (void)refreshTableView:(ZPullTableView *)tableView
{
    [self sendRequest:YES];
}

- (void)loadMoreTableView:(ZPullTableView *)tableView
{
    [self sendRequest:NO];
}
@end
