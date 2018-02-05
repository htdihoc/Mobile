//
//  UIFont+Ext.m
//  mPOS_iOS
//
//  Created by Nguyen Thanh Huy on 11/10/16.
//  Copyright © 2016 Nguyen Thanh Huy. All rights reserved.
//

#import "UIFont+Ext.h"

@implementation UIFont(UIFont)

+ (UIFont *)fontNTH_Size:(CGFloat)iSize {
    return [UIFont fontWithName:@"MuseoSans-300" size:iSize];
}

+ (UIFont *)fontNTHBold_Size:(CGFloat)iSize {
    return [UIFont fontWithName:@"MuseoSans-500" size:iSize];
}

+ (UIFont *)fontNTHItalic_Size:(CGFloat)iSize {
    return [UIFont fontWithName:@"MuseoSans-300" size:iSize];
}

+ (UIFont *)fontNTHBoldItalic_Size:(CGFloat)iSize {
    return [UIFont fontWithName:@"MuseoSans-500" size:iSize];
}

@end
