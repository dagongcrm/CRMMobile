//
//  BaseUtil.m
//  CRMMobile
//
//  Created by 伍德友 on 16/4/7.
//  Copyright (c) 2016年 dagong. All rights reserved.
//

#import "BaseUtil.h"

@implementation BaseUtil
//将NSDate 转换成 NSString(定位)
+(NSString *)dateToString:(NSDate *)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    return destDateString;
}
@end
