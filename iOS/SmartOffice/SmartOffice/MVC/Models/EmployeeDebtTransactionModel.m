//
//  EmployeeDebtTransactionModel.m
//  SmartOffice
//
//  Created by NguyenDucBien on 9/20/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//



#import "EmployeeDebtTransactionModel.h"


@implementation EmployeeDebtTransactionModel
@synthesize description = _description;

- (NSString *)currencyCode
{
    if ((_currencyCode == nil || [_currencyCode isEqualToString:@""]) == true) {
        return LocalizedString(@"N/A");
    }
    return  _currencyCode;
}


- (NSString *)documentDate
{
    if ((_documentDate == nil || [_documentDate isEqualToString:@""]) == true) {
        return LocalizedString(@"N/A");
    }
    return  _documentDate;
}

@end
