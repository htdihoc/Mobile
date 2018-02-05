//
//  TTNS_MainController.m
//  SmartOffice
//
//  Created by Administrator on 5/15/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import "TTNS_MainController.h"
#import "LeaveFormModel.h"

@implementation TTNS_MainController{
    NSMutableArray *_listRegisterLeave;
}

- (void)getAccessToken:(void (^)(BOOL isError))completion{
    // Check Network here00000000
    if([Common checkNetworkAvaiable]){
        
        [TTNSProcessor getAccessTokenTTNSWithComplete:^(BOOL success, NSDictionary *resultDict, NSException *exception) {
            if(success){
                DLog(@"Get access token success");
                NSString *accessToken = resultDict[@"data"][@"data"][@"access_token"];
                [SOSessionManager sharedSession].ttnsSession.accessToken = accessToken;
                [[SOSessionManager sharedSession]saveData];
            }
            
        }];
    }
}

- (void)getListRegisterLeave:(void (^)(NSMutableArray *_listRegisterForm))completion{
    [self loadListRegisterForm:^(BOOL success, NSDictionary *resultDict, NSException *exception) {
        if(success) {
            DLog(@"Load list register leave Success");
            
            NSArray *dictArr = resultDict[@"data"][@"entity"];
            NSMutableArray *listRegisterLeave = [LeaveFormModel arrayOfModelsFromDictionaries:dictArr error:nil];
            _listRegisterLeave = listRegisterLeave;
        } else {
            DLog(@"Error load list register leave");
        }
    }];
}

- (void)loadListRegisterForm:(Callback)completeHandler{
 
}

@end
