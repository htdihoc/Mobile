//
//  NSException+Custom.m
//  SmartOffice
//
//  Created by NguyenVanTu on 5/29/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import "NSException+Custom.h"

@implementation NSException (Custom)
+ (NSException *)initWithNoNetWork
{
    return [[NSException alloc] initWithName:LocalizedString(@"Mất kết nối mạng") reason:LocalizedString(@"Mất kết nối mạng") userInfo:@{@"_kCFStreamErrorCodeKey":[NSNumber numberWithLong:RESP_CODE_EXCEPTION_NO_INTERNET]}];
}
+ (NSException *)initWithCode:(NSNumber *)code
{
    //catch code here
    return [[NSException alloc] initWithName:LocalizedString(@"Không kết nối được đến máy chú") reason:LocalizedString(@"Không kết nối được đến máy chú") userInfo:@{@"_kCFStreamErrorCodeKey":[NSNumber numberWithLong:RESP_CODE_REQUEST_INPROCESS], @"NSLocalizedDescription": LocalizedString(@"Không kết nối được đến máy chủ, xin vui lòng kiểm tra và thử lại sau!")}];
}
+ (NSException *)initWithString:(NSString *)content
{
    return [[NSException alloc] initWithName:content reason:content userInfo:@{@"NSLocalizedDescription":content}];
}
@end
