//
//  ReactiveController.m
//  ZFramework
//
//  Created by ronglei on 15/11/4.
//  Copyright © 2015年 ronglei. All rights reserved.
//

#import "ReactiveController.h"

@interface ReactiveController ()

@property (strong, nonatomic) NSString *warningText;
@property (strong, nonatomic) IBOutlet UILabel *resultLabel;
@property (strong, nonatomic) IBOutlet UIButton *bt;
@property (strong, nonatomic) IBOutlet UITextField *input;
@property (strong, nonatomic) IBOutlet UITextField *verifyInput;

@end

@implementation ReactiveController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self addSelecter];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_input resignFirstResponder];
    [_verifyInput resignFirstResponder];
}

- (void)addSelecter
{
    @weakify(self);
    
    [[RACObserve(self, warningText) filter:^(NSString *newString) {
        self.resultLabel.text = newString;
        return YES;
    }]
     subscribeNext:^(NSString *newString) {
         @strongify(self);
         self.bt.enabled = [newString hasPrefix:@"Success"];
     }];
    
    
    RAC(self,self.warningText) = [RACSignal combineLatest:@[RACObserve(self,self.input.text),RACObserve(self, self.verifyInput.text)]
                                                   reduce:^(NSString *password, NSString *passwordConfirm){
                                                       if ([passwordConfirm isEqualToString:password]){
                                                           return @"Success";
                                                       }
                                                       else if([password length] == 0 || [passwordConfirm length] ==0 ){
                                                           return @"Please Input";
                                                       }
                                                       else{
                                                           return @"Input Error";
                                                       }
                                                   }];
}

@end
