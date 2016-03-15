//
//  ZPullTableView.m
//  ZFramework
//
//  Created by ronglei on 15/10/8.
//  Copyright © 2015年 ronglei. All rights reserved.
//

#import "ZPullTableView.h"
#import "FBKVOController.h"
#import "ZLoadMoreTableFooterView.h"
#import "EGORefreshTableHeaderView.h"

@interface ZPullTableView()<EGORefreshTableHeaderDelegate, UIScrollViewDelegate>
{
    NSInteger                   _loadedCount;
    id                          _pullDelegate;
    FBKVOController             *_KVOController;
    BOOL                        _isPullRefreshing;
    BOOL                        _isPullLoadingMore;
    EGORefreshTableHeaderView   *_refreshHeaderView;
    ZLoadMoreTableFooterView    *_loadMoreFooterView;
}

@end

@implementation ZPullTableView

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style headerHidden:(BOOL)headerHidden footerHidden:(BOOL)footerHidden
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        
        if (!headerHidden) {
            _refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, -self.height, self.width, self.height)];
            _refreshHeaderView.delegate = self;
            [self addSubview:_refreshHeaderView];
        }
        
        if (!footerHidden) {
            _loadMoreFooterView = [[ZLoadMoreTableFooterView alloc] initWithFrame:CGRectMake(0, 0, self.width, 48)];
            self.tableFooterView = _loadMoreFooterView;
        }
        
        _totalCount = 0;    // 调用setter方法 设置footerView状态
        _loadedCount = 0;
        _isPullRefreshing = NO;
        _isPullLoadingMore = NO;
        
        _KVOController = [FBKVOController controllerWithObserver:self];
        __weak typeof (self) weakSelf = self;
        [_KVOController observe:self
                        keyPath:@"contentOffset"
                        options:NSKeyValueObservingOptionNew
                        block:^(id observer, id object, NSDictionary *change) {
                            [weakSelf scrollViewScrolling];
                        }];
    }
    
    return self;
}

- (void)setDelegate:(id<UITableViewDelegate>)delegate
{
    // 对拦截的消息进行响应后 再将该消息传递给该delegate
    _pullDelegate = delegate;
    super.delegate = delegate;
}

- (void)setTotalCount:(NSInteger)totalCount
{
    _totalCount = totalCount;
    if (_totalCount == 0) {
        [_loadMoreFooterView setState:ZPullLoadNoData];
    }else{
        [_loadMoreFooterView setState:ZPullLoadNormal];
    }
}

- (void)refreshTableAction
{
    // 保证同一时间只有一个正在请求的任务，否则不会重新进行刷新
    if (!_isPullLoadingMore && !_isPullRefreshing) {
        _isPullRefreshing = YES;
        [_refreshHeaderView  egoRefreshScrollViewDataSourceDidBeginLoading:self];
        if (_pullDelegate && [_pullDelegate respondsToSelector:@selector(refreshTableView:)]) {
            [_pullDelegate refreshTableView:self];
        }
    }
}

- (void)reloadData
{
    if (_isPullRefreshing) {
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self];
    }else if (_isPullLoadingMore){
        [_loadMoreFooterView setState:ZPullLoadNormal];
    }
    _isPullLoadingMore = NO;
    _isPullRefreshing = NO;
    
    [super reloadData];
}

- (void)resetHeaderView
{
    _isPullRefreshing = NO;
    [_refreshHeaderView  egoRefreshScrollViewDataSourceDidFinishedLoading:self];
}

- (void)scrollViewScrolling
{
    if (self.isDragging) {
        CGFloat offsetY = self.contentOffset.y;
        if (offsetY < 0) {
            [_refreshHeaderView egoRefreshScrollViewDidScroll:self];
        }else{
            NSInteger totalOffsetY = self.height + offsetY;
            _loadedCount = totalOffsetY/46 + (totalOffsetY%46 > 0 ? 1 : 0);
            /**
             *  @_loadedCount < _totalCount : 是否加载足够数量
             *  @!_isPullLoadingMore        : 是否正在请求下一页数据 防止多次发送请求
             *  @!_isPullRefreshing         : 是否正在刷新请求
             *  @totalOffsetY + 100 > self.contentSize.height   : 是否滑动到距离底部100像素的位置 如果小于100则自动发送请求加载更多数据
             */
            if (_loadedCount < _totalCount) {
                if (!_isPullLoadingMore &&!_isPullRefreshing && totalOffsetY + 100 > self.contentSize.height) {
                    if (_pullDelegate && [_pullDelegate respondsToSelector:@selector(refreshTableView:)]) {
                        _isPullLoadingMore = YES;
                        [_loadMoreFooterView setState:ZPullLoading];
                        [_pullDelegate loadMoreTableView:self];
                    }
                }
            }else{
                [_loadMoreFooterView setState:ZPullLoadNormal];
            }
        }
    }else{
        if (self.decelerating) {
            if (self.contentOffset.y <= 0) {
                [_refreshHeaderView egoRefreshScrollViewDidEndDragging:self];
            }
        }
    }
}

#pragma mark EGORefreshTableHeaderDelegate
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view
{
    _isPullRefreshing = YES;
    if (_pullDelegate && [_pullDelegate respondsToSelector:@selector(refreshTableView:)]) {
        [_pullDelegate refreshTableView:self];
    }
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view
{
    return _isPullRefreshing;
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view
{
    return [NSDate date];
}

@end

