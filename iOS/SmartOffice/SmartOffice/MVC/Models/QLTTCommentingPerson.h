//
//  QLTTCommentingPerson.h
//  SmartOffice
//
//  Created by NguyenVanTu on 5/24/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SOBaseModel.h"
@interface QLTTCommentingPerson : SOBaseModel
@property (strong, nonatomic) NSDictionary *sysUser;
@property (strong, nonatomic) NSString *createdDate;
@property (strong, nonatomic) NSString *content;
@end
