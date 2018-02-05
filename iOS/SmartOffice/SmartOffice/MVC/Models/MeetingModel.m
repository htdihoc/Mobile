//
//  MeetingModel.m
//  SmartOffice
//
//  Created by Kaka on 4/12/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "MeetingModel.h"
#import "NSString+Util.h"
@implementation MeetingModel
//subject
//summary
//roomName
//contactPerson
- (NSString *)subject
{
    if (![_subject checkValidString]) {
        return LocalizedString(@"N/A");
    }
    return _subject;
}

- (NSString *)summary
{
    if (![_summary checkValidString]) {
        return LocalizedString(@"N/A");
    }
    return _summary;
}

- (NSString *)roomName
{
    if (![_roomName checkValidString]) {
        return LocalizedString(@"N/A");
    }
    return _roomName;
}

- (NSString *)contactPerson
{
    if (![_subject checkValidString]) {
        return LocalizedString(@"N/A");
    }
    return _contactPerson;
}
@end
