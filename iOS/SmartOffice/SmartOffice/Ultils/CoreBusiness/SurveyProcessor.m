//
//  SurveyProcessor.m
//  SmartOffice
//
//  Created by Vu Van Tiep on 4/18/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "SurveyProcessor.h"
#import "GlobalObj.h"
#import "SurveyViewController.h"

#define TTNS_LIST_SURVEY        @"/survey/getNotSurveys"
#define TTNS_COUNT_SURVEY       @"/survey/countNotSurvey"

@implementation SurveyProcessor

+ (void) getDataSurvey:(NSDictionary *)parameter handle:(ApiResponseHandler)handle onError:(HandleResponseError)onError onException:(HandleResponseException)onException {
    [THService requestPOSTFromUrl: [[GlobalObj getInstance] getApiFullUrl: TTNS_LIST_SURVEY] parameter:parameter withProgress:nil completion:^(NSDictionary *response) {
        if ([response[@"resultCode"] integerValue] == 200) {
            handle((NSDictionary *)response[@"data"], nil);
        }
    } onError:^(NSDictionary *error) {
        onError(nil);
    } onException:^(NSException *exception) {
        onException(nil);
    }];
}

+ (void) getCountDataSurvey:(NSDictionary *)parameter handle:(ApiResponseHandler)handle onError:(HandleResponseError)onError onException:(HandleResponseException)onException {
    [THService requestPOSTFromUrl: [[GlobalObj getInstance] getApiFullUrl: TTNS_COUNT_SURVEY] parameter:parameter withProgress:nil completion:^(NSDictionary *response) {
        if ([response[@"resultCode"] integerValue] == 200) {
            handle((NSDictionary *)response[@"data"], nil);
        }
    } onError:^(NSDictionary *error) {
        onError(nil);
    } onException:^(NSException *exception) {
        onException(nil);
    }];
}

@end
