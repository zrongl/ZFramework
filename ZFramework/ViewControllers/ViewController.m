//
//  ViewController.m
//  ZFramework
//
//  Created by ronglei on 15/9/25.
//  Copyright © 2015年 ronglei. All rights reserved.
//

#import "stdlib.h"
#import "ZToastView.h"
#import "ZLocationView.h"
#import "ViewController.h"
#import "ZStarGradeView.h"
#import "ZPullTableView.h"
#import "ZTextAttributes.h"
#import "UIView+ZAddition.h"
#import <CoreLocation/CoreLocation.h>

#import "ZDemoViewController.h"
#import "CollectionViewCell.h"

#import "ZArchiveCache.h"

#import "ZRequestSessionManager.h"
#import "ZBaseRequest.h"
#import "ZRequestDemo.h"
#import "SqliteDB.h"

#import "CNLoopProgressView.h"
#import "CNShortVideoPlayerView.h"

#import "ZProgressView.h"

@interface ViewController()<UICollectionViewDelegate, UICollectionViewDataSource>

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"统计"];
    
    SqliteDB *db = [[SqliteDB alloc] init];
    
    NSString *value = @"value";
    [db dbSaveKey:@"testkey" value:[value dataUsingEncoding:NSUTF8StringEncoding]];
    DBModel *m = [db dbQueryWithKey:@"testkey"];
    NSLog(@"%@",  m);
    
    [db dbClose];
    
    
    UIButton *button = [ZHelper buttonWithFrame:CGRectMake((kScreenWidth - 120)/2, kScreenHeight*0.6, 120, 30) title:@"推出" action:@selector(pushInTo) target:self];
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
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 124) collectionViewLayout:flowLayout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [self.view addSubview:collectionView];
    
    UINib *nib = [UINib nibWithNibName:@"CollectionViewCell" bundle:nil];
    [collectionView registerNib:nib forCellWithReuseIdentifier:@"CollectionViewCell"];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 200, kScreenWidth-30, 0)];
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
    
    NSString *time = @"1476874312";
    NSLog(@"%@", time.timeStampToTimeString);
    
    CAGradientLayer *timeLineLayer = [CAGradientLayer layer];
    UIColor *sColor = RGBA(0, 0, 0, 1);
    UIColor *eColor = RGBA(0, 0, 0, 0);
    timeLineLayer.colors = @[(id)sColor.CGColor, (id)eColor.CGColor];
    timeLineLayer.frame = CGRectMake(15, 100, 2, 200);
    timeLineLayer.locations = @[@(0.8),@(1.0)];
    [self.view.layer addSublayer:timeLineLayer];
    
    CNLoopProgressView *progressView = [[CNLoopProgressView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    progressView.center = self.view.center;
    [self.view addSubview:progressView];
//
//    NSString *location = @"file:///Users/ronglei/Desktop/mp4";
//    NSString *path = @"/Users/ronglei/Desktop/3242364578";
//
//    [[NSFileManager defaultManager] moveItemAtURL:[NSURL URLWithString:location] toURL:[NSURL URLWithString:[@"file://" stringByAppendingString:path]] error:nil];
//
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    BOOL exist = [fileManager fileExistsAtPath:path];
//    NSError *error = nil;
//    if (exist) {
//        [fileManager removeItemAtPath:path error:&error];
//    }
    
//    CNShortVideoPlayerView *player = [[CNShortVideoPlayerView alloc] initWithFrame:CGRectMake(0, 64, 320, 421)];
//    player.pathString = @"/Users/ronglei/Desktop/1234567.mp4";
//    [self.view addSubview:player];
//    [player play];
    
    [[ZBaseRequest new] downloadRequestWithUrl:@"http://img1.store.ksmobile.net/cmnews/20161129/13/3142787_14229fdc_148042693692_420_236.mp4"
                                    saveToPath:nil
                              downloadProgress:^(long long bytes, long long totalBytes) {
                                  NSLog(@"%f", 1.0 * bytes/totalBytes);
                                  [progressView setProgress:1.0 * bytes/totalBytes];
                              }
                                       success:^(NSURLResponse *response, NSString *filePath) {
                                           NSLog(@"%@", filePath);
                                       }
                                       failure:^(NSURLResponse *response, NSError * _Nonnull error) {
                                           NSLog(@"download failed");
                                       }];
//    [self imageSizeFromURL:@"http://img1.store.ksmobile.net/cmnews/20161129/16/83372_7ae13af2_148043870625_640_823.jpg"];
    
}

- (CGSize)imageSizeFromURL:(NSString *)urlString
{
    NSString *lastPathName = [[urlString lastPathComponent] stringByDeletingPathExtension];
    NSArray *array = [lastPathName componentsSeparatedByString:@"_"];
    NSInteger count = array.count;
    CGSize size = CGSizeMake([array[count - 2] floatValue], [array[array.count - 1] floatValue]);
    return size;
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
        cell = [CollectionViewCell loadFromNib];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    CollectionViewCell *cell = (CollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
//    CGPoint point = [cell convertPoint:cell.origin toView:mKeyWindow];
//    NSLog(@"");
}

const CGFloat   kCellHeight = 62;
const NSInteger kItemSpacing = 1;
const NSInteger kNumberPerRow = 4;
#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize CellSize ;
    CellSize = CGSizeMake((kScreenWidth - kItemSpacing*kNumberPerRow-1) / kNumberPerRow, kCellHeight);
    return CellSize;
}

@end

@implementation ViewController1

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"清算"];
    
    printf ("%lld\n", get_micro_time());
    printf("%llu\n", dispatch_walltime_date([NSDate date]));
    
    
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
    [self showLoadingViewWithTitle:@"正在加载..."];
    
    for (NSInteger i = 0; i < 4; i++) {
        [ZToastView serialToastWithMessage:@"请稍候" stady:2];
    }
    
    _starView = [[ZStarGradeView alloc] initWithFrame:CGRectMake((kScreenWidth - 200)/2, 100, 200, 25)
                                            grayImage:[UIImage imageNamed:@"star_gray.png"]
                                           lightImage:[UIImage imageNamed:@"star_light"]];
    [self.view addSubview:_starView];
    
    UIButton *button = [ZHelper buttonWithFrame:CGRectMake((kScreenWidth - 120)/2, kScreenHeight*0.6, 120, 30)
                                          title:@"评分"
                                         action:@selector(scoreChange)
                                         target:self];
    [self.view addSubview:button];
    UIButton *pushButton = [ZHelper buttonWithFrame:CGRectMake((kScreenWidth - 120)/2, kScreenHeight*0.6, 120, 30)
                                              title:@"推出"
                                             action:@selector(pushViewController)
                                             target:self];
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
    ZLocationView *loactionView = [[ZLocationView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 28)];
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
}

@end

@interface ViewController4()

@end

@implementation ViewController4

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"弹视图"];
    [self customDismissButton];
    [self rightButtonItemWithTitle:@"发送" action:nil];
}

@end
