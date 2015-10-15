//
//  ServeItemCell.m
//  BeautyLaudApp
//
//  Created by ronglei on 15/10/9.
//  Copyright © 2015年 LaShou. All rights reserved.
//

#import "BarberServeCell.h"
#import "BarberServeAppointCell.h"

#define kServeItemCellHeight    40 + _itemsArray.count*46 + 8

@interface BarberServeCell()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIView *showAllView;

@end

@implementation BarberServeCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 8, 100, 21)];
        titleLabel.font = [UIFont systemFontOfSize:15];
        titleLabel.textColor = kMainColor;
        titleLabel.text = @"服务项目";
        [self.contentView addSubview:titleLabel];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 39.5, kMainBoundsWidth, 0.5f)];
        lineView.backgroundColor = kSeperateLineColor;
        [self.contentView addSubview:lineView];
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, kMainBoundsWidth, 0)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollEnabled = NO;
        _tableView.backgroundColor = kBackgroundColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.contentView addSubview:_tableView];
        
        CGFloat widthScale = kMainBoundsWidth/320.f;
        _showAllView = [[UIView alloc] initWithFrame:CGRectMake(0, 40+kBarberServeCellHeight*3, kMainBoundsWidth, 48)];
        _showAllView.hidden = YES;
        _showAllView.backgroundColor = kBackgroundColor;
        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainBoundsWidth, 40)];
        contentView.backgroundColor = [UIColor whiteColor];
        
        UIButton *showButton = [UIButton buttonWithType:UIButtonTypeCustom];
        showButton.frame = CGRectMake((kMainBoundsWidth - 124*widthScale)/2, (40 - 30*widthScale)/2, 124*widthScale, 30*widthScale);
        showButton.layer.cornerRadius = 5.f;
        showButton.layer.borderWidth = 1.f;
        showButton.layer.borderColor = kMainColor.CGColor;
        showButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [showButton setTitle:@"查看全部服务" forState:UIControlStateNormal];
        [showButton setTitleColor:kMainColor forState:UIControlStateNormal];
        [showButton addTarget:self action:@selector(showAllButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:showButton];
        [_showAllView addSubview:contentView];
        [self.contentView addSubview:_showAllView];
    }
    
    return self;
}

+ (CGFloat)heithOfBarberServesCellFrom:(NSInteger)count isShowAll:(BOOL)isShowAll
{
    CGFloat heightOfRow = kBarberServeCellHeight;
    
    CGFloat height = 40;
    if (isShowAll) {
        height += heightOfRow*count;
        height += 8;
    }else{
        if (count <= 3) {
            height += heightOfRow*count;
            height += 8;
        }else{
            height += heightOfRow*3;
            height += 48;
        }
    }
    
    return height;
}

- (void)updateCellWith:(NSArray *)servesArray isShowAll:(BOOL)isShowAll
{
    NSInteger numberOfRow = servesArray.count;
    CGFloat heightOfRow = kBarberServeCellHeight;
    
    if (isShowAll) {
        _showAllView.hidden = YES;
        _tableView.height = heightOfRow*numberOfRow + 8;
    }else{
        if (numberOfRow <= 3) {
            _showAllView.hidden = YES;
            _tableView.height = heightOfRow*numberOfRow + 8;
        }else{
            _showAllView.hidden = NO;
            _tableView.height = heightOfRow*3;
        }
    }
    
    _servesArray = servesArray;
    [_tableView reloadData];
}

- (void)showAllButtonAction:(id)sender
{
    [ _delegate showAllBarberServes];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _servesArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 46.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BarberServeAppointCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BarberServeAppointCell"];
    if (!cell) {
        cell = [[BarberServeAppointCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BarberServeAppointCell"];
    }
    
    [cell setModel:[_servesArray objectAtIndex:indexPath.row]];
    
    return cell;
}

@end
