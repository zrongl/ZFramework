//
//  SubAnimationView.m
//  ZFramework
//
//  Created by ronglei on 2017/6/13.
//  Copyright © 2017年 ronglei. All rights reserved.
//

#import "SubAnimationView.h"
#import "Masonry.h"

@implementation SubAnimationView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor orangeColor];
        _sub = [[UIImageView alloc] initWithFrame:self.bounds];
        _sub.backgroundColor = [UIColor lightGrayColor];
        _sub.image = [UIImage imageNamed:@"timg"];
        [self addSubview:_sub];
//        [_sub mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.edges.equalTo(self);
//        }];
    }
    
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    _sub.frame = self.bounds;
}

@end
