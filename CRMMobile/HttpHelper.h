//
//  HttpHelper.h
//  CRMMobile
//
//  Created by gwb on 15/11/24.
//  Copyright (c) 2015年 dagong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Reachability.h"

@interface HttpHelper : NSObject

+ (BOOL)NetWorkIsOK;//检查网络是否可用
+ (void)postAsyn:(NSString *)Url RequestParams:(NSDictionary *)params FinishBlock:(void (^)(NSURLResponse *response, NSData *data, NSError *connectionError)) block;//post请求封装
@end