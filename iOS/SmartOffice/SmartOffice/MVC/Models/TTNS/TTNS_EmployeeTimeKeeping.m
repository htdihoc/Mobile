//
//  TTNS_EmployeeTimeKeeping.m
//  SmartOffice
//
//  Created by Nguyen Van Tu on 9/22/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import "TTNS_EmployeeTimeKeeping.h"
@implementation TTNS_EmployeeTimeKeeping
- (BOOL)isLoaded
{
    if(_fullName || _email || _positionName || _imagePath)
    {
        return true;
    }
    return false;
}
- (NSString *)checkValidStringModel:(NSString *)string
{
    if(string == nil || [string isEqualToString:@""])
    {
        return LocalizedString(@"N/A");
    }
    return string;
}
//- (NSString *)positionName
//{
//    return [self checkValidStringModel:_positionName];
//}
- (NSString *)placeOfBirth
{
    return [self checkValidStringModel:_placeOfBirth];
}
- (NSString *)permanentAddress
{
    return [self checkValidStringModel:_permanentAddress];
}
- (NSString *)personalIdNumber
{
    return [self checkValidStringModel:_personalIdNumber];
}
- (NSString *)personalIdIssuedDate
{
    return [self checkValidStringModel:_personalIdIssuedDate];
}
- (NSString *)personalIdIssuedPlace
{
    return [self checkValidStringModel:_personalIdIssuedPlace];
}
- (NSString *)fullName
{
    return [self checkValidStringModel:_fullName];
}
- (NSString *)phoneNumber
{
    return [self checkValidStringModel:_phoneNumber];
}
- (NSString *)mobileNumber
{
    return [self checkValidStringModel:_mobileNumber];
}
- (NSString *)email
{
    return [self checkValidStringModel:_email];
}
- (NSString *)taxManageOrg
{
    return [self checkValidStringModel:_taxManageOrg];
}
-(NSString *)taxCodeDate
{
    return [self checkValidStringModel:_taxCodeDate];
}
- (NSString *)taxNumber
{
    return [self checkValidStringModel:_taxNumber];
}
- (NSString *)taxNumberUpdatedTime
{
    return [self checkValidStringModel:_taxNumberUpdatedTime];
}
@end
