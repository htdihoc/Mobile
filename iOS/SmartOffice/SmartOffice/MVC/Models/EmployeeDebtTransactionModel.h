//
//  EmployeeDebtTransactionModel.h
//  SmartOffice
//
//  Created by NguyenDucBien on 9/20/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import "SOBaseModel.h"


@interface EmployeeDebtTransactionModel : SOBaseModel {
    
}

@property (assign, nonatomic) NSInteger amount;
@property (strong, nonatomic) NSString *currencyCode;
@property (strong, nonatomic) NSString *description;
@property (strong, nonatomic) NSString *documentDate;
@property (strong, nonatomic) NSString *vhrEmployeeCode;


@end
