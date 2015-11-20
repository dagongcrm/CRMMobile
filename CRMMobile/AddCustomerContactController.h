//
//  AddCustomerContactController.h
//  CRMMobile
//
//  Created by why on 15/11/17.
//  Copyright (c) 2015年 dagong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CostomerContactEntity.h"
#import "AddCustomerEntity.h"
@interface AddCustomerContactController : UIViewController
@property CostomerContactEntity *customerEntity;
@property AddCustomerEntity *addCustomerEntity;
@property (strong,nonatomic)NSString *context;
@end
