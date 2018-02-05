//
//  NSData+Base64.h
//  SmartOffice
//
//  Created by NguyenVanTu on 5/10/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (Base64)
/**
 Returns a data object initialized with the given Base-64 encoded string.
 @param base64String A Base-64 encoded NSString
 @returns A data object built by Base-64 decoding the provided string. Returns nil if the data object could not be decoded.
 */
- (instancetype) initWithBase64EncodedString:(NSString *)base64String;

@end
