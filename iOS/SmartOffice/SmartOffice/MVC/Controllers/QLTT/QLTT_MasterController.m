//
//  QLTT_MasterController.m
//  SmartOffice
//
//  Created by NguyenVanTu on 5/16/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import "QLTT_MasterController.h"
#import "Common.h"
#import "QLTTProcessor.h"
#import "NSException+Custom.h"
@implementation QLTT_MasterController
- (void)loadData:(NSDictionary *)params delayedBatching:(BOOL)delayedBatching completion:(CallbackQLTT_MasterController)completion
{
    if (delayedBatching) {
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, DELAY_SEARCH_UTIL_QUERY_UNCHANGED_FOR_TIME_OFFSE);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
            [self loadData:params completion:completion];
        });
    }
    else {
        [self loadData:params completion:completion];
    }
}
- (void)loadData:(NSDictionary *)params completion:(CallbackQLTT_MasterController)completion
{
    if ([Common checkNetworkAvaiable]) {
        [QLTTProcessor getQLTTDocInfoWithComplete:params withComplete:^(BOOL success, NSDictionary *resultDict, NSException *exception) {
            if (success) {
                NSArray *dictModels = [[resultDict valueForKey:@"data"] valueForKey:@"result"];
                completion(success, dictModels, exception, resultDict);
            }
            else
            {
                completion(success, nil, exception, resultDict);
            }
        }];
    }else{
        completion(NO, nil, [NSException initWithNoNetWork], nil);
    }
}


@end
