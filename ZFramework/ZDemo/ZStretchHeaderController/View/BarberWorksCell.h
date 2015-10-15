//
//  BarberWorksCell.h
//  BeautyLaudApp
//
//  Created by ronglei on 15/10/10.
//  Copyright © 2015年 LaShou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BarberWorkView.h"

@interface BarberWorksCell : UITableViewCell

@property (strong, nonatomic) NSArray *worksArray;

@property (strong, nonatomic) BarberWorkView *midView;
@property (strong, nonatomic) BarberWorkView *leftView;
@property (strong, nonatomic) BarberWorkView *rightView;

@end
