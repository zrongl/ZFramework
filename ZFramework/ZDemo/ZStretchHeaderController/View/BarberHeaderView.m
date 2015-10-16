//
//  BarberHeaderView.m
//  BeautyLaudApp
//
//  Created by ronglei on 15/10/9.
//  Copyright © 2015年 LaShou. All rights reserved.
//

#import "BarberHeaderView.h"
#import "UIImageView+AFNetworking.h"

#define kTopMargin  64

@interface BarberHeaderView()

@property (strong, nonatomic) UIImageView *headerImageView;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *mottoLabel;
@property (strong, nonatomic) UIView *contentView;
@property (strong, nonatomic) UILabel *attenCountLabel;
@property (strong, nonatomic) UILabel *orderCountLabel;

@end

@implementation BarberHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake((frame.size.width - 70.f)/2, 8+kTopMargin, 70, 70)];
        _headerImageView.image = [UIImage imageNamed:@"header.png"];
        _headerImageView.layer.cornerRadius = 35.f;
        _headerImageView.layer.borderColor = kSeperateLineColor.CGColor;
        _headerImageView.layer.borderWidth  = 2.f;
        _headerImageView.clipsToBounds = YES;
        [self addSubview:_headerImageView];
        
        _nameLabel = [ZHelper labelWithFrame:CGRectMake((frame.size.width - 52)/2, 84.f+kTopMargin, 52.f, 21)
                                       fontSize:15
                                          color:[UIColor whiteColor]
                                  textAlignment:NSTextAlignmentCenter];
        [self addSubview:_nameLabel];
        
        _mottoLabel = [ZHelper labelWithFrame:CGRectMake(8, 110+kTopMargin, frame.size.width - 16, 21.f)
                                        fontSize:13
                                           color:[UIColor whiteColor]
                                   textAlignment:NSTextAlignmentCenter];
        [self addSubview:_mottoLabel];
        
        _contentView = [[UIView alloc] initWithFrame:CGRectMake((frame.size.width - 240)/2, 131+kTopMargin, 240, 21)];
        _contentView.backgroundColor = [UIColor clearColor];
        
        _attenCountLabel = [ZHelper labelWithFrame:CGRectMake(40, 0, 76, 21)
                                             fontSize:13
                                                color:[UIColor whiteColor]
                                        textAlignment:NSTextAlignmentRight];
        [_contentView addSubview:_attenCountLabel];
        _orderCountLabel = [ZHelper labelWithFrame:CGRectMake(120, 0, 76, 21)
                                             fontSize:13
                                                color:[UIColor whiteColor]
                                        textAlignment:NSTextAlignmentRight];
        [_contentView addSubview:_orderCountLabel];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(120, 4, 0.5, 13)];
        lineView.backgroundColor = [UIColor whiteColor];
        [_contentView addSubview:lineView];
        
        [self addSubview:_contentView];
    }
    
    return self;
}

- (void)attentButtonClicked:(id)sender
{
    
}

- (void)setModel:(BarberModel *)model
{
    _model = model;
    
    [_headerImageView setImageWithURL:[NSURL URLWithString:model.imgPath] placeholderImage:nil];
    _nameLabel.text = model.name;
    _mottoLabel.text = model.motto;
    
    NSString *prefixString = [NSString stringWithFormat:@"%@ ", model.fansNum];
    NSString *rearString = @"关注";
    NSString *totalString = [NSString stringWithFormat:@"%@%@", prefixString, rearString];
    NSDictionary *postion = @{[NSString stringWithFormat:@"%d", (int)prefixString.length]:
                                  [NSString stringWithFormat:@"%d", (int)rearString.length]
                              };
    _attenCountLabel.attributedText = [totalString attributStringWithPosition:postion color:kMainColor font:[UIFont systemFontOfSize:13]];
    
    prefixString = [NSString stringWithFormat:@"%@ ", model.orderNum];
    rearString = @"订单";
    totalString = [NSString stringWithFormat:@"%@%@", prefixString, rearString];
    postion = @{[NSString stringWithFormat:@"%d", (int)prefixString.length]:
                    [NSString stringWithFormat:@"%d", (int)rearString.length]
                };
    _orderCountLabel.attributedText = [totalString attributStringWithPosition:postion color:kMainColor font:[UIFont systemFontOfSize:13]];
}

@end
