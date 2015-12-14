#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//使用方法
//[OMGToast showWithText:@"中间显示" duration:5];
//[OMGToast showWithText:@"距离上方50像素" topOffset:50 duration:5];
//[OMGToast showWithText:@"文字很多的时候，我就会自动折行，最大宽度280像素" topOffset:100 duration:5];
//[OMGToast showWithText:@"加入\\n也可以\n显示\n多\n行" topOffset:300 duration:5];
//[OMGToast showWithText:@"距离下方3像素" bottomOffset:20 duration:5];

#define DEFAULT_DISPLAY_DURATION 2.0f

@interface OMGToast : NSObject {
    NSString *text;
    UIButton *contentView;
    CGFloat  duration;
}

+ (void)showWithText:(NSString *) text_;
+ (void)showWithText:(NSString *) text_
            duration:(CGFloat)duration_;

+ (void)showWithText:(NSString *) text_
           topOffset:(CGFloat) topOffset_;
+ (void)showWithText:(NSString *) text_
           topOffset:(CGFloat) topOffset
            duration:(CGFloat) duration_;

+ (void)showWithText:(NSString *) text_
        bottomOffset:(CGFloat) bottomOffset_;
+ (void)showWithText:(NSString *) text_
        bottomOffset:(CGFloat) bottomOffset_
            duration:(CGFloat) duration_;

@end