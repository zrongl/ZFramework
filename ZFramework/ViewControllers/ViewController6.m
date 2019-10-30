//
//  ViewController6.m
//  ZFramework
//
//  Created by ronglei on 2017/7/6.
//  Copyright © 2017年 ronglei. All rights reserved.
//

#import "ViewController6.h"
#import "UIImageView+WebCache.h"
#import "Masonry.h"

#define kCNVideoCellHeight (270.0 * SCREEN_WIDTH / 320.0f)
#define kCNInsetTop ((SCREEN_HEIGHT - kCNVideoCellHeight)/2)

@interface ViewController6 ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) UICollectionView *collectionView;
@end

@implementation ViewController6

// 系统navigation bar隐藏及显示操作
- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.85];
    
    _dataSource = [NSArray arrayWithObjects:
                   @"http://10.60.208.93/serve_header.png",
                   @"http://10.60.208.93/serve_header.png",
                   @"http://10.60.208.93/serve_header.png",
                   @"http://10.60.208.93/serve_header.png",
                   @"http://10.60.208.93/serve_header.png",
                   @"http://10.60.208.93/serve_header.png",nil];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 0.0f;
    layout.minimumInteritemSpacing = 0.0f;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:[UIScreen mainScreen].bounds
                                         collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.bounces = YES;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.contentInset = UIEdgeInsetsMake(kCNInsetTop, 0, 0, 0);
    _collectionView.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.85];
    [_collectionView registerClass:[CollectionViewCell1 class]
        forCellWithReuseIdentifier:NSStringFromClass(CollectionViewCell1.class)];
    [self.view addSubview:_collectionView];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 20, 72, 55);
    [backButton setTitleColor:[UIColor colorWithRed:112/255.f green:112/255. blue:112/255.f alpha:1.0]
                     forState:UIControlStateNormal];
    [backButton setTitleEdgeInsets:UIEdgeInsetsMake(9, 0.0, 21.0, 23.0)];
    [backButton setTitle:@"<"
                forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonAction)
         forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
}

- (void)backButtonAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark UICollectionViewDataSource

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                           cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionViewCell1 *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionViewCell1" forIndexPath:indexPath];
    [cell setImageViewUrl:[_dataSource objectAtIndex:indexPath.row]];
    
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    return _dataSource.count;
}

#pragma mark -
#pragma mark UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(SCREEN_WIDTH, kCNVideoCellHeight);
}

#pragma mark -
#pragma mark UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    [self playingSelectedVideoWithIndexPath:indexPath];
}

//- (void)playingSelectedVideoWithIndexPath:(NSIndexPath *)indexPath{
//    
//    _currentIndex = indexPath.row;
//    [self videoPlayerTransiformingWhenDrag];
//    
//    CGFloat pageSize = kCNVideoCellHeight;
//    CGFloat targetY = pageSize * _currentIndex - kCNInsetTop;
//    CGPoint targetPoint = CGPointMake(_collectionView.contentOffset.x, targetY);
//    [_collectionView setContentOffset:targetPoint animated:YES];
//    [self dealWithContentOffset:targetPoint];
//}
//
//- (void)dealWithContentOffset:(CGPoint)contentOffset{
//    if(_requestVideos
//       && !self.isRefreshing
//       && (_collectionView.contentSize.height - (contentOffset.y + kCNInsetTop) - SCREEN_HEIGHT < SCREEN_HEIGHT)){
//        self.isRefreshing = YES;
//        CNContentItem *targetItem = [_videosArray lastObject];
//        CNGetDataURLRequest *request = [CNNewsApiFactory createVideoFreshRequestWithContentID:targetItem.contentid];
//        request.delegate = self;
//        [request loadDataWithPath];
//    }
//}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSArray *visibleCells = [_collectionView visibleCells];
    for (CollectionViewCell1 *cell in visibleCells) {
        
    }
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
}
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView
                     withVelocity:(CGPoint)velocity
              targetContentOffset:(inout CGPoint *)targetContentOffset{
    
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView
                  willDecelerate:(BOOL)decelerate{
    
}


@end


@interface CollectionViewCell1()
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation CollectionViewCell1

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _imageView = [[UIImageView alloc] init];
        [self.contentView addSubview:_imageView];
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
    }
    return self;
}

- (void)setImageViewUrl:(NSString *)url
{
    [_imageView sd_setImageWithURL:[NSURL URLWithString:url]];
}

@end
