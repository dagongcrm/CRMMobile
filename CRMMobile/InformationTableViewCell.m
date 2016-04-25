//
//  InformationTableViewCell.m
//  CRMMobile
//
//  Created by zhang on 16/4/25.
//  Copyright (c) 2016年 dagong. All rights reserved.
//

#import "InformationTableViewCell.h"

@implementation InformationTableViewCell
@synthesize address;
@synthesize company;
@synthesize industry;
@synthesize photo;
@synthesize phone;
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
