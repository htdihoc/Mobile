//
//  BBBGAssetModel.h
//  SmartOffice
//
//  Created by Vu Van Tiep on 5/10/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "SOBaseModel.h"

@interface BBBGAssetModel : SOBaseModel

@property (strong, nonatomic) NSString *acceptDescription;
@property (nonatomic) NSInteger countAsset;
@property (strong, nonatomic) NSString *createdDate;
@property (nonatomic) NSInteger creatorId;
@property (strong, nonatomic) NSString *creatorName;
@property (strong, nonatomic) NSString *description;
@property (strong, nonatomic) NSString *employeeMinuteHandOVerName;
@property (nonatomic) NSInteger employeeMinuteHandOverCode;
@property (nonatomic) NSInteger employeeMinuteReceiverCode;
@property (strong, nonatomic) NSString *employeeMinuteReceiverName;
@property (nonatomic) NSInteger employeeSignCode;
@property (strong, nonatomic) NSString *employeeSignName;
@property (nonatomic) NSInteger groupId;
@property (strong, nonatomic) NSString *groupName;
//@property (nonatomic) BOOL isActive;
@property (strong, nonatomic) NSString *minuteHandOverCode;
@property (nonatomic) NSInteger minuteHandOverDate;
@property (nonatomic) NSInteger minuteHandOverGiverId;
@property (nonatomic) NSInteger minuteHandOverId;
@property (nonatomic) NSInteger minuteHandOverReceiverId;
@property (nonatomic) NSInteger minuteHandOverSignId;
@property (nonatomic) NSInteger status;
@property (strong, nonatomic) NSString *statusName;
@property (strong, nonatomic) NSString *type;

@end
