//
//  DetailLeaveModel.h
//  SmartOffice
//
//  Created by Administrator on 5/15/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import "SOBaseModel.h"

@interface DetailLeaveModel : SOBaseModel{
    
}

@property (assign, nonatomic) NSInteger personalFormId;
@property (assign, nonatomic) NSInteger empoyeeId;
@property (assign, nonatomic) NSInteger type;
@property (assign, nonatomic) NSInteger organizationId;
@property (strong, nonatomic) NSString *reason;
@property (assign, nonatomic) long fromDate;
@property (assign, nonatomic) long toDate;
@property (assign, nonatomic) NSInteger phoneNumber;
@property (strong, nonatomic) NSString *stayAddress;
@property (assign, nonatomic) NSInteger employeeReplaceId;
@property (assign, nonatomic) NSInteger positionReplace;
@property (assign, nonatomic) NSInteger resolveScope;
@property (strong, nonatomic) NSString *position;
@property (assign, nonatomic) NSInteger status;
@property (assign, nonatomic) long createdDate;
@property (strong, nonatomic) NSString *currentAddress;
@property (assign, nonatomic) long modifyDate;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *department;
@property (strong, nonatomic) NSString *titleSiger1;
@property (strong, nonatomic) NSString *titleSiger2;
@property (strong, nonatomic) NSString *titleSiger3;
@property (strong, nonatomic) NSString *titleSiger4;
@end
