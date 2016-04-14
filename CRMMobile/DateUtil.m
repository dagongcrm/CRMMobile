//
//  DateUtil.m
//  CRMMobile
//
//  Created by gwb on 16/4/12.
//  Copyright (c) 2016年 dagong. All rights reserved.
//

#import "DateUtil.h"

@implementation DateUtil
+(NSString *)dateToString:(NSDate *)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    return destDateString;
}
@end
