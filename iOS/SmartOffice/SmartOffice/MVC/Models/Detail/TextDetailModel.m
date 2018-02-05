//
//  TextDetailModel.m
//  SmartOffice
//
//  Created by Kaka on 5/16/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import "TextDetailModel.h"

@implementation TextDetailModel

- (NSString *)content
{
    if ((_content == nil || [_content isEqualToString:@""]) == true) {
        return LocalizedString(@"N/A");
    }
    return  _content;
}

- (NSString *)departSentSign
{
    if ((_departSentSign == nil || [_departSentSign isEqualToString:@""]) == true) {
        return LocalizedString(@"N/A");
    }
    return  _departSentSign;
}

- (NSString *)creator
{
    if ((_creator == nil || [_creator isEqualToString:@""]) == true) {
        return LocalizedString(@"N/A");
    }
    return  _creator;
}

- (NSString *)createDate
{
    if ((_createDate == nil || [_createDate isEqualToString:@""]) == true) {
        return LocalizedString(@"N/A");
    }
    return  _createDate;
}

- (NSString *)securityName
{
    if ((_securityName == nil || [_securityName isEqualToString:@""]) == true) {
        return LocalizedString(@"N/A");
    }
    return  _securityName;
}

- (NSString *)urgencyName
{
    if ((_urgencyName == nil || [_urgencyName isEqualToString:@""]) == true) {
        return LocalizedString(@"N/A");
    }
    return  _urgencyName;
}

@end
