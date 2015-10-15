//
//  BarberWorkView.h
//  BeautyLaudApp
//
//  Created by ronglei on 15/10/12.
//  Copyright © 2015年 LaShou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BarberWorkModel.h"

@protocol BarberWorkViewDelegate;

@interface BarberWorkView : UIView

@property (assign, nonatomic) id<BarberWorkViewDelegate>delegate;
@property (strong, nonatomic) BarberWorkModel *model;

@end

@protocol BarberWorkViewDelegate <NSObject>

- (void)didSelectWork:(BarberWorkModel *)model;

@end