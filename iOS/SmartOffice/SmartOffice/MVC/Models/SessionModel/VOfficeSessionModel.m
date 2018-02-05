//
//  VOfficeSessionModel.m
//  SmartOffice
//
//  Created by Kaka on 5/3/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "VOfficeSessionModel.h"

@implementation VOfficeSessionModel
- (NSString *)access_token
{
    return _access_token == nil ? @"" : _access_token;
}
- (NSString *)aes_key
{
    return _aes_key == nil ? @"" : _aes_key;
}
- (NSString *)rsa_public_key
{
    return _rsa_public_key == nil ? @"" : _rsa_public_key;
}
- (NSString *)sysUserID
{
    return _sysUserID == nil ? @"" : _sysUserID;
}
- (NSMutableArray *)listOrgIds
{
    return _listOrgIds == nil ? [[NSMutableArray alloc] init] : _listOrgIds;
}
- (NSMutableArray *)userRolesArr
{
    return _userRolesArr == nil ? [[NSMutableArray alloc] init] : _userRolesArr;
}
@end
