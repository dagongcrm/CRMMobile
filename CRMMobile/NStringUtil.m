//
//  NStringUtil.m
//  CRMMobile
//
//  Created by gwb on 16/4/12.
//  Copyright (c) 2016年 dagong. All rights reserved.
//

#import "NStringUtil.h"

@implementation NStringUtil

+ (NSString *) returnStringDepondOnStringLength:(id)StringToCheckOutLength{
    return [(NSString *)StringToCheckOutLength length]==0?@"":(NSString *)StringToCheckOutLength;
}

@end
