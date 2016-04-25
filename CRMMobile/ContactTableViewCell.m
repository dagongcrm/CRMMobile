//
//  ContactTableViewCell.m
//  CRMMobile
//
//  Created by zhang on 16/4/24.
//  Copyright (c) 2016年 dagong. All rights reserved.
//

#import "ContactTableViewCell.h"

@implementation ContactTableViewCell
@synthesize lianxiR;
@synthesize phone;
@synthesize photo;
@synthesize company;
@synthesize position;
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
