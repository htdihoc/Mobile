//
//  TTNSSessionModel.h
//  SmartOffice
//
//  Created by Administrator on 5/12/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import "SOBaseModel.h"
#import "UserRoleModel.h"

@interface TTNSSessionModel : SOBaseModel{
}

@property (strong, nonatomic)NSString *accessToken;
@property (strong, nonatomic)NSString *ssoToken;
@property (strong, nonatomic)NSString *privateKey;
@end
