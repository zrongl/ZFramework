//
//  ViewController5.m
//  ZFramework
//
//  Created by ronglei on 16/6/2.
//  Copyright © 2016年 ronglei. All rights reserved.
//

#import "ZAchiverCache.h"
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
    mAchiverCache.model = m;
    [mAchiverCache saveAvhiverCache];
}

- (IBAction)use:(id)sender
{
    [mAchiverCache resetAchiverCache];
    _textFiled.text = mAchiverCache.model.name;
}

- (IBAction)clear:(id)sender
{
    [mAchiverCache clearAchiverCache];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

@end
