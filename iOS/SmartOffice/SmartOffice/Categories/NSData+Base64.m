//
//  NSData+Base64.m
//  SmartOffice
//
//  Created by NguyenVanTu on 5/10/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import "NSData+Base64.h"

@interface NSString (Base64)

- (NSString *) stringPaddedForBase64;

@end

@implementation NSString (Base64)

- (NSString *) stringPaddedForBase64 {
    NSUInteger paddedLength = self.length + (self.length % 3);
    return [self stringByPaddingToLength:paddedLength withString:@"=" startingAtIndex:0];
}

@end

@implementation NSData (Base64)

- (instancetype) initWithBase64EncodedString:(NSString *)base64String {
    return [self initWithBase64Encoding:[base64String stringPaddedForBase64]];
}


@end
