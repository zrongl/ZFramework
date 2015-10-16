//
//  StoreCell.m
//  BeautyLaudApp
//
//  Created by ronglei on 15/10/9.
//  Copyright © 2015年 LaShou. All rights reserved.
//

#import "StoreCell.h"

@interface StoreCell()

@property (strong, nonatomic) UILabel *storeNameLabel;
@property (strong, nonatomic) UILabel *overAllLabel;
@property (strong, nonatomic) UILabel *orderNumLabel;
@property (strong, nonatomic) UILabel *addressLabel;
@property (strong, nonatomic) UILabel *distanceLabel;


@end

@implementation StoreCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        CGFloat widthScale = kMainBoundsWidth/320.f;
        _storeNameLabel = [ZHelper labelWithFrame:CGRectMake(8, 8, 158*widthScale, 21)
                                               fontSize:15
                                                  color:kMainColor
                                          textAlignment:0];
        [self.contentView addSubview:_storeNameLabel];
        
        _overAllLabel = [ZHelper labelWithFrame:CGRectMake(kMainBoundsWidth - 136, 8, 40, 21)
                                             fontSize:13
                                                color:[UIColor blackColor]
                                        textAlignment:NSTextAlignmentRight];
        [self.contentView addSubview:_overAllLabel];
        
        _orderNumLabel = [ZHelper labelWithFrame:CGRectMake(kMainBoundsWidth - 88, 8, 65, 21)
                                              fontSize:13
                                                 color:[UIColor blackColor]
                                         textAlignment:0];
        [self.contentView addSubview:_orderNumLabel];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(kMainBoundsWidth-16, 11, 8, 14)];
        imageView.image = [UIImage imageNamed:@"arraw_right.png"];
        [self.contentView addSubview:imageView];
        
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 32, 12, 15)];
        imageView.image = [UIImage imageNamed:@"address_img.png"];
        [self.contentView addSubview:imageView];
        
        _addressLabel = [ZHelper labelWithFrame:CGRectMake(26.f, 30, kMainBoundsWidth-26-62, 0)
                                             fontSize:13
                                                color:[UIColor blackColor]
                                        textAlignment:0];
        _addressLabel.numberOfLines = 0;
        [self.contentView addSubview:_addressLabel];
        
        _distanceLabel = [ZHelper labelWithFrame:CGRectMake(kMainBoundsWidth-8-54, 49, 54, 21)
                                              fontSize:13
                                                 color:[UIColor blackColor]
                                         textAlignment:NSTextAlignmentRight];
        [self.contentView addSubview:_distanceLabel];
    }
    
    return self;
}

+ (CGFloat)heightOfInfoCellFrom:(StoreModel *)model
{
    CGFloat height = 30.f;
    CGFloat h = [model.address heightWithFont:[UIFont systemFontOfSize:13] width:kMainBoundsWidth-30-62];
    height += h < 21 ? 21 : h;
    height += 8.f;
    height += 8.f;
    
    return height;
}

- (void)setModel:(StoreModel *)model
{
    _model = model;
    _storeNameLabel.text = model.storeName;
    _orderNumLabel.text = [NSString stringWithFormat:@"接单%@", model.orderNum];
    
    NSString *prefixString = [NSString stringWithFormat:@"%@", model.overAll];
    NSString *rearString = @"分";
    NSString *totalString = [NSString stringWithFormat:@"%@%@", prefixString, rearString];
    NSDictionary *postion = @{[NSString stringWithFormat:@"%d", (int)prefixString.length]:
                                  [NSString stringWithFormat:@"%d", (int)rearString.length]
                              };
    _overAllLabel.attributedText = [totalString attributStringWithPosition:postion color:kMainColor font:nil];
    
    _addressLabel.text = model.address;
    CGFloat height = [model.address heightWithFont:[UIFont systemFontOfSize:13] width:kMainBoundsWidth-30-62];
    _addressLabel.height = height < 21 ? 21 : height;
    _distanceLabel.text = [NSString stringWithFormat:@"%@m", model.distance];
    _distanceLabel.bottom = _addressLabel.bottom;
    
    [self.contentView addSubview:[ZHelper seperateCellWithY:_distanceLabel.bottom + 8]];
}
@end
