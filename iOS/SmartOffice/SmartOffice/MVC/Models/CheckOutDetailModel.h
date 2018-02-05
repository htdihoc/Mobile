//
//  CheckOutDetail.h
//  SmartOffice
//
//  Created by NguyenVanTu on 4/14/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SOBaseModel.h"
@interface CheckOutDetailModel : SOBaseModel
@property (strong, nonatomic) NSString *destinationPlace;

@property (strong, nonatomic) NSString *reason;

@property (strong, nonatomic) NSString *reasonDetail;

@property (strong, nonatomic) NSString *timeInterval;

@property (nonatomic, assign) CheckOutState state;

-(instancetype)initWithDesticationPlace:(NSString *)destinationPlace
                                 reason:(NSString *)reason
                           reasonDetail:(NSString *)reasonDetail
                           timeInterval:(NSString *)timeInterval
                                  state:(CheckOutState)state;
@end
