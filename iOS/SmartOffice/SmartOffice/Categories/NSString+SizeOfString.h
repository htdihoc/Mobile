//
//  NSString+SizeOfString.h
//  SmartOffice
//
//  Created by NguyenVanTu on 5/8/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (SizeOfString)
- (CGFloat)widthOfString:(UIFont *)font;
- (CGSize)findHeightForText:(CGFloat)widthValue andFont:(UIFont *)font;
- (CGFloat)heightForWidth:(CGFloat)width usingFont:(UIFont *)font;
@end
