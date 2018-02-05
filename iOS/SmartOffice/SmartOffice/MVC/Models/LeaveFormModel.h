//
//  LeaveFormModel.h
//  SmartOffice
//
//  Created by Hien Tuong on 4/12/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SOBaseModel.h"
#import "UserModel.h"

@interface LeaveFormModel : SOBaseModel{
    
}
//@property (strong, nonatomic) NSString *personalFormId;
//@property (strong, nonatomic) NSString *empoyeeId;
//@property (assign, nonatomic) NSInteger type;
//@property (strong, nonatomic) NSString *organizationId;
//@property (strong, nonatomic) NSString *reason;
//@property (assign, nonatomic) long fromDate;
//@property (assign, nonatomic) long toDate;
//@property (strong, nonatomic) NSString  *phoneNumber;
//@property (strong, nonatomic) NSString  *stayAddress;
//@property (strong, nonatomic) NSString  *employeeReplaceId;
//@property (strong, nonatomic) NSString  *positionReplace;
//@property (strong, nonatomic) NSString  *resolveScope;
//@property (strong, nonatomic) NSString  *position;
//@property (assign, nonatomic) NSInteger status;
//@property (assign, nonatomic) long createdDate;
//@property (strong, nonatomic) NSString *currentAddress;
//@property (assign, nonatomic) long modifyDate;
//@property (strong, nonatomic) NSString *title;
//@property (strong, nonatomic) NSString *department;
//@property (strong, nonatomic) NSString *titleSiger1;
//@property (strong, nonatomic) NSString *titleSiger2;
//@property (strong, nonatomic) NSString *titleSiger3;
//@property (strong, nonatomic) NSString *titleSiger4;
@property (assign, nonatomic) NSInteger type;
@property (assign, nonatomic) long fromDate;
@property (assign, nonatomic) long toDate;
@property (assign, nonatomic) NSInteger status;
@property (assign, nonatomic) NSInteger personalFormId;

@end
