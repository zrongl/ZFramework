//
//  BarberServeCell.m
//  BeautyLaudApp
//
//  Created by ronglei on 15/10/9.
//  Copyright © 2015年 LaShou. All rights reserved.
//

#import "BarberIntroCell.h"

@interface BarberIntroCell()

@property (strong, nonatomic) UILabel *awardTitileLabel;
@property (strong, nonatomic) UILabel *introLabel;
@property (strong, nonatomic) UILabel *awardLabel;
@property (strong, nonatomic) UIView *lineView;

@end

@implementation BarberIntroCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILabel *introTitleLabel = [ZHelper createLabelWithFrame:CGRectMake(8, 8, 60, 21)
                                                     fontSize:15
                                                        color:kMainColor
                                                textAlignment:0];
        introTitleLabel.text = @"个人简介";
        [self.contentView addSubview:introTitleLabel];
        
        _introLabel = [ZHelper createLabelWithFrame:CGRectMake(8, 30, kMainBoundsWidth - 16, 0)
                                        fontSize:13
                                           color:[UIColor blackColor]
                                   textAlignment:0];
        _introLabel.numberOfLines = 0;
        [self.contentView addSubview:_introLabel];
        
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(8, 0, kMainBoundsWidth-16, 0.5)];
        _lineView.backgroundColor = kSeperateLineColor;
        _lineView.hidden = YES;
        [self.contentView addSubview:_lineView];
        
        _awardTitileLabel = [ZHelper createLabelWithFrame:CGRectMake(8, 0, 43, 21)
                                              fontSize:14
                                                 color:kMainColor
                                         textAlignment:0];
        _awardTitileLabel.text = @"获奖：";
        _awardTitileLabel.hidden = YES;
        [self.contentView addSubview:_awardTitileLabel];
        
        _awardLabel = [ZHelper createLabelWithFrame:CGRectMake(53, 0, kMainBoundsWidth-53-8, 0)
                                        fontSize:13
                                           color:[UIColor blackColor]
                                   textAlignment:0];
        _awardLabel.hidden = YES;
        _awardLabel.numberOfLines = 0;
        [self.contentView addSubview:_awardLabel];
    }
    
    return self;
}

+ (CGFloat)heightOfIntroCellFrom:(BarberModel *)model
{
    CGFloat height = 30;
    height += [model.profile heightWithFont:[UIFont systemFontOfSize:13] width:kMainBoundsWidth - 16];
    
    if (model.award.length > 0) {
        height += 11.f;
        height += [model.award heightWithFont:[UIFont systemFontOfSize:13] width:kMainBoundsWidth-53-8];
    }
    height += 8;
    height += 8;
    
    return height;
}

- (void)setModel:(BarberModel *)model
{
    _model = model;
    
    _introLabel.text = model.profile;
    _introLabel.height = [model.profile heightWithFont:[UIFont systemFontOfSize:13] width:kMainBoundsWidth - 16];
    
    if (model.award.length > 0) {
        _lineView.hidden = NO;
        _lineView.y = _introLabel.bottom + 8;
        _awardTitileLabel.hidden = NO;
        _awardTitileLabel.y = _lineView.bottom + 5;
        _awardLabel.hidden = NO;
        _awardLabel.y = _lineView.bottom + 3;
        _awardLabel.text = model.award;
        _awardLabel.height = [model.award heightWithFont:[UIFont systemFontOfSize:13] width:kMainBoundsWidth-53-8];
        [self.contentView addSubview:[ZHelper createSeperateCellWithY:_awardLabel.bottom + 8]];
    }else{
        _lineView.hidden = YES;
        _awardLabel.hidden = YES;
        _awardTitileLabel.hidden = YES;
        [self.contentView addSubview:[ZHelper createSeperateCellWithY:_introLabel.bottom + 8]];
    }
}
@end
