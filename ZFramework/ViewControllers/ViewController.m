//
//  ViewController.m
//  ZFramework
//
//  Created by ronglei on 15/9/25.
//  Copyright © 2015年 ronglei. All rights reserved.
//

#import "ViewController.h"
#import "stdlib.h"
#import "ZLocationView.h"
#import "ZToastView.h"
#import "ZStarGradeView.h"
#import "ZPullTableView.h"
#import "ZTextAttributes.h"
#import "UIView+ZAddition.h"
#import <CoreLocation/CoreLocation.h>

#import "ZDemoViewController.h"
#import "CollectionViewCell.h"

@interface ViewController()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (strong, nonatomic) UIView *btn_1;
@property (strong, nonatomic) UIView *btn_2;
@property (strong, nonatomic) UIView *btn_3;
@property (strong, nonatomic) UIView *btn_4;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"统计"];
    
    UIButton *button = [ZHelper buttonWithFrame:CGRectMake((kMainBoundsWidth - 120)/2, kMainBoundsHeight*0.6, 120, 30) title:@"推出" action:@selector(pushInTo) target:self];
    [self.view addSubview:button];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    // 每行内部cell item的间距
    flowLayout.minimumInteritemSpacing = 1;
    // 每行的间距
    flowLayout.minimumLineSpacing = 1;
    // 布局方式改为从上至下，默认从左到右
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    // Section Inset就是某个section中cell的边界范围
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kMainBoundsWidth, 124) collectionViewLayout:flowLayout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [self.view addSubview:collectionView];
    
    UINib *nib = [UINib nibWithNibName:@"CollectionViewCell" bundle:nil];
    [collectionView registerNib:nib forCellWithReuseIdentifier:@"CollectionViewCell"];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 200, kMainBoundsWidth-30, 0)];
    label.backgroundColor = [UIColor lightGrayColor];
    NSString *string = @"大家好：我是谁";
    NSString *substring = @"大家好：";
    
    label.attributedText =  ZTextAttributes
                            .string(string)
                            .font([UIFont systemFontOfSize:16])
                            .lineSpace(7)
                            .subcolor([UIColor orangeColor], substring)
                            .attributeString(CGFLOAT_MAX);
    label.height =  ZTextAttributes
                    .string(string)
                    .font([UIFont systemFontOfSize:16])
                    .lineSpace(7)
                    .subcolor([UIColor orangeColor], substring)
                    .attributeStringHeight(CGFLOAT_MAX);
    [self.view addSubview:label];
    
}

- (void)pushInTo
{
    ZDemoViewController *vc = [[ZDemoViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 5;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionViewCell" forIndexPath:indexPath];
    if (!cell){
        cell = [CollectionViewCell loadViewFromNib];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

const CGFloat   kCellHeight = 62;
const NSInteger kItemSpacing = 1;
const NSInteger kNumberPerRow = 4;
#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize CellSize ;
    CellSize = CGSizeMake((kMainBoundsWidth - kItemSpacing*kNumberPerRow-1) / kNumberPerRow, kCellHeight);
    return CellSize;
}

@end

@implementation ViewController1

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"清算"];
    [self showLoadingViewWithTitle:@"正在加载..."];
    
    for (NSInteger i = 0; i < 4; i++) {
        [ZToastView serialToastWithMessage:@"请稍候" stady:2];
    }
}

@end

@interface ViewController2()

@property (strong, nonatomic) ZStarGradeView *starView;

@end

@implementation ViewController2

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"我的"];
    
    _starView = [[ZStarGradeView alloc] initWithFrame:CGRectMake((kMainBoundsWidth - 200)/2, 100, 200, 25)
                                                           grayImage:[UIImage imageNamed:@"star_gray.png"]
                                                          lightImage:[UIImage imageNamed:@"star_light"]];
    [self.view addSubview:_starView];
    
    UIButton *button = [ZHelper buttonWithFrame:CGRectMake((kMainBoundsWidth - 120)/2, kMainBoundsHeight*0.6, 120, 30) title:@"评分" action:@selector(scoreChange) target:self];
    [self.view addSubview:button];
    UIButton *pushButton = [ZHelper buttonWithFrame:CGRectMake((kMainBoundsWidth - 120)/2, kMainBoundsHeight*0.6, 120, 30) title:@"推出" action:@selector(pushViewController) target:self];
    pushButton.y = button.bottom + 20.f;
    [self.view addSubview:pushButton];
    
    // location view
    if(![CLLocationManager locationServicesEnabled] ||
       [CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied){
        
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 90000
        UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"提示"
                                                                           message:@"需要开启定位服务,请到设置->隐私,打开定位服务"
                                                                    preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定"
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * _Nonnull action) {
                                                           
                                                       }];
        [alertView addAction:action];
        [self presentViewController:alertView animated:YES completion:nil];
#else
        UIAlertView *alvertView=[[UIAlertView alloc] initWithTitle:@"提示"
                                                           message:@"需要开启定位服务,请到设置->隐私,打开定位服务"
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles: nil];
        [alvertView show];
#endif
        
    }
    ZLocationView *loactionView = [[ZLocationView alloc] initWithFrame:CGRectMake(0, 0, kMainBoundsWidth, 28)];
    [self.view addSubview:loactionView];
}

- (void)pushViewController
{
    
}

- (void)scoreChange
{
    [_starView setGradeWithScore:fRandom(10) scoreSystem:10 animation:YES];
}

@end

@implementation ViewController3

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"推视图"];
    UIButton *button = [ZHelper buttonWithFrame:CGRectMake((kMainBoundsWidth - 120)/2, kMainBoundsHeight*0.6, 120, 30) title:@"弹出" action:@selector(popTo) target:self];
    [self.view addSubview:button];
}

- (void)popTo
{

}

@end

@interface ViewController4()

@end

@implementation ViewController4

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self customDismissButton];
    [self setTitle:@"弹视图"];
    [self rightButtonItemWithTitle:@"发送" action:nil];
}

@end
