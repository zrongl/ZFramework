//
//  ViewController.m
//  ZFramework
//
//  Created by ronglei on 15/9/25.
//  Copyright © 2015年 ronglei. All rights reserved.
//

#import "ViewController.h"
#import "Macro.h"
#import "stdlib.h"
#import "ZHelper.h"
#import "ZToastManager.h"
#import "ZLocationView.h"
#import "ZStarGradeView.h"
#import "UIView+ZAddition.h"
#import "ZStretchHeaderController.h"
#import "ZPullTableView.h"
#import <CoreLocation/CoreLocation.h>

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavigationTitle:@"统计"];
    
    UIButton *button = [ZHelper createButtonWithTitle:@"推出" action:@selector(pushInTo) target:self];
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
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue setMaxConcurrentOperationCount:1];
    
    for (NSInteger i = 0; i < 3; i++) {
        [ZToastManager toastWithMessage:@"请求失败，请稍后重试" stady:2.f];
    }
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
    
    _starView = [[ZStarGradeView alloc] initWithFrame:CGRectMake((kMainBoundsWidth - 200)/2, 100, 200, 25)
                                                           grayImage:[UIImage imageNamed:@"star_gray.png"]
                                                          lightImage:[UIImage imageNamed:@"star_light"]];
    [self.view addSubview:_starView];
    
    UIButton *button = [ZHelper createButtonWithTitle:@"评分" action:@selector(scoreChange) target:self];
    [self.view addSubview:button];
    UIButton *pushButton = [ZHelper createButtonWithTitle:@"推出" action:@selector(pushViewController) target:self];
    pushButton.y = button.bottom + 20.f;
    [self.view addSubview:pushButton];
    
    // location view
    if(![CLLocationManager locationServicesEnabled] ||
       [CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied){
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 90000
        UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"提示"
                                                                           message:@"需要开启定位服务,请到设置->隐私,打开定位服务"
                                                                    preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定"
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * _Nonnull action) {
                                                           
                                                       }];
        [alertView addAction:action];
        [self presentViewController:alertView animated:YES completion:nil];
#else
        UIAlertView *alvertView=[[UIAlertView alloc] initWithTitle:@"提示"
                                                           message:@"需要开启定位服务,请到设置->隐私,打开定位服务"
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles: nil];
        [alvertView show];
#endif
    }
    ZLocationView *loactionView = [[ZLocationView alloc] initWithFrame:CGRectMake(0, 0, kMainBoundsWidth, 28)];
    [self.view addSubview:loactionView];
}

- (void)pushViewController
{
    ZStretchHeaderController *vc = [[ZStretchHeaderController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
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
    UIButton *button = [ZHelper createButtonWithTitle:@"弹出" action:@selector(popTo) target:self];
    [self.view addSubview:button];
}

- (void)popTo
{
    ViewController4 *vc = [[ViewController4 alloc] init];
    ZNavigationController *nav = [[ZNavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}

@end

#import "LoginRequest.h"

@interface ViewController4()<UITableViewDataSource, UITableViewDelegate, ZPullTableViewDelegate>

@property (strong, nonatomic) ZPullTableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataSource;

@end

@implementation ViewController4

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self customDismissButton];
    [self setNavigationTitle:@"弹视图"];
    [self customRightButtonWithTitle:@"发送" action:nil];
    [self setupRefreshTabelView];
}

- (void)setupRefreshTabelView
{
    _tableView = [[ZPullTableView alloc] initWithFrame:CGRectMake(0, 0, kMainBoundsWidth, kMainBoundsHeight - 64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _dataSource = [[NSMutableArray alloc] init];
    [self.view addSubview:_tableView];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 46.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.layer.borderWidth = 0.5f;
        cell.layer.borderColor = kThemeColor.CGColor;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.textLabel.text = [_dataSource objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)refreshTableView:(ZPullTableView *)tableView
{
    [_tableView setTotalCount:50];
    LoginRequest *request = [[LoginRequest alloc] init];
    [request requestonSuccess:^(ZBaseRequest *request) {
        if (_dataSource) {
            [_dataSource removeAllObjects];
        }
        NSArray *list = [request.resultDic objectForKey:@"list"];
        for (NSDictionary *dic in list) {
            [_dataSource addObject:[dic objectForKey:@"title"]];
        }
        [_tableView reloadData];
    }
                     onFailed:^(ZBaseRequest *request, NSError *error) {
                         
                     }];
}

- (void)loadMoreTableView:(ZPullTableView *)tableView
{
    [_tableView setTotalCount:50];
    LoginRequest *request = [[LoginRequest alloc] init];
    [request requestonSuccess:^(ZBaseRequest *request) {
        NSArray *list = [request.resultDic objectForKey:@"list"];
        for (NSDictionary *dic in list) {
            [_dataSource addObject:[dic objectForKey:@"title"]];
        }
        [_tableView reloadData];
    }
                     onFailed:^(ZBaseRequest *request, NSError *error) {
                         
                     }];
}
@end
