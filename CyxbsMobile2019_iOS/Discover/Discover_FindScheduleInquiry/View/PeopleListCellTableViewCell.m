//
//  PeopleListCellTableViewCell.m
//  CyxbsMobile2019_iOS
//
//  Created by 千千 on 2020/1/29.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "PeopleListCellTableViewCell.h"
@interface PeopleListCellTableViewCell()

@end

@implementation PeopleListCellTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self.contentView addSubview:self.addBtn];
        
        [self.imageView setImage:[UIImage imageNamed:@"defaultStudentImage"]];
        if(@available(iOS 11.0,*)){
            self.textLabel.textColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#15315B" alpha:1] darkColor:[UIColor colorWithHexString:@"#F0F0F2" alpha:1]];
        }else{
            self.textLabel.textColor = [UIColor colorWithRed:21/255.0 green:49/255.0 blue:91/255.0 alpha:1];
        }
        self.textLabel.font = [UIFont fontWithName:PingFangSCBold size:15];
        if(@available(iOS 11.0, *)){
            self.detailTextLabel.textColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#15315B" alpha:1] darkColor:[UIColor colorWithHexString:@"#F0F0F2" alpha:1]];
        }else{
            self.detailTextLabel.textColor = [UIColor colorWithRed:21/255.0 green:49/255.0 blue:91/255.0 alpha:1];
        }
        self.detailTextLabel.font = [UIFont fontWithName:PingFangSCRegular size:13];
        [self addStuNumLabel];
        [self setSelectionStyle:(UITableViewCellSelectionStyleNone)];
    }
    
    return self;
}

-(void) addStuNumLabel {
    UILabel *label = [[UILabel alloc]init];
    [self.contentView addSubview:label];
    self.stuNumLabel = label;
    label.font = [UIFont fontWithName:PingFangSCRegular size:11];
    if(@available(iOS 11.0, *)){
        label.textColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#2A4E84" alpha:1] darkColor:[UIColor colorWithHexString:@"#DFDFE3" alpha:1]];
    }else{
        label.textColor = [UIColor colorWithRed:42/255.0 green:78/255.0 blue:132/255.0 alpha:1];
    }
}

- (void)layoutSubviews {
    self.imageView.frame = CGRectMake(19, 18, 48, 48);
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(80);
        make.top.equalTo(self).offset(17);
    }];
    [self.detailTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.textLabel);
        make.top.equalTo(self.textLabel.mas_bottom).offset(7);
    }];
    [self.stuNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.textLabel);
        make.right.equalTo(self).offset(-15);
    }];
    // 添加btn
    [self.addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.stuNumLabel.mas_right);
        make.top.equalTo(self.stuNumLabel.mas_bottom).mas_offset(12);
        make.bottom.equalTo(self.detailTextLabel.mas_bottom);
        make.width.mas_equalTo(16);
        make.height.mas_equalTo(16);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

// 添加关联课表的btn
- (UIButton *)addBtn {
    if (_addBtn == nil) {
        _addBtn = [[UIButton alloc] init];
        [_addBtn setImage:[UIImage imageNamed:@"addPeopleClass"] forState:UIControlStateNormal];
        [_addBtn setImage:[UIImage imageNamed:@"addPeopleClass_selected"] forState:UIControlStateSelected];
        [_addBtn addTarget:self action:@selector(didClickedAddPeopleFromIndex) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addBtn;
}

// 按钮方法：
- (void)didClickedAddPeopleFromIndex {
    // 1.如果先开始没关联
    if(![NSUserDefaults.standardUserDefaults boolForKey:ClassSchedule_correlationClass_BOOL]) {
        self.addBtn.selected = YES;
        [self.delegate addPeopleClass:self.cellIndex];
    }
    // 2.如果已经有关联
    else{
        // 2.1 点击相同的人:取消关注
        if([self judgeIfEqualPeople] == YES) {
            // 2.1.1 取消按钮选择
            self.addBtn.selected = NO;
            // 2.1.2 删除存储
            [NSUserDefaults.standardUserDefaults setBool:NO forKey:ClassSchedule_correlationClass_BOOL];
            [NSUserDefaults.standardUserDefaults removeObjectForKey:ClassSchedule_correlationName_String];
            [NSUserDefaults.standardUserDefaults removeObjectForKey:ClassSchedule_correlationMajor_String];
            [NSUserDefaults.standardUserDefaults removeObjectForKey:ClassSchedule_correlationStuNum_String];
            // 2.1.3 已取消弹窗
            [self.delegate cancelPeopleClass:self.cellIndex];
        }
        // 2.2 点击不同的人:替换关注
        else {
            // 2.2.1 替换弹窗
            [self.delegate replacePeopleClass:self.cellIndex];
//            [self.delegate addPeopleClass:self.cellIndex];
            
        }
    }
}

// 判断是相同？
- (BOOL)judgeIfEqualPeople {
    NSString *getSaveNumber = [NSUserDefaults.standardUserDefaults objectForKey:ClassSchedule_correlationStuNum_String];
    if ([self.stuNumLabel.text isEqualToString:getSaveNumber]) {
        return YES;
    }
    else {
        return NO;
    }
}

@end
