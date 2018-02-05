//
//  EmployeeModel.h
//  SmartOffice
//
//  Created by Kaka on 5/17/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import "SOBaseModel.h"

@protocol EmployeeModel
@end


@interface EmployeeModel : SOBaseModel{
	
}
@property (strong, nonatomic) NSString *memberId;
@property (strong, nonatomic) NSString *memberName;
@property (strong, nonatomic) NSString *employeeCode;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *mobilePhone;
@property (strong, nonatomic) NSString *vhrOrgId;
@property (strong, nonatomic) NSString *vhrOrgName;
@property (assign, nonatomic) NSInteger isPresident; //Chủ trì: = 1, #1- không phải chủ trì
@property (assign, nonatomic) NSInteger isParticipate;// Tham gia = 1, #1 - Không tham gia
@property (assign, nonatomic) NSInteger isPrepare; //Chuẩn bị = 1, #1 - không phải chuẩn bị
@property (assign, nonatomic) BOOL isAllBranch;
@property (assign, nonatomic) NSInteger type;
@end

//
//{
//	isAllBranch = 0;
//	isParticipate = 1;
//	isPrepare = 0;
//	isPresident = 1;
//	memberId = 493409;
//	memberName = "Nguy\U1ec5n Th\U1ecb L\U00ea H\U1ed3ng";
//	type = 0;
//	vhrOrgId = 254953;
//	vhrOrgName = "Tr\U1ee3 l\U00fd nghi\U1ec7p v\U1ee5 - Ph\U00f2ng S\U1ea3n ph\U1ea9m v\U0103n ph\U00f2ng \U0111i\U1ec7n t\U1eed - Trung t\U00e2m Ph\U1ea7n m\U1ec1m Viettel 1";
//}
