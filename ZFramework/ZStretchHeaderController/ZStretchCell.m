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
    _label.layer.shadowRadius = 1;
    _label.layer.shadowOffset = CGSizeMake(0, 1);
    _label.layer.shadowColor = [UIColor redColor].CGColor;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setTextString:(NSAttributedString *)string
{
    _label.attributedText = string;
    [self.layer setNeedsDisplay];
}

- ( ZAsyncLayerDisplayTask * _Nullable )newAsyncDisplayTask
{
    ZAsyncLayerDisplayTask *task = [ZAsyncLayerDisplayTask new];
    task.willDisplay = ^(CALayer *layer) {
        
    };
    task.display = ^(CGContextRef context, CGSize size, BOOL (^isCancelled)(void)) {
        
    };
    return task;
}

+ (Class)layerClass
{
    return [ZAsyncLayer class];
}

@end
