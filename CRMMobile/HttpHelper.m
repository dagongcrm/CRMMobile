#import "HttpHelper.h"

@implementation HttpHelper

+ (BOOL)NetWorkIsOK{
    if(
       ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus]
        != NotReachable)
       &&
       ([[Reachability reachabilityForLocalWiFi] currentReachabilityStatus]
        != NotReachable)
       ){
        return YES;
    }else{
        return NO;
    }
}

//post异步请求封装函数
+ (void)postAsyn:(NSString *)URL RequestParams:(NSDictionary *)params FinishBlock:(void (^)(NSURLResponse *response, NSData *data, NSError *connectionError)) block{
    NSURL *url = [NSURL URLWithString:URL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                       cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                       timeoutInterval:20];
    NSString *parseParamsResult = [self parseParams:params];
    NSData *postData = [parseParamsResult dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:postData];
    NSOperationQueue *queue = [NSOperationQueue new];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:queue
                           completionHandler:block];
}


+ (NSString *)parseParams:(NSDictionary *)params{
    NSString *keyValueFormat;
    NSMutableString *result = [NSMutableString new];
    NSEnumerator *keyEnum = [params keyEnumerator];
    id key;
    while (key = [keyEnum nextObject]) {
        keyValueFormat = [NSString stringWithFormat:@"%@=%@&",key,[params valueForKey:key]];
        [result appendString:keyValueFormat];
    }
     NSLog(@"post()方法参数解析结果：%@",[result substringToIndex:result.length-1]);
    
    return [result substringToIndex:result.length-1];
}

@end