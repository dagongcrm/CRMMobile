#import "SDGridItemCacheTool.h"

#define kItemsArrayCacheKey @"ItemsArrayCacheKey"

@implementation SDGridItemCacheTool

+ (NSArray *)itemsArray
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:kItemsArrayCacheKey];
}

+ (void)saveItemsArray:(NSArray *)array
{
    [[NSUserDefaults standardUserDefaults] setObject:[array copy] forKey:kItemsArrayCacheKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
