//
//  VisitPlanTableViewCell.h
//  CRMMobile
//
//  Created by zhang on 16/4/25.
//  Copyright (c) 2016年 dagong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VisitPlanTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *visitDate;
@property (strong, nonatomic) IBOutlet UILabel *visitor;
@property (strong, nonatomic) IBOutlet UILabel *company;
@property (strong, nonatomic) IBOutlet UIImageView *photo;

@end
