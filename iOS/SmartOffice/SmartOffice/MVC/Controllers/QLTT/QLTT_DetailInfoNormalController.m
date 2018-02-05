//
//  QLTT_DetailInfoNormalController.m
//  SmartOffice
//
//  Created by NguyenVanTu on 5/18/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import "QLTT_DetailInfoNormalController.h"
#import "Common.h"
#import "QLTTProcessor.h"
#import "NSException+Custom.h"

@implementation QLTT_DetailInfoNormalController
- (void)likeDocument:(NSNumber *)documentID employeeID:(NSNumber *)employeeID completion:(CallBackQLTT_DetailInfoNormalController)completion
{
    if ([Common checkNetworkAvaiable]) {
        if (documentID == nil || employeeID == nil) {
            return;
        }
        NSDictionary *params = @{@"documentId" : documentID, @"code":employeeID};
        [QLTTProcessor postQLTTLikeDocument:params withComplete:^(BOOL success, NSDictionary *resultDict, NSException *exception) {
            if (success) {
                NSNumber *resultCode = resultDict[@"resultCode"];
                if ([resultCode integerValue] == 200) {
                    completion(success, nil, nil, resultDict);
                }
                else
                {
                    completion(success, resultCode, exception, resultDict);
                }
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

- (void)checkLikeDocument:(NSNumber *)documentID employeeID:(NSNumber *)employeeID completion:(CallBackQLTT_DetailInfoNormalControllerCheckLike)completion
{
    if ([Common checkNetworkAvaiable]) {
        if (documentID == nil || employeeID == nil) {
            return;
        }
        NSDictionary *params = @{@"documentId" : documentID, @"code":employeeID, @"typeContain" : @"0"};
        [QLTTProcessor postQLTTCheckLikeDocument:params withComplete:^(BOOL success, NSDictionary *resultDict, NSException *exception) {
            if (success) {
                NSNumber *resultCode = resultDict[@"resultCode"];
                if ([resultCode integerValue] == 200) {
                    NSString *isLike = [[resultDict valueForKey:@"data"] valueForKey:@"result"];
                    BOOL _isLike = [isLike isEqualToString:@"true"];
                    completion(success, nil, nil, _isLike, resultDict);
                }
                else
                {
                    completion(success, resultCode, exception, NO, resultDict);
                }
            }
            else
            {
                completion(success, nil, exception, NO, resultDict);
            }
        }];
    }else{
        completion(NO, nil, [NSException initWithNoNetWork], NO, nil);
    }
}
- (void)getDocsWith:(NSNumber *)CategoryID
{
    
}

- (void)getMasterDocDetail:(NSNumber *)documentID completion:(CallBackQLTT_DetailInfoNormalModelDetailController)completion
{
    NSNumber *employeeCode = [GlobalObj getInstance].qltt_employeeCode;
    if (!documentID || !employeeCode) {
        completion(NO, nil, [NSException initWithCode:@1], nil);
        return;
    }
    NSDictionary *params = @{@"documentId": documentID,
                             @"type" : @0,
                             @"employeeCode": employeeCode};
    if ([Common checkNetworkAvaiable]) {
        [QLTTProcessor getQLTTDocInfoWithComplete:params withComplete:^(BOOL success, NSDictionary *resultDict, NSException *exception) {
            if (success) {
                NSArray *dictModels = [[resultDict valueForKey:@"data"] valueForKey:@"result"];
                if (dictModels.count > 0) {
                    QLTTMasterDocumentModel *model = [[QLTTMasterDocumentModel alloc] initWithDictionary:dictModels.firstObject error:nil];
                    
                    completion(success, model, exception, resultDict);
                }
                else
                {
                    completion(success, nil, exception, resultDict);
                }
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
