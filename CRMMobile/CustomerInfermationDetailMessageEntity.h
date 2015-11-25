//
//  CustomerInfermationDetailMessageEntity.h
//  CRMMobile
//
//  Created by yd on 15/10/30.
//  Copyright (c) 2015年 dagong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomerInfermationDetailMessageEntity : NSObject{
}

@property (strong,nonatomic) NSString *customerID;
@property (strong,nonatomic) NSString *customerName;
@property (strong,nonatomic) NSString *industryIDStr;
@property (strong,nonatomic) NSString *companyTypeStr;
@property (strong,nonatomic) NSString *customerClassStr;
@property (strong,nonatomic) NSString *provinceStr;
@property (strong,nonatomic) NSString *shiChangXQFL;
@property (strong,nonatomic) NSString *customerAddress;
@property (strong,nonatomic) NSString *phone;
@property (strong,nonatomic) NSString *receptionPersonnel;
@property (strong,nonatomic) NSString *createTime;


@end