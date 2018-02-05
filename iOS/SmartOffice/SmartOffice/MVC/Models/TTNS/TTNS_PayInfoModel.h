//
//  TTNS_PayInfoModel.h
//  SmartOffice
//
//  Created by NguyenVanTu on 6/5/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SOBaseModel.h"
@interface TTNS_PayInfoModel : SOBaseModel
@property (strong, nonatomic) NSNumber *payslipId;
@property (strong, nonatomic) NSNumber *salaryDate;
@property (strong, nonatomic) NSString *incomeItem;
@property (strong, nonatomic) NSString *orgCode;
@property (strong, nonatomic) NSNumber *realIncome;
@property (assign) NSInteger incomeType;
@end
