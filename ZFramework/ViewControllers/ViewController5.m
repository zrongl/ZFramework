//
//  ViewController5.m
//  ZFramework
//
//  Created by ronglei on 16/6/2.
//  Copyright © 2016年 ronglei. All rights reserved.
//

#import "ZArchiveCache.h"
#import "ViewController5.h"
#import "ZKeyboardManager.h"

@interface ViewController5 ()<ZKeyboardObserver>

@property (nonatomic, weak) IBOutlet UITextField *textFiled;

@end

@implementation ViewController5

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[ZKeyboardManager defaultManager] addObserver:self];
}

- (void)keyboardWillChangeFrame:(CGRect)frame duration:(CGFloat)duration
{
    NSLog(@"");
}

- (void)keyboardWillHide
{
    
}

- (IBAction)save:(id)sender
{
    ZDemoModel *m = [ZDemoModel objectWithKeyValues:@{@"n":_textFiled.text}];
    mArchiveCache.model = m;
    [mArchiveCache saveAvhiverCache];
}

- (IBAction)use:(id)sender
{
    [mArchiveCache resetArchiveCache];
    _textFiled.text = mArchiveCache.model.name;
}

- (IBAction)clear:(id)sender
{
    [mArchiveCache clearArchiveCache];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

@end
