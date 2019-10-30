//
//  StoreListViewController.m
//  ZFramework
//
//  Created by ronglei on 15/10/14.
//  Copyright © 2015年 ronglei. All rights reserved.
//

#import "ZPullTableViewController.h"
#import "ZPullTableView.h"

#import "ZBaseRequest_v2.h"

@interface ZPullTableViewController()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) ZPullTableView *tableView;
@property (strong, nonatomic) NSMutableArray *storesArray;

@end

@implementation ZPullTableViewController

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
    for (int i = 0; i < 20; i ++) {
        [_storesArray addObject:@([[NSDate date] timeIntervalSince1970]).stringValue];
    }
}

- (void)setupViews
{
    [self setTitle:@"门店列表"];
    [self rightButtonItemWithTitle:@"刷新" action:@selector(refresh:)];
    
    _tableView = [[ZPullTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64)
                                                 style:UITableViewStylePlain
                                          headerHidden:NO
                                          footerHidden:NO];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.totalCount = 1000;
    [self.view addSubview:_tableView];
}

- (void)refresh:(id)sender
{
    [_tableView refreshTableAction];
}

- (void)sendRequest:(BOOL)refresh
{
    @weakify(self)
    int64_t delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        @strongify(self)
        if (!refresh) {
            [self.storesArray addObjectsFromArray:@[@([[NSDate date] timeIntervalSince1970]).stringValue,
                                                    @([[NSDate date] timeIntervalSince1970]).stringValue,
                                                    @([[NSDate date] timeIntervalSince1970]).stringValue,
                                                    @([[NSDate date] timeIntervalSince1970]).stringValue,
                                                    @([[NSDate date] timeIntervalSince1970]).stringValue,
                                                    @([[NSDate date] timeIntervalSince1970]).stringValue,
                                                    @([[NSDate date] timeIntervalSince1970]).stringValue,
                                                    @([[NSDate date] timeIntervalSince1970]).stringValue,
                                                    @([[NSDate date] timeIntervalSince1970]).stringValue,
                                                    @([[NSDate date] timeIntervalSince1970]).stringValue]];
        }
        [self.tableView reloadData];
    });
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _storesArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITVC"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITVC"];
    }
    
    cell.textLabel.text = _storesArray[indexPath.row];
    
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
