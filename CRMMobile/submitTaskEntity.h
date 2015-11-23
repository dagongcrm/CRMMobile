//
//  submitTaskEntity.h
//  CRMMobile
//111
//  Created by zhang on 15/11/3.
//  Copyright (c) 2015年 dagong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface submitTaskEntity : NSObject{
}
@property (strong,nonatomic) NSString *submitName;
@property (strong,nonatomic) NSString *submitID;
@property (strong,nonatomic) NSString *yeWuZL;
@property (strong,nonatomic) NSString *yeWuZLBH;
@property (strong,nonatomic) NSString *ftn_ID;
@property (strong,nonatomic) NSString *hangYeFLMC;//行业归属
@property (strong,nonatomic) NSString *heTongJE;//合同金额
@property (strong,nonatomic) NSString *genZongSFJE;//跟踪收费金额
@property (strong,nonatomic) NSString *zhuChengXS;//主承销商
@property (strong,nonatomic) NSString *userName;//业务承办人
@property (strong,nonatomic) NSString *lianXiFS;//联系方式

@end
