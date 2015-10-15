//
//  ServeItemCell.h
//  BeautyLaudApp
//
//  Created by ronglei on 15/10/9.
//  Copyright © 2015年 LaShou. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kBarberServeCellHeight  46

@protocol BarberServeCellDelegate;

@interface BarberServeCell : UITableViewCell

@property (strong, nonatomic) NSArray *servesArray;
@property (assign, nonatomic) id<BarberServeCellDelegate>delegate;

+ (CGFloat)heithOfBarberServesCellFrom:(NSInteger)count isShowAll:(BOOL)isShowAll;
- (void)updateCellWith:(NSArray *)servesArray isShowAll:(BOOL)isShowAll;

@end

@protocol BarberServeCellDelegate <NSObject>

- (void)showAllBarberServes;

@end