//
//  mailCell.h
//  CRMMobile
//
//  Created by 伍德友 on 16/4/23.
//  Copyright (c) 2016年 dagong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface mailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *photo;//touxiang
@property (weak, nonatomic) IBOutlet UIImageView *phoneBtn;//bohao
@property (weak, nonatomic) IBOutlet UILabel *lianxiR;//lianxiren
@property (weak, nonatomic) IBOutlet UILabel *phone;//dianhua
@property (weak, nonatomic) IBOutlet UILabel *company;//gongsimingc

@end
