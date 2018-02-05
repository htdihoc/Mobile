//
//  NSString+SizeOfString.m
//  SmartOffice
//
//  Created by NguyenVanTu on 5/8/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "NSString+SizeOfString.h"

@implementation NSString (SizeOfString)
- (CGFloat)widthOfString:(UIFont *)font {
    CGSize size = CGSizeZero;
    CGRect frame = [self boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName:font } context:nil];
    size = CGSizeMake(frame.size.width, frame.size.height + 1);
    return size.width;
}
- (CGFloat)heightForWidth:(CGFloat)width usingFont:(UIFont *)font
{
    NSStringDrawingContext *context = [[NSStringDrawingContext alloc] init];
    CGSize labelSize = (CGSize){width, FLT_MAX};
    CGRect r = [self boundingRectWithSize:labelSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: font} context:context];
    return r.size.height;
}
- (CGSize)findHeightForText:(CGFloat)widthValue andFont:(UIFont *)font {
    CGSize size = CGSizeZero;
    if (self) {
        CGRect frame = [self boundingRectWithSize:CGSizeMake(widthValue, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName:font } context:nil];
        size = CGSizeMake(frame.size.width, frame.size.height + 1);
    }
    return size;
}
@end
