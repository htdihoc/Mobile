//
//  UILabel+Util.m
//  SmartOffice
//
//  Created by NguyenVanTu on 6/7/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import "UILabel+Util.h"
#import "NSString+SizeOfString.h"
@implementation UILabel (Util)
- (NSInteger)lineCount
{
    UIFont *font = self.font;
    CGRect rect = [self.text boundingRectWithSize:CGSizeMake(self.frame.size.width, MAXFLOAT)
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:@{NSFontAttributeName : font}
                                     context:nil];
    
    
    NSInteger lines = ceil(rect.size.height / font.lineHeight);
    return ceil(lines);
}
@end
