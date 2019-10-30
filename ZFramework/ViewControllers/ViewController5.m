//
//  ViewController5.m
//  ZFramework
//
//  Created by ronglei on 16/6/2.
//  Copyright © 2016年 ronglei. All rights reserved.
//

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
    
}

- (IBAction)use:(id)sender
{
    
}

- (IBAction)clear:(id)sender
{
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

@end
