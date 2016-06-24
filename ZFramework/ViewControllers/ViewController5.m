//
//  ViewController5.m
//  ZFramework
//
//  Created by ronglei on 16/6/2.
//  Copyright © 2016年 ronglei. All rights reserved.
//

#import "ViewController5.h"
#import "ZAchiverCache.h"
#import "ZKeyboardManager.h"
#import "ViewController.h"
#import "PopAnimation.h"

@interface ViewController5 ()<ZKeyboardObserver, UINavigationControllerDelegate>

@property (nonatomic, weak) IBOutlet UITextField *textFiled;

@end

@implementation ViewController5

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.delegate = self;
    [[ZKeyboardManager defaultManager] addObserver:self];
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
}

- (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                            animationControllerForOperation:(UINavigationControllerOperation)operation
                                                         fromViewController:(UIViewController *)fromVC
                                                           toViewController:(UIViewController *)toVC
{
    return [[PopAnimation alloc] init];
}

- (void)keyboardWillChangeFrame:(CGRect)frame duration:(CGFloat)duration
{
    NSLog(@"");
}

- (void)keyboardWillHide
{

}

- (IBAction)onPushAction:(id)sender
{
    ViewController *vc = [[ViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
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
