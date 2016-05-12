
//
//  AppDelegate.h
//  CRMMobile
//
//  Created by gwb on 15/10/22.
//  Copyright (c) 2015年 dagong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "options.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property  NSString    *appUpdate;
@property  NSString    *deviceCode;
@property  NSInteger   *judge;
@property  NSString    *judgeSubmitID;
@property  NSString    *accessMethod;
@property  NSString    *submitName;
@property  NSString    *yeWuZL;
@property  NSString    *yeWuZLBH;
@property  NSString    *hangYeFLBH;
@property  NSString    *hangYeFLMC;
@property  NSString    *heTongJE;
@property  NSString    *gezongSF;
@property  NSString    *genZongSFJE;
@property  NSString    *lianxiFS;
@property  NSString    *page;
@property  NSInteger   index;
@property  (strong ,nonatomic) NSString       *controllerJudge;
@property  (strong, nonatomic) UIWindow       *window;
@property  (strong ,nonatomic) options        *options;
@property  (nonatomic,retain)  NSDictionary   *sessionInfo;
@property  (nonatomic,retain)  NSMutableArray *indexPageForLoad;
@property  (nonatomic,retain)  NSDictionary   *roleAuthority;
@property  (nonatomic,retain)  NSString       *userChangeOrNot;

@property  (nonatomic,retain)  NSString       *customerForAddSaleLead;


@property  (strong ,nonatomic) NSUserDefaults *appDefault;

@end

