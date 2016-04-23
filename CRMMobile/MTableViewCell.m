//
//  MTableViewCell.m
//  CRMMobile
//
//  Created by 伍德友 on 16/4/21.
//  Copyright (c) 2016年 dagong. All rights reserved.
//

#import "MTableViewCell.h"

@implementation MTableViewCell
@synthesize qiyeName;
@synthesize bfLeixing;
@synthesize bfRen;
@synthesize bfShijian;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
@end
