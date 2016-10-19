//
//  UIImage+Resize.h
//  Mileage
//
//  Created by Liangjun Jiang on 6/3/15.
//  Copyright (c) 2015 Liangjun Jiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Resize)
+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;

+(UIImage*)imageWithImage: (UIImage*) sourceImage scaledToWidth: (float) i_width;

+ (UIImage *)imageWithImage:(UIImage *)image scaledToMaxWidth:(CGFloat)width maxHeight:(CGFloat)height;
@end
