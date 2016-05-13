//
//  TestARViewController.h
//  CRMMobile
//
//  Created by 伍德友 on 16/5/12.
//  Copyright (c) 2016年 dagong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SaleOppEntity.h"
#import "ZSYPopoverListViewSingle.h"
#import "ZSYPopoverListView.h"

@interface AddSaleOppViewController : UIViewController<ZSYPopoverListDatasourceSingle, ZSYPopoverListDelegateSingle,ZSYPopoverListDatasource,ZSYPopoverListDelegate>
@property (strong, nonatomic) SaleOppEntity *saleOppEntity;

@end
