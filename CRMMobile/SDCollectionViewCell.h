#import <UIKit/UIKit.h>

@interface SDCollectionViewCell : UICollectionViewCell
@property (nonatomic, weak)     UIImageView *imageView;
@property (nonatomic, copy)     NSString *title;
@property (nonatomic, strong)   UIColor *titleLabelTextColor;
@property (nonatomic, strong)   UIFont *titleLabelTextFont;
@property (nonatomic, strong)   UIColor *titleLabelBackgroundColor;
@property (nonatomic, assign)   CGFloat titleLabelHeight;
@property (nonatomic, assign)   BOOL hasConfigured;
@end
