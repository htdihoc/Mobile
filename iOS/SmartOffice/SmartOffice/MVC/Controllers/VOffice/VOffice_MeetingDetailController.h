//
//  VOffice_MeetingDetailController.h
//  SmartOffice
//
//  Created by NguyenVanTu on 6/2/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DetailMeetingModel.h"
typedef void (^CallbackVOffice_VOffice_MeetingDetail)(BOOL success, DetailMeetingModel *meetingDetail, NSException *exception, NSDictionary *error);
@interface VOffice_MeetingDetailController : NSObject
+ (void)loadMeetingDetail:(NSString *)meetingId completion:(CallbackVOffice_VOffice_MeetingDetail)completion;
@end
