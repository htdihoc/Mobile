//
//  DocumentCategoryModel.m
//  SmartOffice
//
//  Created by Nguyen Duc Bien on 9/19/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import "DocumentCategoryModel.h"

@implementation DocumentCategoryModel

- (NSString *)content
{
    if ((_content == nil || [_content isEqualToString:@""]) == true) {
        return LocalizedString(@"N/A");
    }
    return  _content;
}

- (NSString *)documentDate
{
    if ((_documentDate == nil || [_documentDate isEqualToString:@""]) == true) {
        return LocalizedString(@"N/A");
    }
    return  _documentDate;
}


- (NSString *)documentNo
{
    if ((_documentNo == nil || [_documentNo isEqualToString:@""]) == true) {
        return LocalizedString(@"N/A");
    }
    return  _documentNo;
}


- (NSString *)documentType
{
    if ((_documentType == nil || [_documentType isEqualToString:@""]) == true) {
        return LocalizedString(@"N/A");
    }
    return  _documentType;
}

@end
