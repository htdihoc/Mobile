//
//  NSDictionary+Ext.m
//  mPOS_iOS
//
//  Created by Nguyen Thanh Huy on 11/8/16.
//  Copyright © 2016 Nguyen Thanh Huy. All rights reserved.
//

#import "NSDictionary+Ext.h"

//@implementation NSDictionary_Ext
@implementation NSDictionary (NSDictionary)

- (void)setValueString:(NSString *)strValue nullValue:(NSString *)nullValue forKey:(NSString *)key {
    if (strValue && strValue != nil && [strValue length] > 0 && ![strValue isEqualToString:@"(null)"] && ![strValue isEqualToString:@"<null>"] && ![strValue isEqualToString:@"null"]) {
        [self setValue:strValue forKeyPath:key];
    }
    else {
        [self setValue:nullValue forKeyPath:key];
    }
}

- (NSString *)getValueStringFromKey:(NSString *)key {
    NSString *str = [self[key] description];
    
    if (str == nil || [str isEqualToString:@"<null>"] || [str isEqualToString:@"null"] || [str isEqualToString:@"(null)"]) {
        str = @"";
    }
    
    return str;
}

@end
