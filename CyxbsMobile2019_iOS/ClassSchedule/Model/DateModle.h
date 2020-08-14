//
//  DateModle.h
//  ChatBotTest
//
//  Created by 王一成 on 2018/8/30.
//  Copyright © 2018年 wyc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateModle : NSObject

/**这个数组内部有25个数组，每一个数组内部都是对应一周7天的七个字典，字典里day->某日，month->某月*/
@property (nonatomic, strong) NSMutableArray *dateArray;

/**当前是第几周*/
@property (nonatomic, strong) NSNumber *nowWeek;
+(instancetype)initWithStartDate:(NSString *)startDate;

@end

//dateArray[i][j][@"month"]：（第i+1周）的（星期j+1）的月份
//dateArray[i][j][@"day"]：（第i+1周）的（星期j+1）的日
