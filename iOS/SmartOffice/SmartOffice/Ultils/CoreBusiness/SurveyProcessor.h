//
//  SurveyProcessor.h
//  SmartOffice
//
//  Created by Vu Van Tiep on 4/18/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "THService.h"

@interface SurveyProcessor : NSObject

typedef void(^ApiResponseHandler)(id result, NSString * error);
typedef void(^HandleResponseError)(NSString *Error);
typedef void(^HandleResponseException)(NSString *Exception);

+ (void) getDataSurvey: (NSDictionary *)parameter handle:(ApiResponseHandler)handle onError:(HandleResponseError)onError onException:(HandleResponseException)onException;
+ (void) getCountDataSurvey:(NSDictionary *)parameter handle:(ApiResponseHandler)handle onError:(HandleResponseError)onError onException:(HandleResponseException)onException;

@end
