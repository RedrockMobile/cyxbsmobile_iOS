//
//  FeedBackDetailsViewController.m
//  CyxbsMobile2019_iOS
//
//  Created by Edioth Jin on 2021/8/23.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "FeedBackDetailsViewController.h"
//view
#import "FeedBackDetailsTableViewCell.h"
#import "FeedBackReplyTableViewCell.h"
//model
#import "FeedBackDetailsRequestDataModel.h"

@interface FeedBackDetailsViewController ()
<UITableViewDelegate, UITableViewDataSource>

/// 展示反馈和回复
@property (nonatomic, strong) UITableView * feedBackDetailsTableView;
/// 刷新
@property (nonatomic, strong) MJRefreshStateHeader * feedBackStateHeader;

/// 储存数据的数组
@property (nonatomic, copy) NSArray * detailsAry;

@end

@implementation FeedBackDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configureView];
}

#pragma mark - config

- (void)configureView {
    // config self
    self.view.backgroundColor = [UIColor colorNamed:@"242_243_248_1&29_29_29_1"];
    self.VCTitleStr = @"历史反馈";
    self.titlePosition = TopBarViewTitlePositionLeft;
    self.splitLineColor = [UIColor colorNamed:@"221_230_244_1&43_44_45_1"];
    self.titleFont = [UIFont fontWithName:PingFangSCBold size:22];
    self.titleColor = [UIColor colorNamed:@"21_49_91_1&240_240_242_1"];
    
    // config feedBackDetailsTableView
    [self.view addSubview:self.feedBackDetailsTableView];
    CGRect bounds = self.view.bounds;
    bounds.size.height -= [self getTopBarViewHeight];
    bounds.origin.y += [self getTopBarViewHeight];
    self.feedBackDetailsTableView.frame = bounds;
    [self.feedBackDetailsTableView.mj_header beginRefreshing];
}

#pragma mark - tableview delegate & data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.detailsAry.count;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        FeedBackDetailsTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:[FeedBackDetailsTableViewCell reuseIdentifier]];
        cell.cellModel = self.detailsAry[indexPath.section];
        return cell;
    } else {
        FeedBackReplyTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:[FeedBackReplyTableViewCell reuseIdentifier]];
        cell.cellModel = self.detailsAry[indexPath.section];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        FeedBackDetailsTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:[FeedBackDetailsTableViewCell reuseIdentifier]];
        cell.bounds = tableView.bounds;
        cell.cellModel = self.detailsAry[indexPath.section];
        return cell.height;
    } else {
        FeedBackReplyTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:[FeedBackReplyTableViewCell reuseIdentifier]];
        cell.bounds = tableView.bounds;
        cell.cellModel = self.detailsAry[indexPath.section];
        return cell.height;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - mj_refresh

- (void)refreshFeedBackDetails {
    [FeedBackDetailsRequestDataModel getDataArySuccess:^(NSArray * _Nonnull array) {
        self.detailsAry = array;
        [self.feedBackDetailsTableView reloadData];
        [self.feedBackDetailsTableView.mj_header endRefreshing];
    } failure:^{
        [self.feedBackDetailsTableView.mj_header endRefreshing];
    }];
}


#pragma mark - getter

- (UITableView *)feedBackDetailsTableView {
    if (_feedBackDetailsTableView == nil) {
        _feedBackDetailsTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _feedBackDetailsTableView.delegate = self;
        _feedBackDetailsTableView.dataSource = self;
        _feedBackDetailsTableView.backgroundColor = [UIColor clearColor];
        [_feedBackDetailsTableView registerClass:[FeedBackDetailsTableViewCell class] forCellReuseIdentifier:[FeedBackDetailsTableViewCell reuseIdentifier]];
        [_feedBackDetailsTableView registerClass:[FeedBackReplyTableViewCell class] forCellReuseIdentifier:[FeedBackReplyTableViewCell reuseIdentifier]];
        _feedBackDetailsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _feedBackDetailsTableView.mj_header = self.feedBackStateHeader;
    }
    return _feedBackDetailsTableView;
}

- (MJRefreshStateHeader *)feedBackStateHeader {
    if (_feedBackStateHeader == nil) {
        _feedBackStateHeader = [MJRefreshStateHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshFeedBackDetails)];
        _feedBackStateHeader.lastUpdatedTimeLabel.hidden = YES;
    }
    return _feedBackStateHeader;
}

@end
