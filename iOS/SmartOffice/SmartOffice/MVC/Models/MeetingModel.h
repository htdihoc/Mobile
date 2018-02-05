//
//  MeetingModel.h
//  SmartOffice
//
//  Created by Kaka on 4/12/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "SOBaseModel.h"
#import "EmployeeModel.h"

@interface MeetingModel : SOBaseModel{
	
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

@property (strong, nonatomic) NSString *contactPerson;
@property (strong, nonatomic) NSString *content;

@property (strong, nonatomic) NSString *participant;
@property (strong, nonatomic) NSString *summary;

@property (assign, nonatomic) BOOL isPresident;
@property (assign, nonatomic) BOOL isParticipate;
@property (assign, nonatomic) BOOL isPrepare;

@property (assign, nonatomic) NSInteger type;

@property (strong, nonatomic) NSString *meetingId;
@property (strong, nonatomic) NSArray<EmployeeModel> *listMembers;

@end
