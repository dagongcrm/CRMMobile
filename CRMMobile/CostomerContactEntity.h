//
//  CostomerContactEntity.h
//  CRMMobile
//
//  Created by why on 15/11/17.
//  Copyright (c) 2015年 dagong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CostomerContactEntity : NSObject{

}
@property (strong,nonatomic) NSString *customerNameStr;
@property (strong,nonatomic) NSString *contactName;
@property (strong,nonatomic) NSString *customerNameAdd;
@property (strong,nonatomic) NSString *customerName;
@property (strong,nonatomic) NSString *telePhone;
@property (strong,nonatomic) NSString *department;
@property (strong,nonatomic) NSString *position;
@property (strong,nonatomic) NSString *evaluationOfTheSalesman;
@property (strong,nonatomic) NSString *informationAttributionStr;
@property (strong,nonatomic) NSString *guishuRStr;
@property (strong,nonatomic) NSString *contactState;
@property (strong,nonatomic) NSString *tianjiaSJ;
@property (strong,nonatomic) NSString *contactID;
@property (strong,nonatomic) NSString *index;

@property (strong,nonatomic) NSString *visitDate;//
@property (strong,nonatomic) NSString *theme;
@property (strong,nonatomic) NSString *customerCallPlanID;
@property (strong, nonatomic) NSString *accessMethod;//访问方式
@property (strong, nonatomic) NSString *mainContent;//主要内容
@property (strong, nonatomic) NSString *respondentPhone;//受访人电话
@property (strong, nonatomic) NSString *respondent;//受访人员
@property (strong, nonatomic) NSString *address;//地址
@property (strong, nonatomic) NSString *visitProfile;//拜访概要
@property (strong, nonatomic) NSString *result;//达成结果
@property (strong, nonatomic) NSString *customerRequirements;//客户需求
@property (strong, nonatomic) NSString *customerChange;//客户变更
@property (strong, nonatomic) NSString *visitorStr;//拜访人
@end
