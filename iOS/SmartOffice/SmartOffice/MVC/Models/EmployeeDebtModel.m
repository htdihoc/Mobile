//
//  EmployeeDebtModel.m
//  SmartOffice
//
//  Created by NguyenDucBien on 9/20/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import "EmployeeDebtModel.h"

@implementation EmployeeDebtModel


- (NSString *)currencyCode
{
    if ((_currencyCode == nil || [_currencyCode isEqualToString:@""]) == true) {
        return LocalizedString(@"N/A");
    }
    return  _currencyCode;
}


@end
