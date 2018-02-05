//
//  NSString+StringToDate.m
//  SmartOffice
//
//  Created by NguyenVanTu on 6/7/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import "NSString+StringToDate.h"

@implementation NSString (StringToDate)
- (NSDate *)convertStringToDateWith:(NSString *)format
{
    NSString *currentFormat = format;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    NSRange containsA = [self rangeOfString:@"AM"];
    NSRange containsP = [self rangeOfString:@"PM"];
    if (containsA.length != NSNotFound || containsP.length != NSNotFound) {
        currentFormat = [currentFormat stringByReplacingOccurrencesOfString:@"HH"
                                                                 withString:@"hh"];
        
        
    }
    [dateFormatter setDateFormat:currentFormat];
    NSDate *date = [dateFormatter dateFromString:self];
    return date;
}
@end
