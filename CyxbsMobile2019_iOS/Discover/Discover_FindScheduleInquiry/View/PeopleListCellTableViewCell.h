//
//  PeopleListCellTableViewCell.h
//  CyxbsMobile2019_iOS
//
//  Created by 千千 on 2020/1/29.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
// 添加双人课表协议
@protocol AddPeopleClassDelegate <NSObject>

- (void)addPeopleClass:(NSIndexPath *)indexPath;

@end

@interface PeopleListCellTableViewCell : UITableViewCell
/// 当前索引
@property (nonatomic, strong) NSIndexPath *cellIndex;
@property (nonatomic, weak)UILabel *stuNumLabel;//学号
@property (nonatomic, strong) UIButton *addBtn;// 添加双人课表的按钮
@property (nonatomic, weak) id<AddPeopleClassDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
