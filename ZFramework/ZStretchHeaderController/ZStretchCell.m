//
//  ZStretchCell.m
//  ZFramework
//
//  Created by ronglei on 16/6/16.
//  Copyright © 2016年 ronglei. All rights reserved.
//

#import "ZStretchCell.h"

@implementation ZStretchCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    _layerLabel = [[ZLayerLabel alloc] initWithFrame:self.contentView.bounds];
    [self.contentView addSubview:_layerLabel];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setTextString:(NSAttributedString *)string
{
//    _label.attributedText = string;
    _layerLabel.attributedText = string;
}

@end
