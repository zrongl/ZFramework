//
//  ZStretchCell.h
//  ZFramework
//
//  Created by ronglei on 16/6/16.
//  Copyright © 2016年 ronglei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZAsyncLayer.h"
#import "ZLayerLabel.h"

@interface ZStretchCell : UITableViewCell<ZAsyncLayerDelegate>

@property (nonatomic, weak) IBOutlet UILabel *label;
@property (nonatomic, strong) ZLayerLabel *layerLabel;

- (void)setTextString:(NSAttributedString *)string;

@end
