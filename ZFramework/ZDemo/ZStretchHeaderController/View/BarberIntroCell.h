//
//  BarberIntroCell.h
//  BeautyLaudApp
//
//  Created by ronglei on 15/10/9.
//  Copyright © 2015年 LaShou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BarberModel.h"

@interface BarberIntroCell : UITableViewCell

@property (strong, nonatomic) BarberModel *model;

+ (CGFloat)heightOfIntroCellFrom:(BarberModel *)model;

@end
