//
//  BarberWorksCell.m
//  BeautyLaudApp
//
//  Created by ronglei on 15/10/10.
//  Copyright © 2015年 LaShou. All rights reserved.
//

#import "BarberWorksCell.h"

#define kItemWidth  96
#define kMargin 8

@interface BarberWorksCell()

@end

@implementation BarberWorksCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 9, 100, 21)];
        titleLabel.font = [UIFont systemFontOfSize:15];
        titleLabel.textColor = kMainColor;
        titleLabel.text = @"作品展示";
        [self.contentView addSubview:titleLabel];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 37, kMainBoundsWidth, 0.5f)];
        lineView.backgroundColor = kSeperateLineColor;
        [self.contentView addSubview:lineView];
        
        CGFloat widthScale = kMainBoundsWidth/320.f;
        _leftView = [[BarberWorkView alloc] initWithFrame:CGRectMake(kMargin*widthScale, kMargin + 37, kItemWidth*widthScale, (kItemWidth+20)*widthScale)];
        [self.contentView addSubview:_leftView];
        _midView = [[BarberWorkView alloc] initWithFrame:CGRectMake(_leftView.right + kMargin*widthScale, kMargin + 37, kItemWidth*widthScale, (kItemWidth+20)*widthScale)];
        [self.contentView addSubview:_midView];
        _rightView = [[BarberWorkView alloc] initWithFrame:CGRectMake(_midView.right + kMargin*widthScale, kMargin + 37, kItemWidth*widthScale, (kItemWidth+20)*widthScale)];
        [self.contentView addSubview:_rightView];
        [self.contentView addSubview:[ZHelper seperateCellWithY:_leftView.bottom + 8]];
    }
    
    return self;
}

- (void)setWorksArray:(NSArray *)worksArray
{
    [_leftView setModel:[worksArray objectAtIndex:0]];
    [_midView setModel:[worksArray objectAtIndex:1]];
    [_rightView setModel:[worksArray objectAtIndex:2]];
}

@end
