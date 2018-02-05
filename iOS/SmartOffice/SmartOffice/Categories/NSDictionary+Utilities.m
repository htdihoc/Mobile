//
//  NSDictionary+Utilities.m
//  SmartOffice
//
//  Created by NguyenVanTu on 6/2/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import "NSDictionary+Utilities.h"

@implementation NSDictionary (Utilities)
- (BOOL)checkKey:(NSString *)key
{
    if ([[(NSDictionary*)self allKeys] containsObject:key]) {
        return YES;
    }
    return NO;
}
@end
