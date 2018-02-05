//
//  QLTTMasterDocumentModel.m
//  SmartOffice
//
//  Created by NguyenVanTu on 5/9/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "QLTTMasterDocumentModel.h"
#import "NSString+Util.h"
@implementation QLTTMasterDocumentModel
@synthesize description;
- (instancetype)init
{
    self = [super init];
    if (self) {
        _children = [NSMutableArray new];
    }
    return self;
}

- (NSString *)effectStatusString
{
    if ((_effectStatusString == nil || [_effectStatusString isEqualToString:@""]) == true) {
        return @"N/A";
    }
    return  _effectStatusString;
}
- (NSString *)statusName
{
    if ((_statusName == nil || [_statusName isEqualToString:@""]) == true) {
        return @"N/A";
    }
    return  _statusName;
}
- (NSString *)name
{
    if ((_name == nil || [_name isEqualToString:@""]) == true) {
        return @"N/A";
    }
    return  _name;
}
- (NSString *)authorName
{
    if ((_authorName == nil || [_authorName isEqualToString:@""]) == true) {
        return @"N/A";
    }
    return  _authorName;
}

- (NSString *)fileSize
{
    if ((_fileSize == nil || [_fileSize isEqualToString:@""]) == true) {
        return @"N/A";
    }
    return  _fileSize;
}

- (NSString *)approvalName
{
    if ((_approvalName == nil || [_approvalName isEqualToString:@""]) == true) {
        return @"N/A";
    }
    return  _approvalName;
}

- (NSString *)version
{
    if ((_version == nil || [_version isEqualToString:@""]) == true) {
        return @"N/A";
    }
    return  _version;
}

- (NSString *)code
{
    if ((_code == nil || [_code isEqualToString:@""]) == true) {
        return @"N/A";
    }
    return  _code;
}

//- (NSString *)description
//{
//    if ((description == nil || [description isEqualToString:@""]) == true) {
//        return @"N/A";
//    }
//    return  description;
//}

- (NSString *)expiredDate
{
    if ((_expiredDate == nil || [_expiredDate isEqualToString:@""]) == true) {
        return @"N/A";
    }
    return  _expiredDate;
}
- (NSString *)createdDate
{
    if ((_createdDate == nil || [_createdDate isEqualToString:@""]) == true) {
        return @"N/A";
    }
    return  _createdDate;
}
- (NSString *)effectiveDate
{
    if ((_effectiveDate == nil || [_effectiveDate isEqualToString:@""]) == true) {
        return @"N/A";
    }
    return  _effectiveDate;
}

- (NSString *)createdUser
{
    if ((_createdUser == nil || [_createdUser isEqualToString:@""]) == true) {
        return @"N/A";
    }
    return  _createdUser;
}

- (NSString *)language
{
    if ((_language == nil || [_language isEqualToString:@""]) == true) {
        return @"N/A";
    }
    return  _language;
}
- (NSString *)pageNumber
{
    if ((_pageNumber == nil || [_pageNumber isEqualToString:@""]) == true) {
        return @"N/A";
    }
    return  _pageNumber;
}
- (NSString *)fileType
{
    //with file type i will return @"" if it is nill
    if ((_fileType == nil || [_fileType isEqualToString:@""]) == true) {
        return @"";
    }
    return  _fileType;
}
- (NSString *)documentCategoryId
{
    if (_documentCategoryId == nil || [_documentCategoryId checkSpace]) {
        if ([[_documentCategoryIds.firstObject stringValue] checkSpace]) {
            return @"";
        }
        else
        {
            return [_documentCategoryIds.firstObject stringValue];
        }
    }
    return _documentCategoryId;
}

- (void)setAvatar:(NSArray<QLTTFileAttachmentModel*> *)avatar
{
    _avatar = [QLTTFileAttachmentModel arrayOfModelsFromDictionaries:avatar error:nil];
}
- (void)setFileAttachment:(NSArray<QLTTFileAttachmentModel*> *)fileAttachment
{
    _fileAttachment = [QLTTFileAttachmentModel arrayOfModelsFromDictionaries:fileAttachment error:nil];
}
- (void)setFileAttachment:(NSArray<QLTTFileAttachmentModel*> *)fileAttachment andAvatar:(NSArray<QLTTFileAttachmentModel*> *)avatar
{
    _fileAttachment = fileAttachment;
    _avatar = avatar;
}
@end
