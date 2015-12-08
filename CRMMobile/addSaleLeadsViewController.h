//
//  addSaleLeadsViewController.h
//  CRMMobile
//
//  Created by zhang on 15/12/3.
//  Copyright (c) 2015年 dagong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SaleOppEntity.h"
#import "saleLeads.h"
@interface addSaleLeadsViewController : UIViewController
@property (strong, nonatomic) SaleOppEntity *saleOppEntity;
@property (strong, nonatomic) saleLeads *saleLeads;
@end
