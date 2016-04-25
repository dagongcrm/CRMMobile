//
//  InformationTableViewCell.h
//  CRMMobile
//
//  Created by zhang on 16/4/25.
//  Copyright (c) 2016年 dagong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InformationTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *photo;//
@property (strong, nonatomic) IBOutlet UILabel *address;//客户地址
@property (strong, nonatomic) IBOutlet UILabel *phone;//联系方式
@property (strong, nonatomic) IBOutlet UILabel *industry;//所属行业
@property (strong, nonatomic) IBOutlet UILabel *company;//客户名称

@end
