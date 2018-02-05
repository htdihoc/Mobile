//
//  TTNS_TimeKeepingDay.h
//  SmartOffice
//
//  Created by NguyenVanTu on 5/16/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TTNS_TimeKeepingDay : SOBaseModel
@property (strong, nonatomic) NSString *title;
@property (assign, nonatomic) NSInteger status;
@property (assign, nonatomic) long startDate;
@property (assign, nonatomic) BOOL isLock;
@end
