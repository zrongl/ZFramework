//
//  StoreCell.h
//  BeautyLaudApp
//
//  Created by ronglei on 15/10/9.
//  Copyright © 2015年 LaShou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoreModel.h"

@interface StoreCell : UITableViewCell

@property (strong, nonatomic) StoreModel *model;

+ (CGFloat)heightOfInfoCellFrom:(StoreModel *)model;

@end
