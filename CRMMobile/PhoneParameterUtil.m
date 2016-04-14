//
//  PhoneParameterUtil.m
//  CRMMobile
//
//  Created by gwb on 16/4/12.
//  Copyright (c) 2016年 dagong. All rights reserved.
//

#import "PhoneParameterUtil.h"

@implementation PhoneParameterUtil

+ (NSString *) getPhoneModel{
    NSString *phoneModel=@"";
    CGSize iosDeviceScreenSize = [UIScreen mainScreen].bounds.size;
    if ([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPhone) {
        if (iosDeviceScreenSize.height==568) {
            phoneModel=@"5";
        }else if(iosDeviceScreenSize.height==667){
            phoneModel=@"6";
        }else if(iosDeviceScreenSize.height==736){
            phoneModel=@"6p";
        }else{
            phoneModel=@"4";
        }
    }
    return  phoneModel;
}

@end
