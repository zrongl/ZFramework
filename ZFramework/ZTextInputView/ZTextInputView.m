//
//  ZTextInputView.m
//  ZFramework
//
//  Created by ronglei on 2017/4/20.
//  Copyright © 2017年 ronglei. All rights reserved.
//

#import "ZTextInputView.h"
#import "Masonry.h"

const CGFloat edgeLeft = 10;
const CGFloat edgeRight = 68;
const CGFloat edgeVertical = 6;
const CGFloat maxTextHeight = 150;

@interface ZTextInputView()<UITextViewDelegate>

{
    UITextView  *_textView;
    UIButton    *_sendButton;
    UILabel     *_placeholderLabel;
    
    CGRect      _initialFrame;
    CGRect      _overKeyboardFrame;
}

@end

@implementation ZTextInputView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _initialFrame = frame;
        self.backgroundColor = [UIColor whiteColor];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardShow:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardHide:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
        
        _textView = [[UITextView alloc] init];
        _textView.delegate = self;
        _textView.font = [UIFont systemFontOfSize:15];
        [self addSubview:_textView];
        [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(edgeLeft);
            make.right.equalTo(self).offset(-edgeRight);
            make.top.equalTo(self).offset(edgeVertical);
            make.bottom.equalTo(self);
        }];
        _placeholderLabel = [[UILabel alloc] initWithFrame:_textView.frame];
        _placeholderLabel.font = [UIFont systemFontOfSize:15];
        _placeholderLabel.textColor = [UIColor lightGrayColor];
        _placeholderLabel.userInteractionEnabled = NO;
        [self addSubview:_placeholderLabel];
        [_placeholderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self);
            make.left.equalTo(self).offset(16);
            make.right.equalTo(self).offset(-10);
        }];
        
        _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _sendButton.layer.cornerRadius = kTextInputViewH/2;
        _sendButton.backgroundColor = [UIColor redColor];
        [_sendButton setTitle:@"S" forState:UIControlStateNormal];
        [_sendButton addTarget:self action:@selector(sendButtonClicked:)
              forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_sendButton];
        [_sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self);
            make.right.equalTo(self).offset(-10);
            make.size.mas_equalTo(kTextInputViewH);
        }];
    }
    
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

- (void)keyboardShow:(NSNotification *)note
{
    CGRect keyBoardRect = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat deltaY = keyBoardRect.size.height+100;
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue]
                     animations:^{
                         self.transform = CGAffineTransformMakeTranslation(0, -deltaY);
                         _overKeyboardFrame = self.frame;
                     } completion:^(BOOL finished) {
                     }];
}

- (void)keyboardHide:(NSNotification *)note
{
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue]
                     animations:^{
                         self.transform = CGAffineTransformMakeTranslation(0, 0);
                     } completion:^(BOOL finished) {
                         if (finished) {
                             _textView.text = @"";
                             self.frame = _initialFrame;
                             _placeholderLabel.hidden = NO;
                             [self setSendButtonEnable:NO];
                         }
                     }];
}

- (void)rsgFirstResponder
{
    [_textView resignFirstResponder];
}

- (void)bcmFirstResponder
{
    [_textView becomeFirstResponder];
}

- (void)setPlaceholderText:(NSString *)text
{
    _placeholderLabel.text = text;
}

- (void)sendButtonClicked:(UIButton *)sender
{
    
}

- (void)setSendButtonEnable:(BOOL)enable
{
    _sendButton.enabled = enable;
    UIColor *color = nil;
    if (enable) {
        color = [UIColor colorWithRed:211/255. green:17/255. blue:31/255. alpha:1.0];
    }else{
        color = [UIColor colorWithRed:170/255. green:170/255. blue:170/255. alpha:1.0];
    }
    [_sendButton setTitleColor:color
                      forState:UIControlStateNormal];
}

const NSInteger kTextMaxLength = 100000;
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (text.length > 0) {
        NSString *currentText = textView.text;
        if (text.length == 1) {
            if (currentText.length + 1 < kTextMaxLength) {
                return YES;
            }else{
                NSLog(@"Beyond 10000 words");
                return NO;
            }
        }else{
            if (currentText.length + text.length <= kTextMaxLength) {
                return YES;
            }else{
                NSLog(@"Beyond 10000 words");
                
                NSRange range = NSMakeRange(0, kTextMaxLength - currentText.length);
                NSString *subText = [text substringWithRange:range];
                textView.text = [NSString stringWithFormat:@"%@%@", currentText, subText];
                _placeholderLabel.hidden = YES;
                [self setSendButtonEnable:YES];
                
                [self resizeTextView];
                
                return NO;
            }
        }
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    NSString *regex = @"^\\s*$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    // 输入内容是否有效
    [self setSendButtonEnable:![pred evaluateWithObject:textView.text]];
    _placeholderLabel.hidden = (textView.text.length > 0);
    
    [self resizeTextView];
}

- (void)resizeTextView
{
    //内容框高度小于输入框控件的高度
    CGFloat textHeight = [_textView.text heightWithFont:[UIFont systemFontOfSize:15] width:_textView.width];
    if (textHeight < 20) {
        //单行
        self.frame = _overKeyboardFrame;
    }else{
        //多行
        CGFloat viewHeight = textHeight + 19 + 2*edgeVertical;
        CGRect frame = self.frame;
        if (viewHeight <= maxTextHeight) {
            frame.origin.y -= (viewHeight - frame.size.height);
            frame.size.height = viewHeight;
            self.frame = frame;
        }else{
            frame.origin.y -= (maxTextHeight - frame.size.height);
            self.frame = frame;
            frame.size.height = maxTextHeight;
            self.frame = frame;
        }
    }
}

@end
