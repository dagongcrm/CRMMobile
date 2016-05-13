#import "SDHomeGridViewListItemViewButton.h"
#import "UIView+SDExtension.h"

@implementation SDHomeGridViewListItemViewButton

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:12];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat h = self.sd_height * 0.26;
    CGFloat w = self.sd_height * 0.3;
    CGFloat x = (self.sd_width - w) * 0.5;
    CGFloat y = self.sd_height * 0.3;
    return CGRectMake(x, y, w, h);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(0, self.sd_height * 0.6, self.sd_width, self.sd_height * 0.3);
}

@end
