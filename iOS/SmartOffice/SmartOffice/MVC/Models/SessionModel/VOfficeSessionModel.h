//
//  VOfficeSessionModel.h
//  SmartOffice
//
//  Created by Kaka on 5/3/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "SOBaseModel.h"
#import "UserRoleModel.h"


@interface VOfficeSessionModel : SOBaseModel{
	
}

@property (strong, nonatomic) NSString *access_token;
@property (strong, nonatomic) NSString *aes_key;
@property (strong, nonatomic) NSString *rsa_public_key;

@property (strong, nonatomic) NSString *sysUserID;
@property (strong, nonatomic) NSMutableArray *listOrgIds;
@property (strong, nonatomic) NSMutableArray *userRolesArr;

@end
