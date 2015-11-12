//
//  options.h
//  Ratings
//
//  Created by gwb on 15/9/14.
//  Copyright (c) 2015年 gwb. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 the entity for leave flow
 */
@interface options : NSObject {
    NSString * ftc_ID;
    NSString * bussinessDate;
}
@property (strong,nonatomic) NSString *ftc_ID;
@property (strong,nonatomic) NSString *bussinessDate;
@property (strong,nonatomic) NSString *ftn_HandleResult;
@property (strong,nonatomic) NSString *ftn_ID;
@property (strong,nonatomic) NSString *flo_ID;
@property (strong,nonatomic) NSString *templateNodeID;
@property (strong,nonatomic) NSString *chooseUserIDs;
@property (strong,nonatomic) NSString *chooseUserIDsQiYe;
@property (strong,nonatomic) NSString *chosseUsersForShow;
@property (strong,nonatomic) NSString *handlePrompt;
@property (strong,nonatomic) NSString *userName;
@property (strong,nonatomic) NSString *reason;

@end
