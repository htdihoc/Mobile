//
//  TTNS_SalaryProcessModel.h
//  SmartOffice
//
//  Created by KhacViet Dinh on 6/13/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import "SOBaseModel.h"

@interface TTNS_SalaryProcessModel : SOBaseModel

@property (strong, nonatomic) NSString *decisionNumber;
@property (strong, nonatomic) NSString *signDate; // datetime
@property (strong, nonatomic) NSString *salaryPosition;
@property (strong, nonatomic) NSString *hscd;
@property (strong, nonatomic) NSString *effectiveStartDate; // datetime
@property (strong, nonatomic) NSString *effectiveEndDate; // datetime
@property (strong, nonatomic) NSString *salaryWage;
@property (strong, nonatomic) NSString *percent;
@property (strong, nonatomic) NSString *salaryTableName;
@property (strong, nonatomic) NSString *salaryCategoryName;
@property (strong, nonatomic) NSString *raiseDate; // datetime

@end
