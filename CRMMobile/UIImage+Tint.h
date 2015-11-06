//
//  UIImage+Tint.h
//  Ratings
//
//  Created by gwb on 15/10/10.
//  Copyright (c) 2015年 gwb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Tint)

- (UIImage *) imageWithTintColor:(UIColor *)tintColor;
- (UIImage *) imageWithGradientTintColor:(UIColor *)tintColor;

@end
