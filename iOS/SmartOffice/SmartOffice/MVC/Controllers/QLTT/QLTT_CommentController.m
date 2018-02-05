//
//  QLTT_CommentController.m
//  SmartOffice
//
//  Created by NguyenVanTu on 5/24/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import "QLTT_CommentController.h"
#import "QLTTProcessor.h"
#import "NSException+Custom.h"

@implementation QLTT_CommentController
- (void)loadComment:(NSNumber *)documentId completion:(CallbackQLTT_CommentController)completion
{
    if ([Common checkNetworkAvaiable]) {
        [QLTTProcessor getQLTTListComment:documentId withComplete:^(BOOL success, NSDictionary *resultDict, NSException *exception) {
            if (success) {
                NSArray *results = [[resultDict valueForKey:@"data"] valueForKey:@"result"];
                completion(success, results, exception, resultDict);
            }
            else
            {
                completion(NO, NULL, exception, resultDict);
            }
        }];
    }else{
        completion(NO, NULL, [NSException initWithNoNetWork], NULL);
    }
}

- (void)sendComment:(NSNumber *)documentId content:(NSString *)content createdUser:(NSString *)createdUser completion:(CallbackQLTT_CommentController)completion
{
    if ([Common checkNetworkAvaiable]) {
        
        //get current user here
        if (documentId == nil || createdUser == nil) {
            return;
        }
        NSDictionary *params = @{@"documentId" : documentId, @"content":content == nil ? [NSNull null] : content, @"createdUser" : createdUser};
        [QLTTProcessor sendComment:params
                      withComplete:^(BOOL success, NSDictionary *resultDict, NSException *exception) {
            if (success) {
                NSNumber *resultCode = [resultDict valueForKey:@"resultCode"];
                if ([resultCode longValue] == 200) {
                    completion(success, nil, exception, resultDict);
                }
                else
                {
                    DLog(@"Can't send the message");
                    completion(NO, nil, exception, resultDict);
                }
                
            }
            else
            {
                completion(NO, NULL, exception, resultDict);
            }
        }];
    }else{
        completion(NO, NULL, [NSException initWithNoNetWork], NULL);
    }
}


@end
