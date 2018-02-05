//
//  DetailWorkModel.m
//  SmartOffice
//
//  Created by Kaka on 5/3/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "DetailWorkModel.h"

@implementation DetailWorkModel

- (NSString *)enforcementName
{
    if ((_enforcementName == nil || [_enforcementName isEqualToString:@""]) == true) {
        return LocalizedString(@"N/A");
    }
    return  _enforcementName;
}

@end
