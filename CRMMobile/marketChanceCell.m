//
//  marketChanceCell.m
//  CRMMobile
//
//  Created by 伍德友 on 16/4/25.
//  Copyright (c) 2016年 dagong. All rights reserved.
//

#import "marketChanceCell.h"

@implementation marketChanceCell
@synthesize myImg;
@synthesize qiyeMc;
@synthesize lianxiR;
@synthesize successP;
@synthesize type;
//
//- (void)awakeFromNib {
//    // Initialization code
//}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
