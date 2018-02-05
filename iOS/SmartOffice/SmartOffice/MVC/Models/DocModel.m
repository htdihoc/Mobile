//
//  DocModel.m
//  SmartOffice
//
//  Created by Kaka on 4/19/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "DocModel.h"

@implementation DocModel

- (void)setSenderName:(NSString *)senderName
{
    _senderName = senderName;
    _searchName = _senderName;
}
- (NSString *)textId
{
    return _documentId;
}

- (NSString *)promulgatingDepart
{
    if ((_promulgatingDepart == nil || [_promulgatingDepart isEqualToString:@""]) == true) {
        return LocalizedString(@"N/A");
    }
    return  _promulgatingDepart;
}


- (NSString *)signer
{
    if ((_signer == nil || [_signer isEqualToString:@""]) == true) {
        return LocalizedString(@"N/A");
    }
    return  _signer;
}
@end
