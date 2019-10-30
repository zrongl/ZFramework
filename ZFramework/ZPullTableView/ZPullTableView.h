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

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style headerHidden:(BOOL)headerHidden footerHidden:(BOOL)footerHidden;

/**
 *  按钮触发的请求之前调用，设置refreshHeaderView的状态
 */
- (void)refreshTableAction;

/**
 *  注意：此方法是在刷新或加载请求完成之后重新加载数据所用
 *  之所以不用重载tableView的reloadData方法：
 *  为了避免刚进入界面后，设置完tableView后系统会自动调用reloadData方法，
 *  此前如果调用了refreshTableAction方法，会将refreshHeaderView设为normal状态
 *  所以重写了reloadData方法
 */
- (void)reloadData;

/**
 *  请求失败时 重置headerView状态
 */
- (void)resetHeaderView;

- (void)disablePullAction;
- (void)enablePullAction;

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
