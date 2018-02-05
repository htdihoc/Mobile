//
//  TTNSSessionModel.m
//  SmartOffice
//
//  Created by Administrator on 5/12/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import "TTNSSessionModel.h"

@implementation TTNSSessionModel
- (NSString *)ssoToken
{
    return _ssoToken == nil ? @"" : _ssoToken;
}
- (NSString *)accessToken
{
    return _accessToken == nil ? @"" : _accessToken;
}
- (NSString *)privateKey
{
    return _privateKey == nil ? @"" : _privateKey;
}
@end
