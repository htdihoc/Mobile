//
//  VOffice_MeetingDetailController.m
//  SmartOffice
//
//  Created by NguyenVanTu on 6/2/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import "VOffice_MeetingDetailController.h"
#import "VOfficeProcessor.h"
#import "Common.h"
#import "NSException+Custom.h"
@implementation VOffice_MeetingDetailController
+ (void)loadMeetingDetail:(NSString *)meetingId completion:(CallbackVOffice_VOffice_MeetingDetail)completion
{
    if ([Common checkNetworkAvaiable]) {
    [VOfficeProcessor detailMeetingByID:meetingId callBack:^(BOOL success, NSDictionary *resultDict, NSException *exception) {
        if (success) {
            NSDictionary *dictModel = resultDict[@"data"];
            DetailMeetingModel * detail = [[DetailMeetingModel alloc] initWithDictionary:dictModel error:nil];
            completion(success, detail, exception, nil);
        }else{
            completion(success, nil, exception, resultDict);
        }
        [[Common shareInstance] dismissHUD];
    }];
    }
    else
    {
        completion(NO, nil, [NSException initWithNoNetWork], nil);
    }
}

@end
