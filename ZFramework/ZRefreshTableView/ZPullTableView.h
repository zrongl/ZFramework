//
//  ZPullTableView.h
//  ZFramework
//
//  Created by ronglei on 15/10/8.
//  Copyright © 2015年 ronglei. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZPullTableViewDelegate;

@interface ZPullTableView : UITableView

/**
 *  需要跟服务器协商 每次请求返回服务端数据的总条数
 */
@property (assign, nonatomic) NSInteger totalCount;

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style;

@end

@protocol ZPullTableViewDelegate <NSObject>

@optional
/**
 *  下拉刷新数据代理方法
 *
 *  @param tableView tableView
 */
- (void)refreshTableView:(ZPullTableView *)tableView;

/**
 *  上拉加载更多数据代理方法
 *
 *  @param tableView tableView
 */
- (void)loadMoreTableView:(ZPullTableView *)tableView;

@end
