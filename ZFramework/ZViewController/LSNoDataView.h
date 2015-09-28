//
//  LSNoDataView.h
//  LaShouGroup
//
//  Created by ronglei on 15/1/14.
//  Copyright (c) 2015年 LASHOU-INC. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LSNoDataViewDelegate;

@interface LSNoDataView : UIView

@property (assign, nonatomic) id<LSNoDataViewDelegate>delegate;

+ (LSNoDataView *)viewFromNib;
- (void)showInView:(UIView *)suprView;
- (void)hide;

@end

@protocol LSNoDataViewDelegate <NSObject>
@optional

- (void)noDataRetryGetData;

@end