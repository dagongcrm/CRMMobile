//
//  RecordsNsObj.h
//  CRMMobile
//
//  Created by peng on 15/11/8.
//  Copyright (c) 2015年 dagong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecordsNsObj : NSObject
@property (strong, nonatomic) NSString *customerNameStr;//客户名称
@property (strong, nonatomic) NSString *visitDate;//拜访时间
@property (strong, nonatomic) NSString *theme;//主题
@property (strong, nonatomic) NSString *accessMethodStr;//访问方式
@property (strong, nonatomic) NSString *mainContent;//主要内容
@property (strong, nonatomic) NSString *respondentPhone;//受访人电话
@property (strong, nonatomic) NSString *respondent;//受访人员
@property (strong, nonatomic) NSString *address;//地址
@property (strong, nonatomic) NSString *visitProfile;//拜访概要
@property (strong, nonatomic) NSString *result;//达成结果
@property (strong, nonatomic) NSString *customerRequirements;//客户需求
@property (strong, nonatomic) NSString *customerChange;//客户变更
@property (strong, nonatomic) NSString *visitorAttributionStr;//拜访人归属
@property (strong, nonatomic) NSString *visitor;//拜访人
@property (strong, nonatomic) NSString *callRecordsID;//拜访
@property (strong, nonatomic) NSString *visitorStr;//拜访人
@end
