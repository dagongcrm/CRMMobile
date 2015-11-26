//
//  marketActivity.h
//  CRMMobile
//
//  Created by zhang on 15/11/16.
//  Copyright (c) 2015年 dagong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface marketActivity : NSObject

@property (strong,nonatomic) NSString *activityName;
@property (strong,nonatomic) NSString *activityDate;
@property (strong,nonatomic) NSString *activityAddress;
@property (strong,nonatomic) NSString *activityCost;
@property (strong,nonatomic) NSString *activityContent;
@property (strong,nonatomic) NSString *responsibleDepartmentStr;
@property (strong,nonatomic) NSString *responsibleDepartmentPersonStr;
@property (strong,nonatomic) NSString *activitySketch;

@end
