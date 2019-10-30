//
//  CollectionViewCell.m
//  ZFramework
//
//  Created by ronglei on 16/3/24.
//  Copyright © 2016年 ronglei. All rights reserved.
//

#import "CollectionViewCell.h"
#import "UIImageView+WebCache.h"
#import "SDImageCache.h"

@interface CollectionViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation CollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [[SDImageCache sharedImageCache] clearMemory];
    [_imageView sd_setImageWithURL:[NSURL URLWithString:@"http://is.cmcmcdn.com/cmcm_mobile_game/avatar/ff34f589c961d99fce6aa125795e10af"]
                  placeholderImage:nil
                           options:SDWebImageCacheMemoryOnly
                         completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                             if (error) {
                                 NSLog(@"%@", error);
                             }
                         }];
    
//    [_imageView setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://is.cmcmcdn.com/cmcm_mobile_game/avatar/ff34f589c961d99fce6aa125795e10af"]]]];
}

@end
