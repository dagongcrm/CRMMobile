//
//  ContactTableViewCell.h
//  CRMMobile
//
//  Created by zhang on 16/4/24.
//  Copyright (c) 2016年 dagong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *photo;
@property (strong, nonatomic) IBOutlet UILabel *company;
@property (strong, nonatomic) IBOutlet UILabel *phone;
@property (strong, nonatomic) IBOutlet UILabel *position;
@property (strong, nonatomic) IBOutlet UILabel *lianxiR;

@end
