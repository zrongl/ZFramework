//
//  EGOLoadMoreTableFooterView.h
//  ZFramework
//
//  Created by ronglei on 15/10/8.
//  Copyright © 2015年 ronglei. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    ZPullLoading = 0,
    ZPullLoadNormal,
    ZPullLoadNoData
}ZPullLoadState;

@interface ZLoadMoreTableFooterView : UIView

@property (assign, nonatomic) ZPullLoadState state;

@end
