//
//  ZPullTableView.m
//  ZFramework
//
//  Created by ronglei on 15/10/8.
//  Copyright © 2015年 ronglei. All rights reserved.
//

#import "ZConstant.h"
#import "ZPullTableView.h"
#import "UIView+ZAddition.h"
#import "ZLoadMoreTableFooterView.h"
#import "EGORefreshTableHeaderView.h"

@interface ZPullTableView()<EGORefreshTableHeaderDelegate, UIScrollViewDelegate>
{
    EGORefreshTableHeaderView   *_refreshHeaderView;
    ZLoadMoreTableFooterView    *_loadMoreFooterView;
    NSSet                       *_interceptSelectors;
    BOOL                        _isPullRefreshing;
    BOOL                        _isPullLoadingMore;
    id                          _realDelegate;
    
    NSInteger                   _loadedCount;
}

@end

@implementation ZPullTableView

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        
        _refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, -self.height, self.width, self.height)];
        _refreshHeaderView.delegate = self;
        [self addSubview:_refreshHeaderView];
        
        _loadMoreFooterView = [[ZLoadMoreTableFooterView alloc] initWithFrame:CGRectMake(0, 0, self.width, 48)];
        self.tableFooterView = _loadMoreFooterView;
        
        // 拦截代理消息集合 存储本类(UITableView)拦截父类(UIScrollView)的协议列表
        _interceptSelectors = [[NSSet alloc] initWithObjects:NSStringFromSelector(@selector(scrollViewDidScroll:)),
                                                             NSStringFromSelector(@selector(scrollViewDidEndDragging:willDecelerate:)), nil];
        
        self.totalCount = 0;    // 调用setter方法 设置footerView状态
        _loadedCount = 0;
        _isPullRefreshing = NO;
        _isPullLoadingMore = NO;
        
        // 拦截父类(UIScrollView)的代理方法 所以将super.delegate赋值为self
        super.delegate = (id)self;
    }
    
    return self;
}

- (void)setDelegate:(id<UITableViewDelegate>)delegate
{
    // 对拦截的消息进行响应后 再将该消息传递给该delegate
    _realDelegate = delegate;
    super.delegate = (id)self;
}

- (void)setTotalCount:(NSInteger)totalCount
{
    _totalCount = totalCount;
    if (_totalCount == 0) {
        [_loadMoreFooterView setState:ZPullLoadNoData];
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

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetY = scrollView.contentOffset.y;
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
                if (_realDelegate && [_realDelegate respondsToSelector:@selector(refreshTableView:)]) {
                    _isPullLoadingMore = YES;
                    [_loadMoreFooterView setState:ZPullLoading];
                    [_realDelegate loadMoreTableView:self];
                }
            }
        }else{
            [_loadMoreFooterView setState:ZPullLoadNormal];
        }
    }
    
    // transform the message to the real delegate
    if ([_realDelegate respondsToSelector:@selector(scrollViewDidScroll:)]) {
        [_realDelegate scrollViewDidScroll:scrollView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView.contentOffset.y <= 0) {
        [_refreshHeaderView egoRefreshScrollViewDidEndDragging:self];
    }
    
    // transform the message to the real delegate
    if ([_realDelegate respondsToSelector:@selector(scrollViewDidEndDragging:willDecelerate:)]) {
        [_realDelegate scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    }
}

#pragma mark EGORefreshTableHeaderDelegate
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view
{
    _isPullRefreshing = YES;
    if (_realDelegate && [_realDelegate respondsToSelector:@selector(refreshTableView:)]) {
        [_realDelegate refreshTableView:self];
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


//-----------------------------子类拦截父类代理方法-----------------------------//
/**
 *  如果包含指定消息 返回YES 进行拦截
 *
 *  @param aSelector 消息名称
 *
 *  @return 包含指定消息则返回YES
 */
- (BOOL)respondsToSelector:(SEL)aSelector
{
    if ([_interceptSelectors containsObject:NSStringFromSelector(aSelector)]) {
        return YES;
    } else if ([_realDelegate respondsToSelector:aSelector]) {
        return YES;
    }
    
    return [super respondsToSelector:aSelector];
}

/**
 *  消息重定向 如果包含指定消息 指定self为消息的接收者
 *
 *  @param aSelector 消息名称
 *
 *  @return 指定消息的接收者
 */
- (id)forwardingTargetForSelector:(SEL)aSelector
{
    if ([_interceptSelectors containsObject:NSStringFromSelector(aSelector)]) {
        return self;
    } else if ([_realDelegate respondsToSelector:aSelector]) {
        return _realDelegate;
    }
    
    return [super forwardingTargetForSelector:aSelector];
}

@end

