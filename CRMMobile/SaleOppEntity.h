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
    @property (strong,nonatomic) NSString *saleOppID;

    @property (strong,nonatomic) NSString *customerName;

    @property (strong,nonatomic) NSString *customerNameStr;

    @property (strong,nonatomic) NSString *saleOppSrc;

    @property (strong,nonatomic) NSString *saleOppSrcStr;

    @property (strong,nonatomic) NSString *successProbability;

    @property (strong,nonatomic) NSString *saleOppDescription;

    @property (strong,nonatomic) NSString *oppState;

    @property (strong,nonatomic) NSString *oppStateStr;

    @property (strong,nonatomic) NSString *contact;

    @property (strong,nonatomic) NSString *contactTel;

    @property (strong,nonatomic) NSString *saleLeadsAdd;

    @property (strong,nonatomic) NSString *index;
@end

