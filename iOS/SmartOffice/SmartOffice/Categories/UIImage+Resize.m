//
//  UIImage+Resize.m
//  SmartOffice
//
//  Created by Kaka on 4/12/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "UIImage+Resize.h"
#import "CacheController.h"
@implementation UIImage (Resize)

+ (UIImage *)resizeImageByHeight:(UIImage *)sourceImage scaledHeight:(float)i_height{
	float oldHeight = sourceImage.size.height;
	float scaleFactor = i_height / oldHeight;
	
	float newWidth = sourceImage.size.width * scaleFactor;
	float newHeight = oldHeight * scaleFactor;
	
	UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
	[sourceImage drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
	UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return newImage;
}

+ (UIImage *)resizeImageByWidth:(UIImage *)sourceImage scaledToWidth:(float)i_width {
	float oldWidth = sourceImage.size.width;
	float scaleFactor = i_width / oldWidth;
	
	float newHeight = sourceImage.size.height * scaleFactor;
	float newWidth = oldWidth * scaleFactor;
	
	UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
	[sourceImage drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
	UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return newImage;
}
+ (UIImage *)imageCache:(NSString *)cacheKey
{
    return [[CacheController sharedInstance] getCacheForKey:cacheKey];
}
+ (UIImage *)imageWithImageCache:(UIImage *)image key:(NSString *)cacheKey{
    UIImage *cachedObject = [[CacheController sharedInstance] getCacheForKey:cacheKey];
    if (!cachedObject) {
        CGSize size;
        if (IS_IPHONE) {
            size  = CGSizeMake(200, 200);
        }
        else
        {
            size  = CGSizeMake(400, 400);
        }
        UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
        [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        [[CacheController sharedInstance] setCache:newImage forKey:cacheKey];
        return newImage;
    }
    else
    {
        return cachedObject;
    }
    
}

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
@end
