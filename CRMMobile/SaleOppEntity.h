//
//  SaleOppEntity.h
//  CRMMobile
//
//  Created by jam on 15/11/17.
//  Copyright (c) 2015年 dagong. All rights reserved.
//

#import <Foundation/Foundation.h>
//customerName  customerNameStr saleOppSrc successProbability saleOppDescription oppState contact contactTel
@interface SaleOppEntity : NSObject
    @property (strong,nonatomic) NSString *customerName;//riqi

    @property (strong,nonatomic) NSString *customerNameStr;//

    @property (strong,nonatomic) NSString *saleOppSrc;

    @property (strong,nonatomic) NSString *successProbability;

    @property (strong,nonatomic) NSString *saleOppDescription;

    @property (strong,nonatomic) NSString *oppState;

    @property (strong,nonatomic) NSString *contact;

    @property (strong,nonatomic) NSString *contactTel;
@end