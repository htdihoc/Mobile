//
//  NSException+Custom.h
//  SmartOffice
//
//  Created by NguyenVanTu on 5/29/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSException (Custom)
+ (NSException *)initWithNoNetWork;
+ (NSException *)initWithCode:(NSNumber *)code;
+ (NSException *)initWithString:(NSString *)content;
@end
