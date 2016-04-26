//
//  marketChanceCell.h
//  CRMMobile
//
//  Created by 伍德友 on 16/4/25.
//  Copyright (c) 2016年 dagong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface marketChanceCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *myImg;//头像
@property (weak, nonatomic) IBOutlet UILabel *qiyeMc;//企业名称
@property (weak, nonatomic) IBOutlet UILabel *lianxiR;//联系人
@property (weak, nonatomic) IBOutlet UILabel *successP;//成功率
@property (weak, nonatomic) IBOutlet UILabel *type;//活跃状态

@end
