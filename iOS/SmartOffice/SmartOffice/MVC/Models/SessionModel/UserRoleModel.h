//
//  UserRoleModel.h
//  SmartOffice
//
//  Created by Kaka on 5/11/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import "SOBaseModel.h"

@interface UserRoleModel : SOBaseModel{
	
}
@property (strong, nonatomic) NSString *userRoleId;
@property (strong, nonatomic) NSString *sysUserId;
@property (strong, nonatomic) NSString *sysRoleId;
@property (strong, nonatomic) NSString *orgId;
@property (strong, nonatomic) NSString *fullName;
@property (strong, nonatomic) NSString *orgName;


//"userRoleId": 861216,
//"sysUserId": 6485,
//"orgId": 259210,
//"fullName": "Nguyễn Phúc Đức",
//"orgName": "Trung tâm Phần mềm nhân sự - TT PM 1 - Trung tâm Phần mềm Viettel 1"

@end
