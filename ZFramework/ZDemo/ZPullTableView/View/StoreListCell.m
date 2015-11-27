//
//  HairSalonCell.m
//  BeautyLaudApp
//
//  Created by ronglei on 15/9/23.
//  Copyright © 2015年 LaShou. All rights reserved.
//

#import "StoreListCell.h"
#import "UIImageView+AFNetworking.h"

@interface StoreListCell()

@property (strong, nonatomic) UIImageView *imgView;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *numberLabel;
@property (strong, nonatomic) UILabel *addressLabel;
@property (strong, nonatomic) UILabel *priceLabel;
@property (strong, nonatomic) UILabel *distanceLabel;

@property (strong, nonatomic) UIImageView *goImageView;
@property (strong, nonatomic) UIImageView *xsyhImageView;

@end

@implementation StoreListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        CGFloat widthScale = kMainBoundsWidth/320.f;
        _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kMainBoundsWidth, kHairSalonImageHeight*widthScale)];
        [self.contentView addSubview:_imgView];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, _imgView.bottom + 8, 226*widthScale, 21.f)];
        _nameLabel.font = [UIFont systemFontOfSize:15.f];
        _nameLabel.textColor = kTextDarkColor;
        [self.contentView addSubview:_nameLabel];
        
        _numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(kMainBoundsWidth - 108, _imgView.bottom + 4, 100, 21)];
        _numberLabel.font = [UIFont systemFontOfSize:14];
        _numberLabel.textColor = kTextDarkColor;
        _numberLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_numberLabel];
        
        _addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, _nameLabel.bottom, 274*widthScale, 21)];
        _addressLabel.font = [UIFont systemFontOfSize:12];
        _addressLabel.textColor = kTextDarkColor;
        [self.contentView addSubview:_addressLabel];
        
        _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, _addressLabel.bottom, 200*widthScale, 21)];
        _priceLabel.font = [UIFont systemFontOfSize:15];
        _priceLabel.textColor = kMainColor;
        [self.contentView addSubview:_priceLabel];
        
        _distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(kMainBoundsWidth - 108, _addressLabel.bottom + 4, 100, 21)];
        _distanceLabel.font = [UIFont systemFontOfSize:14];
        _distanceLabel.textColor = kTextDarkColor;
        _distanceLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_distanceLabel];
        
        _goImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kMainBoundsWidth - 8 - 30, 8, 30, 30)];
        _goImageView.image = [UIImage imageNamed:@"quguo.png"];
        [self.contentView addSubview:_goImageView];
        _xsyhImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kMainBoundsWidth - 84, _imgView.height - 8 - 28, 84, 28)];
        _xsyhImageView.image = [UIImage imageNamed:@"xsyh_round.png"];
        [self.contentView addSubview:_xsyhImageView];
        
        UIView *bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, _distanceLabel.bottom - 0.5f, kMainBoundsWidth, 0.5f)];
        bottomLineView.backgroundColor = kSeperateLineColor;
        [self.contentView addSubview:bottomLineView];
    }
    
    return self;
}

- (void)setModel:(StoreModel *)model
{
    NSString *prefixString = [NSString stringWithFormat:@"%@  ", model.storeName];
    NSString *rearString = [NSString stringWithFormat:@"%@分", model.overAll];
    NSString *totalString = [NSString stringWithFormat:@"%@%@", prefixString, rearString];
    NSDictionary *postion = @{[NSString stringWithFormat:@"%d", (int)prefixString.length]:
                    [NSString stringWithFormat:@"%d", (int)rearString.length]
                };
    _nameLabel.attributedText = [totalString attributStringWithPosition:postion color:kMainColor font:nil];

    prefixString = [NSString stringWithFormat:@"￥%@ ", model.startPrice];
    rearString = @"起";
    totalString = [NSString stringWithFormat:@"%@%@", prefixString, rearString];
    postion = @{[NSString stringWithFormat:@"%d", (int)prefixString.length]:
                    [NSString stringWithFormat:@"%d", (int)rearString.length]
                };
    _priceLabel.attributedText = [totalString attributStringWithPosition:postion color:kTextDarkColor font:[UIFont systemFontOfSize:13]];
    
    _addressLabel.text = model.address;
    _numberLabel.text = [NSString stringWithFormat:@"接单：%@", model.orderNum];
    _distanceLabel.text = [NSString stringWithFormat:@"%@m", model.distance];
    [_imgView setImageWithURL:[NSURL URLWithString:model.path] placeholderImage:nil];
}

@end
