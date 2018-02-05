//
//  UIImage+Resize.h
//  SmartOffice
//
//  Created by Kaka on 4/12/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Resize)
+ (UIImage *)resizeImageByHeight:(UIImage *)sourceImage scaledHeight:(float) i_height;
+ (UIImage *)resizeImageByWidth:(UIImage *)sourceImage scaledToWidth:(float)i_width;
+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;
+ (UIImage *)imageWithImageCache:(UIImage *)image key:(NSString *)cacheKey;
+ (UIImage *)imageCache:(NSString *)cacheKey;
@end
