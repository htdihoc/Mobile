//
//  QLTT_TreeViewModeController.m
//  SmartOffice
//
//  Created by NguyenVanTu on 5/16/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import "QLTT_TreeViewModeController.h"
#import "Common.h"
#import "QLTTProcessor.h"
#import "NSException+Custom.h"

@implementation QLTT_TreeViewModeController
- (void)loadData:(NSDictionary *)params completion:(CallbackQLTT_TreeViewModeController)completion
{
    if ([Common checkNetworkAvaiable]) {
        NSDictionary *params = @{@"type" : @1};
        [QLTTProcessor getQLTTDocCategoryWithComplete:params withComplete:^(BOOL success, NSDictionary *resultDict, NSException *exception) {
            if (success) {
                DLog(@"Get AccessToken Success")
                NSArray *dictModels = resultDict[@"data"][@"result"];
                completion(success, dictModels, exception, resultDict);
            }
            else
            {
                //error
                completion(success, NULL, exception, resultDict);
            }
        }];
    }else{
        //network error
         completion(NO, NULL, [NSException initWithNoNetWork], NULL);
    }
}
@end
