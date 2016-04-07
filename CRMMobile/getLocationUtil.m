//
//  getLocationUtil.m
//  CRMMobile
//
//  Created by 伍德友 on 16/4/7.
//  Copyright (c) 2016年 dagong. All rights reserved.
//

#import "getLocationUtil.h"
#import "AppDelegate.h"
#import "config.h"
#import "BaseUtil.h"
#import <MAMapKit/MAMapKit.h>
#import "OMGToast.h"
#import <AMapSearchKit/AMapSearchAPI.h>
#import <AMapLocationKit/AMapLocationRegionObj.h>
#define APIKey @"cdf41cce83fb64756ba13022997e5e74"//APIKey

@implementation getLocationUtil
@synthesize locationManager=_locationManager;
@synthesize mapView = _mapView;

+(void) locationInit{
    
}

+(void)Location{

}
//获取定位精度的参数
+(float)getPositionAcc{
    NSError *error;
    AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
    NSString *sid = [[myDelegate.sessionInfo  objectForKey:@"obj"] objectForKey:@"sid"];
    NSURL *URL=[NSURL URLWithString:[SERVER_URL stringByAppendingString:@"locationAction!PositionAccuracy.action"]];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:URL];
    request.timeoutInterval=10.0;
    request.HTTPMethod=@"POST";
    NSString *param=[NSString stringWithFormat:@"MOBILE_SID=%@",sid];
    request.HTTPBody=[param dataUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    NSString *aString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    float positionacc = [aString floatValue];
    NSLog(@"--------%f",positionacc);
    return positionacc;
}
//往后台传数据
+(void)chuanzhi:(CLLocation *)location{
    //业务处理
    NSError *error;
    AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
    NSString *sid = [[myDelegate.sessionInfo  objectForKey:@"obj"] objectForKey:@"sid"];
    NSString *userId = [[myDelegate.sessionInfo  objectForKey:@"obj"] objectForKey:@"userId"];
    
    CGFloat longitude=location.coordinate.longitude;
    CGFloat latitude=location.coordinate.latitude;
    NSString *time=[BaseUtil dateToString:location.timestamp];
    NSURL *URL=[NSURL URLWithString:[SERVER_URL stringByAppendingString:@"locationAction!add.action?"]];
    
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:URL];
    request.timeoutInterval=10.0;
    request.HTTPMethod=@"POST";
    NSString *param=[NSString stringWithFormat:@"longitude=%f&latitude=%f&userID=%@&time=%@&MOBILE_SID=%@",longitude,latitude,userId,time,sid];
    request.HTTPBody=[param dataUsingEncoding:NSUTF8StringEncoding];
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    
    if (error) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"网络连接超时" message:@"请检查网络，重新加载!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil,nil];
        [alert show];
        NSLog(@"--------%@",error);
    }else{
        NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
        if([[weatherDic objectForKeyedSubscript:@"msg"] isEqualToString:@"操作成功！"]){
            //                    [OMGToast showWithText:@"定位成功" bottomOffset:20 duration:0.5];
        }else{
            [OMGToast showWithText:@"定位数据发送失败" bottomOffset:20 duration:0.5];
        }
    }
}

@end
