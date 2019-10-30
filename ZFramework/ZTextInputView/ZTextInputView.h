//
//  ZTextInputView.h
//  ZFramework
//
//  Created by ronglei on 2017/4/20.
//  Copyright © 2017年 ronglei. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kTextInputViewH 48

@protocol ZTextInputViewDelegate <NSObject>

- (void)didChangeText:(NSString *)text;

@end

@interface ZTextInputView : UIView

@property (weak, nonatomic) id <ZTextInputViewDelegate>delegate;

- (void)rsgFirstResponder;
- (void)bcmFirstResponder;
- (void)setPlaceholderText:(NSString *)text;

@end
