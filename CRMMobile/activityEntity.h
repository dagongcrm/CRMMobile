//
//  activityEntity.h
//  CRMMobile
//
//  Created by peng on 15/11/18.
//  Copyright (c) 2015年 dagong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface activityEntity : NSObject
@property (strong,nonatomic) NSString *activityID;

@property (strong,nonatomic) NSString *activityName;
@property (strong,nonatomic) NSString *activityAddress;
@property (strong,nonatomic) NSString *activityDateStr;
@property (strong,nonatomic) NSString *activityCost;
@property (strong,nonatomic) NSString *activityContent;
@property (strong,nonatomic) NSString *responsibleDepartmentStr;
@property (strong,nonatomic) NSString *responsibleDepartmentPersonStr;
@property (strong,nonatomic) NSString *activitySketch;
@end
