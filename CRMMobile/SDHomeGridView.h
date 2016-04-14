
#import <UIKit/UIKit.h>

@class SDHomeGridView;

@protocol SDHomeGridViewDeleate <NSObject>

@optional

- (void)homeGrideView:(SDHomeGridView *)gridView selectItemAtIndex:(NSInteger)index;
- (void)homeGrideViewmoreItemButtonClicked:(SDHomeGridView *)gridView;
- (void)homeGrideViewDidChangeItems:(SDHomeGridView *)gridView;

@end

@interface SDHomeGridView : UIScrollView <UIScrollViewDelegate>

@property (nonatomic, weak) id<SDHomeGridViewDeleate> gridViewDelegate;
@property (nonatomic, strong) NSArray *gridModelsArray;
@property (nonatomic, strong) NSArray *scrollADImageURLStringsArray;

@end
