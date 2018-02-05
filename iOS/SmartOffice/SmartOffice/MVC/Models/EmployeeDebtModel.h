//
//  EmployeeDebtModel.h
//  SmartOffice
//
//  Created by NguyenDucBien on 9/20/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import "SOBaseModel.h"

@interface EmployeeDebtModel : SOBaseModel

@property (strong, nonatomic) NSString *currencyCode;
@property (assign, nonatomic) NSInteger debtAmount;
@property (strong, nonatomic) NSString *vhrEmployeeCode;

@end
