//
//  CheckOutDetail.m
//  SmartOffice
//
//  Created by NguyenVanTu on 4/14/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "CheckOutDetailModel.h"

@implementation CheckOutDetailModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}
-(instancetype)initWithDesticationPlace:(NSString *)destinationPlace
                                 reason:(NSString *)reason
                           reasonDetail:(NSString *)reasonDetail
                           timeInterval:(NSString *)timeInterval
                                  state:(CheckOutState)state
{
    self = [super init];
    if (self) {
        self.destinationPlace = destinationPlace;
        self.reason = reason;
        self.reasonDetail = reasonDetail;
        self.timeInterval = timeInterval;
        self.state = state;
    }
    return self;
}
@end
