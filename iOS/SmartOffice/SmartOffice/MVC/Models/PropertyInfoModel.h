//
//  PropertyInfoModel.h
//  SmartOffice
//
//  Created by Vu Van Tiep on 5/3/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "SOBaseModel.h"

@interface PropertyInfoModel : SOBaseModel

@property (assign, nonatomic) NSInteger assetPrice;
@property (assign, nonatomic) NSInteger catEmployeeId;
@property (strong, nonatomic) NSString *catMerCode;
@property (strong, nonatomic) NSString *catMerName;
@property (strong, nonatomic) NSString *companyName;
@property (assign, nonatomic) NSInteger count;
@property (assign, nonatomic) NSInteger entityType;
@property (assign, nonatomic) NSInteger isDevice;
@property (nonatomic) BOOL isReject;
@property (assign, nonatomic) NSInteger isWarranty;
@property (assign, nonatomic) NSInteger merEntityId;
@property (strong, nonatomic) NSString *minuteHandOverCode;
@property (assign, nonatomic) NSInteger minuteHandOverDate;
@property (strong, nonatomic) NSString *privateManagerName;
@property (assign, nonatomic) NSInteger restTime;
@property (strong, nonatomic) NSString *serialNumber;
@property (strong, nonatomic) NSString *stationCode;
@property (strong, nonatomic) NSString *statusName;
@property (assign, nonatomic) NSInteger stt;
@property (strong, nonatomic) NSString *unitName;
@property (assign, nonatomic) NSInteger usedDate;

@end
