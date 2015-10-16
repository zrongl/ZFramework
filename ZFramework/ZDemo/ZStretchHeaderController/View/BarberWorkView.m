//
//  BarberWorkView.m
//  BeautyLaudApp
//
//  Created by ronglei on 15/10/12.
//  Copyright © 2015年 LaShou. All rights reserved.
//

#import "BarberWorkView.h"
#import "UIImageView+AFNetworking.h"

@interface BarberWorkView()

@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UILabel *remarkLabel;
@property (strong, nonatomic) UILabel *numberLabel;

@end

@implementation BarberWorkView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = 2.f;
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.width)];
        _imageView.layer.cornerRadius = 2.f;
        _imageView.userInteractionEnabled = NO;
        [self addSubview:_imageView];
        _remarkLabel = [ZHelper labelWithFrame:CGRectMake(0, _imageView.bottom, self.width, self.height-self.width)
                                         fontSize:14
                                            color:[UIColor blackColor]
                                    textAlignment:0];
        [self addSubview:_remarkLabel];
        _numberLabel = [ZHelper labelWithFrame:CGRectMake(self.width-25, self.width-25, 20, 20)
                                         fontSize:13
                                            color:[UIColor whiteColor]
                                    textAlignment:NSTextAlignmentCenter];
        _numberLabel.backgroundColor = [UIColor darkGrayColor];
        _numberLabel.layer.cornerRadius = 10;
        _numberLabel.clipsToBounds = YES;
        [self addSubview:_numberLabel];
    }
    
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.backgroundColor = kBackgroundColor;
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.backgroundColor = [UIColor whiteColor];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.backgroundColor = [UIColor whiteColor];
    [_delegate didSelectWork:_model];
}

- (void)setModel:(BarberWorkModel *)model
{
    NSString *path = @"http://localhost/meiye/item.png";
    
    [_imageView setImageWithURL:[NSURL URLWithString:path] placeholderImage:nil];
    _remarkLabel.text = model.remark;
    _numberLabel.text = [NSString stringWithFormat:@"%ld", (unsigned long)model.pathsArray.count];
}

@end
