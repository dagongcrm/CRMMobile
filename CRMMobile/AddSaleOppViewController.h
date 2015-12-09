//
//  AddSaleOppViewController.h
//  CRMMobile
//
//  Created by jam on 15/11/9.
//  Copyright (c) 2015年 dagong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SaleOppEntity.h"
#import "ZSYPopoverListViewSingle.h"
#import "ZSYPopoverListView.h"

@interface AddSaleOppViewController : UIViewController<ZSYPopoverListDatasourceSingle, ZSYPopoverListDelegateSingle,ZSYPopoverListDatasource,ZSYPopoverListDelegate>
@property (strong, nonatomic) SaleOppEntity *saleOppEntity;
@end
