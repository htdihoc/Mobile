//
//  RegisterInOutModel.h
//  SmartOffice
//
//  Created by Hien Tuong on 5/17/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import "SOBaseModel.h"

@interface RegisterInOutModel : SOBaseModel{
    
}
@property (assign, nonatomic) NSInteger empOutRegId;
@property (assign, nonatomic) NSInteger workPlaceId;
@property (strong, nonatomic) NSString *reasonDetail;
@property (assign, nonatomic) NSInteger createDate;
@property (assign, nonatomic) NSInteger createUser;
@property (assign, nonatomic) NSInteger modifyDate;
@property (assign, nonatomic) NSInteger modifyUser;
@property (assign, nonatomic) NSInteger processingDate;
@property (assign, nonatomic) NSInteger empApproveId;
@property (assign, nonatomic) NSInteger approveDate;
@property (assign, nonatomic) NSInteger status;
@property (assign, nonatomic) NSInteger empId;
@property (assign, nonatomic) NSInteger timeOutReg;
@property (assign, nonatomic) NSInteger reasonOutId;
@property (assign, nonatomic) NSInteger timeStart;
@property (assign, nonatomic) NSInteger timeEnd;
@property (strong, nonatomic) NSString *reasonOut;
@property (strong, nonatomic) NSString *workPlace;

@end
