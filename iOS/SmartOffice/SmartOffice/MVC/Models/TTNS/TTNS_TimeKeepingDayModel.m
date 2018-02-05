//
//  TTNS_TimeKeepingDay.m
//  SmartOffice
//
//  Created by NguyenVanTu on 5/16/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import "TTNS_TimeKeepingDayModel.h"

@implementation TTNS_TimeKeepingDayModel
-(instancetype) initWithStatus:(NSInteger)status startDate:(NSTimeInterval)startDate
{
    self = [super init];
    if (self) {
        _status = status;
        _startDate = startDate;
    }
    return self;
    
}
- (NSString *)title
{
    if ([_title isEqualToString:@"X:8"] || _title == nil) {
        return @"";
    }
    return _title;
}
@end
