//
//  NoticeViewController.h
//  CRMMobile
//
//  Created by zhang on 15/11/17.
//  Copyright (c) 2015年 dagong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoticeViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *swipeLable;
@property (nonatomic, strong) UISwipeGestureRecognizer *leftSwipe;
@property (nonatomic, strong) UISwipeGestureRecognizer *rightSwipe;

@property (assign, nonatomic) NSNumber *page;
@end
