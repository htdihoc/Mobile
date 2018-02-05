//
//  ScheduleModel.h
//  SmartOffice
//
//  Created by Kaka on 4/12/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "SOBaseModel.h"

@interface ScheduleModel : SOBaseModel{
	
}
@property (strong, nonatomic) NSString *duration;
@property (strong, nonatomic) NSString *roomName;
@property (strong, nonatomic) NSString *subject;
@property (strong, nonatomic) NSString *startHour;
@property (strong, nonatomic) NSString *endHour;
@property (strong, nonatomic) NSString *startMinute;
@property (strong, nonatomic) NSString *endMinute;
@property (strong, nonatomic) NSString *startTime;
@property (strong, nonatomic) NSString *endTime;

@property (assign, nonatomic) BOOL isPresident;
@property (assign, nonatomic) BOOL isParticipate;
@property (assign, nonatomic) BOOL isPrepare;

@property (assign, nonatomic) NSInteger type;

@property (assign, nonatomic) NSUInteger meetingId;

@end
