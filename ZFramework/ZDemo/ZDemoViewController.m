//
//  ZDemoViewController.m
//  ZFramework
//
//  Created by ronglei on 15/10/20.
//  Copyright © 2015年 ronglei. All rights reserved.
//

#import "ZPhoto.h"
#import "ZDemoViewController.h"
#import "ZPhotoBrowserController.h"
#import "StoreListViewController.h"
#import "ZStretchHeaderController.h"

@interface ZDemoViewController() <UITableViewDelegate, UITableViewDataSource>

{
    NSArray     *_dataSource;
    UITableView *_tableView;
}

@end

@implementation ZDemoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _dataSource = [NSArray arrayWithObjects:@"刷新TableView", @"图片浏览", @"头部拉伸效果", nil];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kMainBoundsWidth, kMainBoundsHeight)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:_tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //dequeue cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    cell.textLabel.text = [_dataSource objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
        {
            StoreListViewController* vc = [[StoreListViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 1:
        {
            NSArray *networkImages= @[@"http://ww3.sinaimg.cn/bmiddle/8e88b0c1gw1e9lpr0nly5j20pf0gygo6.jpg",
                                      @"http://ww4.sinaimg.cn/bmiddle/8e88b0c1gw1e9lpr1d0vyj20pf0gytcj.jpg",
                                      @"http://ww3.sinaimg.cn/bmiddle/8e88b0c1gw1e9lpr1xydcj20gy0o9q6s.jpg",
                                      @"http://ww2.sinaimg.cn/bmiddle/8e88b0c1gw1e9lpr2n1jjj20gy0o9tcc.jpg",
                                      @"http://ww2.sinaimg.cn/bmiddle/8e88b0c1gw1e9lpr39ht9j20gy0o6q74.jpg",
                                      @"http://ww3.sinaimg.cn/bmiddle/8e88b0c1gw1e9lpr3xvtlj20gy0obadv.jpg",
                                      @"http://ww4.sinaimg.cn/bmiddle/8e88b0c1gw1e9lpr4nndfj20gy0o9q6i.jpg",
                                      @"http://ww3.sinaimg.cn/bmiddle/8e88b0c1gw1e9lpr57tn9j20gy0obn0f.jpg"];
            NSMutableArray *array = [NSMutableArray array];
            for (NSString *url in networkImages) {
                ZPhoto *photo = [[ZPhoto alloc] init];
                photo.url = url;
                [array addObject:photo];
            }
            
            ZPhotoBrowserController *vc = [[ZPhotoBrowserController alloc] init];
            vc.photosArray = array;
            vc.currentPhotoIndex = 3;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 2:
        {
            ZStretchHeaderController *vc = [[ZStretchHeaderController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 3:
        {

        }
        case 4:
        {

            break;
        }
        default:
            break;
    }
}

@end
