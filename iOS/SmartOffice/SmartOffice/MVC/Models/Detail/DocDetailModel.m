//
//  DocDetailModel.m
//  SmartOffice
//
//  Created by Kaka on 5/16/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import "DocDetailModel.h"

@implementation DocDetailModel

- (NSString *)content
{
    if ((_content == nil || [_content isEqualToString:@""]) == true) {
        return LocalizedString(@"N/A");
    }
    return  _content;
}

- (NSString *)area
{
    if ((_area == nil || [_area isEqualToString:@""]) == true) {
        return LocalizedString(@"N/A");
    }
    return  _area;
}

- (NSString *)officeSender
{
    if ((_officeSender == nil || [_officeSender isEqualToString:@""]) == true) {
        return LocalizedString(@"N/A");
    }
    return  _officeSender;
}

- (NSString *)toDate
{
    if ((_toDate == nil || [_toDate isEqualToString:@""]) == true) {
        return LocalizedString(@"N/A");
    }
    return  _toDate;
}


- (NSString *)priority
{
    if ((_priority == nil || [_priority isEqualToString:@""]) == true) {
        return LocalizedString(@"N/A");
    }
    return  _priority;
}

- (NSString *)stype
{
    if ((_stype == nil || [_stype isEqualToString:@""]) == true) {
        return LocalizedString(@"N/A");
    }
    return  _stype;
}

- (NSString *)signer{
	if ((_signer == nil || [_signer isEqualToString:@""]) == true) {
		return LocalizedString(@"N/A");
	}
	return  _signer;
}

- (NSString *)promulgatingDepart{
    if ((_promulgatingDepart == nil || [_promulgatingDepart isEqualToString:@""]) == true) {
        return LocalizedString(@"N/A");
    }
    return  _promulgatingDepart;

}

@end

