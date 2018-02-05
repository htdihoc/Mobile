//
//  EmployeeModel.m
//  SmartOffice
//
//  Created by Kaka on 5/17/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import "EmployeeModel.h"
#import "NSString+Util.h"
@implementation EmployeeModel
//memberName
//vhrOrgName
- (NSString *)memberName
{
    if (![_memberName checkValidString]) {
        return LocalizedString(@"N/A");
    }
    return _memberName;
}
- (NSString *)vhrOrgName
{
    if (![_vhrOrgName checkValidString]) {
        return LocalizedString(@"N/A");
    }
    return _vhrOrgName;
}
@end
