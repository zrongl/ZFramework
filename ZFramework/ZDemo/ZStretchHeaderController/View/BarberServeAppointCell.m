//
//  BarberServeAppointCell.m
//  BeautyLaudApp
//
//  Created by ronglei on 15/10/9.
//  Copyright © 2015年 LaShou. All rights reserved.
//

#import "BarberServeAppointCell.h"

@interface BarberServeAppointCell()

@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *priceLabel;
@property (strong, nonatomic) UILabel *huiLabel;
@property (strong, nonatomic) UIButton *appointButton;

@end

@implementation BarberServeAppointCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        CGFloat widthScale = kMainBoundsWidth/320.f;
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 12, 150*widthScale, 21)];
        _nameLabel.font = [UIFont systemFontOfSize:15];
        _nameLabel.textColor = [UIColor blackColor];
        [self.contentView addSubview:_nameLabel];
        
        _huiLabel = [ZHelper createLabelWithFrame:CGRectMake(0, 4, 24, 14)
                                          fontSize:10
                                             color:[UIColor whiteColor]
                                     textAlignment:NSTextAlignmentCenter];
        _huiLabel.backgroundColor = kMainColor;
        _huiLabel.clipsToBounds = YES;
        _huiLabel.text = @"惠";
        _huiLabel.hidden = YES;
        _huiLabel.layer.cornerRadius = 3;
        [self.contentView addSubview:_huiLabel];
        
        _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(166*widthScale, 12, 54*widthScale, 21)];
        _priceLabel.font = [UIFont systemFontOfSize:15];
        _priceLabel.textColor = kMainColor;
        [self.contentView addSubview:_priceLabel];
        
        _appointButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _appointButton.frame = CGRectMake((kMainBoundsWidth - 54), 10, 46, 26);
        _appointButton.layer.cornerRadius = 5.f;
        _appointButton.layer.borderWidth = 1.f;
        _appointButton.layer.borderColor = kMainColor.CGColor;
        _appointButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [_appointButton setTitle:@"预约" forState:UIControlStateNormal];
        [_appointButton setTitleColor:kMainColor forState:UIControlStateNormal];
        [_appointButton addTarget:self action:@selector(appointButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_appointButton];
        
        UIView *bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 45.5, kMainBoundsWidth, 0.5f)];
        bottomLineView.backgroundColor = kSeperateLineColor;
        [self.contentView addSubview:bottomLineView];
    }
    
    return self;
}

- (void)appointButtonClicked:(id)sender
{
    
}

- (void)setModel:(BarberServeModel *)model
{
    _model = model;

    _nameLabel.text = model.serveName;
    if ([model.isActivity boolValue]) {
        CGFloat w = [model.serveName widthWithFont:_nameLabel.font height:21.f];
        _huiLabel.left = 8 + w;
        _huiLabel.hidden = NO;
    }else{
        _huiLabel.hidden = YES;
    }
    
    if ([model.isBasePrice boolValue]) {
        NSString *prefixString = [NSString stringWithFormat:@"￥%@", model.price];
        NSString *rearString = @"起";
        NSString *totalString = [NSString stringWithFormat:@"%@%@", prefixString, rearString];
        NSDictionary *postion = @{[NSString stringWithFormat:@"%d", (int)prefixString.length]:
                                      [NSString stringWithFormat:@"%d", (int)rearString.length]
                                  };
        _priceLabel.attributedText = [totalString attributStringWithPosition:postion color:nil font:[UIFont systemFontOfSize:11]];
    }else{
        _priceLabel.text = [NSString stringWithFormat:@"￥%@", model.price];
    }
}

@end
