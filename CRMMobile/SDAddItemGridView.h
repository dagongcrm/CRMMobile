#import <UIKit/UIKit.h>

@interface SDAddItemGridView : UIScrollView <UIScrollViewDelegate>

@property (nonatomic, strong) NSArray *gridModelsArray;

@property (nonatomic, copy) void (^itemClickedOperationBlock)(SDAddItemGridView *gridView, NSInteger index);

@end
