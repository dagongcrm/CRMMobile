//
//  getLocationUtil.h
//  CRMMobile
//
//  Created by why on 16/4/7.
//  Copyright (c) 2016年 dagong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
@interface getLocationUtil : NSObject
@property (nonatomic, strong) AMapLocationManager *locationManager;
@property (nonatomic, strong) MAMapView *mapView;

+(void) locationInit;//定位初始化
+(void)Location;//开启定位功能
+(float)getPositionAcc;//获取定位精度参数
+(void)chuanzhi:(CLLocation *)location;
@end
