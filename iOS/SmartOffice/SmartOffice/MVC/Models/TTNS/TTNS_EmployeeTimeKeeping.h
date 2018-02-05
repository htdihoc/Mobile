//
//  TTNS_EmployeeTimeKeeping.h
//  SmartOffice
//
//  Created by Nguyen Van Tu on 9/22/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SOBaseModel.h"
@interface TTNS_EmployeeTimeKeeping : SOBaseModel
@property (strong, nonatomic) NSString *employeeId;
@property (strong, nonatomic) NSString *placeOfBirth;
@property (strong, nonatomic) NSString *permanentAddress;
@property (strong, nonatomic) NSString *personalIdNumber;
@property (strong, nonatomic) NSString *personalIdIssuedDate;
@property (strong, nonatomic) NSString *personalIdIssuedPlace;
@property (strong, nonatomic) NSString *fullName;
@property (strong, nonatomic) NSString *phoneNumber;
@property (strong, nonatomic) NSString *mobileNumber;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *taxNumber;
@property (strong, nonatomic) NSString *taxCodeDate;
@property (strong, nonatomic) NSString *taxManageOrg;
@property (strong, nonatomic) NSString *taxNumberUpdatedTime;
@property (strong, nonatomic) NSString *imagePath;
@property (strong, nonatomic) NSString *positionName;
@property (strong, nonatomic) NSNumber *organizationId;
- (BOOL)isLoaded;
@end
