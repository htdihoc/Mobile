//
//  KTTSProcessor.h
//  SmartOffice
//
//  Created by Vu Van Tiep on 5/4/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "THService.h"

@interface KTTSProcessor : NSObject

typedef void(^ApiResponseHandler)(id result, NSString *error);
typedef void(^HandleResponseError)(NSString *Error);
typedef void(^HandleResponseException)(NSString *Exception);

+ (void) postKTTS_CONFIRM_TTTS:(NSDictionary *)parameter handle:(ApiResponseHandler)handle onError:(HandleResponseError)onError onException:(HandleResponseException)onException;
+ (void) postKTTS_CANCEL_TTTS:(NSDictionary *)parameter handle:(ApiResponseHandler)handle onError:(HandleResponseError)onError onException:(HandleResponseException)onException;
+ (void) postKTTS_THONG_TIN_TAI_SAN: (NSDictionary *)parameter handle:(ApiResponseHandler)handle onError:(HandleResponseError)onError onException:(HandleResponseException)onException;
+ (void) postKTTS_BBBG: (NSDictionary *)parameter handle:(ApiResponseHandler)handle onError:(HandleResponseError)onError onException:(HandleResponseException)onException;
+ (void) postUpdateStatusEntity: (NSDictionary *)parameter handle:(ApiResponseHandler)handle onError:(HandleResponseError)onError onException:(HandleResponseException)onException;
+ (void) postDetailBBBG: (NSDictionary *)parameter handle:(ApiResponseHandler)handle onError:(HandleResponseError)onError onException:(HandleResponseException)onException;
+ (void) postCancelNotification: (NSDictionary *)parameter handle:(ApiResponseHandler)handle onError:(HandleResponseError)onError onException:(HandleResponseException)onException;
+ (void) postCountDataTTTS: (NSDictionary *)parameter handle:(ApiResponseHandler)handle onError:(HandleResponseError)onError onException:(HandleResponseException)onException;
+ (void) postCountDataDetailBBBG: (NSDictionary *)parameter handle:(ApiResponseHandler)handle onError:(HandleResponseError)onError onException:(HandleResponseException)onException;

@end
