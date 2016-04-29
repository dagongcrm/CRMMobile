//
//  NullString.m
//  CRMMobile
//
//  Created by 伍德友 on 16/4/29.
//  Copyright (c) 2016年 dagong. All rights reserved.
//

#import "NullString.h"

@implementation NullString
+(BOOL) isBlankString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}
@end
