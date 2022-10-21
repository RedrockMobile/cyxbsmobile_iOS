//
//  ScheduleController.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/8/24.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "ScheduleController.h"

#import "SchedulePresenter.h"

#import "ScheduleCollectionViewLayout.h"

#import "ScheduleHeaderView.h"

@interface ScheduleController ()

/// header view
@property (nonatomic, strong) ScheduleHeaderView *headerView;

/// 课表视图
@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation ScheduleController

- (instancetype)initWithPresenter:(SchedulePresenter *)presenter {
    self = [super init];
    if (self) {
        _presenter = presenter;
        presenter.controller = self;
    }
    return self;
}

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    
    [self.presenter.dataSourceService setCollectionView:self.collectionView diff:NO];
    self.presenter.delegateService.collectionView = self.collectionView;
    self.presenter.delegateService.viewController = self;
    
    [self.view addSubview:self.collectionView];
    
    // 请求数据
    [self.presenter.delegateService requestAndReloadData];
}

#pragma mark - Getter

- (ScheduleHeaderView *)headerView {
    if (_headerView == nil) {
        _headerView = [[ScheduleHeaderView alloc] initWithFrame:CGRectMake(0, -1, self.view.width, 64)];
        _headerView.delegate = self.presenter.delegateService;
    }
    return _headerView;
}

- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        CGFloat width = self.view.width;
        
        ScheduleCollectionViewLayout *layout = [[ScheduleCollectionViewLayout alloc] init];
        layout.widthForLeadingSupplementaryView = 30;
        layout.lineSpacing = 2;
        layout.columnSpacing = 2;
        layout.heightForHeaderSupplementaryView = 10 + ((width - layout.widthForLeadingSupplementaryView) / 7 - layout.columnSpacing) / 46 * 50;
        layout.dataSource = self.presenter.dataSourceService;
        
        CGFloat top = 64 + (self.isPushStyle ? StatusBarHeight() : 0);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, top, self.view.width, self.view.height - top) collectionViewLayout:layout];
        
        _collectionView.directionalLockEnabled = YES;
        _collectionView.pagingEnabled = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.backgroundColor =
        [UIColor Light:UIColorHex(#FFFFFF)
                  Dark:UIColorHex(#1D1D1D)];
    }
    return _collectionView;
}

#pragma mark - Setter

- (void)setPresenter:(SchedulePresenter *)presenter {
    _presenter = presenter;
    if (_collectionView) {
        [self.collectionView reloadData];
    }
}

@end
