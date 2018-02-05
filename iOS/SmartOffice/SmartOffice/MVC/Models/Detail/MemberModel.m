//
//  MemberModel.m
//  SmartOffice
//
//  Created by Kaka on 5/16/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import "MemberModel.h"

@implementation MemberModel
- (NSString *)receiverName
{
    if (_receiverName == nil || [_receiverName isEqualToString:@""]) {
        return LocalizedString(@"N/A");
    }
    return _receiverName;
}
- (NSString *)departmentName
{
    if (_departmentName == nil || [_departmentName isEqualToString:@""]) {
        return LocalizedString(@"N/A");
    }
    return _departmentName;
}
- (NSString *)empVhrName
{
    if (_empVhrName == nil || [_empVhrName isEqualToString:@""]) {
        return LocalizedString(@"N/A");
    }
    return _empVhrName;
}


@end
