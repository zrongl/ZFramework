//
//  ZPhotoInfoBar.m
//  ZFramework
//
//  Created by ronglei on 15/10/15.
//  Copyright © 2015年 ronglei. All rights reserved.
//

#import "ZPhotoInfoBar.h"
#import "ZPhoto.h"

@interface ZPhotoInfoBar()

{
    UILabel         *_titleLabel;
    UILabel         *_pageIndexLabel;
    UIScrollView    *_infoScrollView;
    UILabel         *_infoLabel;
}

@end

@implementation ZPhotoInfoBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _titleLabel = [ZHelper labelWithFrame:CGRectMake(8, 8, self.width*0.75, 20)
                                           fontSize:16
                                              color:[UIColor whiteColor]
                                      textAlignment:0];
        _titleLabel.text = @"李晓峰的作品";
        [self addSubview:_titleLabel];
        _pageIndexLabel = [ZHelper labelWithFrame:CGRectMake(self.width - 64, 8, 56, 20)
                                               fontSize:15
                                                  color:[UIColor whiteColor]
                                          textAlignment:NSTextAlignmentRight];
        [self addSubview:_pageIndexLabel];
        
        _infoScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, _titleLabel.bottom + 4, self.width, self.height - 76)];
        _infoScrollView.showsVerticalScrollIndicator = YES;
        _infoScrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
        _infoLabel = [ZHelper labelWithFrame:CGRectMake(8, 0, self.width - 16, _infoScrollView.height)
                                    fontSize:13
                                       color:[UIColor whiteColor]
                               textAlignment:0];
        _infoLabel.numberOfLines = 0;
        [_infoScrollView addSubview:_infoLabel];
        [self addSubview:_infoScrollView];
        
        [self addSubview:[ZHelper seperateLineWithY:self.height - 43.5 color:RGB(70, 70, 70)]];

    }
    
    return self;
}

- (void)saveButtonAction:(id)sender
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        ZPhoto *photo = _photos[_currentPhotoIndex];
        UIImageWriteToSavedPhotosAlbum(photo.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    });
}

- (void)setCurrentPhotoIndex:(NSUInteger)currentPhotoIndex
{
    _currentPhotoIndex = currentPhotoIndex;
    _pageIndexLabel.text = [NSString stringWithFormat:@"%lu/%lu", (unsigned long)_currentPhotoIndex, (unsigned long)_photos.count];
    
    NSString *text = @"沈腾多次上春晚 沈腾多次上春晚 网易娱乐10月15日报道 2016央视猴年春晚正在紧张筹备当中,继魔术师傅琰东接受到春晚导演组邀请外,“开心麻花”沈腾. 沈腾多次上春晚 网易娱乐10月15日报道 2016央视猴年春晚正在紧张筹备当中,继魔术师傅琰东接受到春晚导演组邀请外,“开心麻花”沈腾.";
    _infoLabel.text = text;
    CGFloat height = [text heightWithFont:_infoLabel.font width:_infoLabel.width];
    _infoLabel.height = height;
    _infoScrollView.contentSize = CGSizeMake(0, height);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error) {
        // 保存失败
    } else {
        // 保存成功
    }
}
@end
