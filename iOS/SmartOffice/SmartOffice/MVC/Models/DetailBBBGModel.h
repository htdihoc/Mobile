//
//  DetailBBBGModel.h
//  SmartOffice
//
//  Created by Vu Van Tiep on 5/17/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import "SOBaseModel.h"

@interface DetailBBBGModel : SOBaseModel

@property (assign ,nonatomic) NSInteger assetPrice;
@property (strong, nonatomic) NSString *catMerCode;
@property (strong, nonatomic) NSString *catMerName;
@property (assign ,nonatomic) NSInteger count;
@property (assign ,nonatomic) NSInteger entityType;
//@property (nonatomic) BOOL isReject;
@property (assign ,nonatomic) NSInteger isWarranty;
@property (assign ,nonatomic) NSInteger merEntityId;
@property (assign ,nonatomic) NSInteger minuteHandOverId;
@property (assign ,nonatomic) NSInteger minuteHandOverDate;
@property (assign ,nonatomic) NSInteger usedDate;
@property (assign ,nonatomic) NSInteger restTime;
@property (strong, nonatomic) NSString *stationCode;
@property (strong, nonatomic) NSString *statusName;
@property (assign ,nonatomic) NSInteger stt;
@property (strong, nonatomic) NSString *unitName;
@property (strong, nonatomic) NSString *serialNumber;
@property (strong, nonatomic) NSString *companyName;

@end
