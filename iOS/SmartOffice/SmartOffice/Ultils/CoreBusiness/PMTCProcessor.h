//
//  PMTCProcessor.h
//  SmartOffice
//
//  Created by Nguyen Duc Bien on 9/19/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "THService.h"

@interface PMTCProcessor : NSObject

typedef void(^ApiResponseHandler)(id result, NSString *error);
typedef void(^HandleResponseError)(NSString *Error);
typedef void(^HandleResponseException)(NSString *Exception);


+ (void) postPMTC_getDocumentByCategory:(NSDictionary *)parameter handle:(ApiResponseHandler)handle onError:(HandleResponseError)onError onException:(HandleResponseException)onException;

+ (void) postPMTC_getDocumentCategory:(NSDictionary *)parameter handle:(ApiResponseHandler)handle onError:(HandleResponseError)onError onException:(HandleResponseException)onException;

+ (void) postPMTC_getDocumentDetail:(NSDictionary *)parameter handle:(ApiResponseHandler)handle onError:(HandleResponseError)onError onException:(HandleResponseException)onException;

+ (void) postPMTC_getEmployeeDebt:(NSDictionary *)parameter handle:(ApiResponseHandler)handle onError:(HandleResponseError)onError onException:(HandleResponseException)onException;

+ (void) postPMTC_getEmployeeDebtTransaction:(NSDictionary *)parameter handle:(ApiResponseHandler)handle onError:(HandleResponseError)onError onException:(HandleResponseException)onException;

+ (void) postPMTC_searchDocumentByCategory:(NSDictionary *)parameter handle:(ApiResponseHandler)handle onError:(HandleResponseError)onError onException:(HandleResponseException)onException;

+ (void) postPMTC_searchDocumentCategory:(NSDictionary *)parameter handle:(ApiResponseHandler)handle onError:(HandleResponseError)onError onException:(HandleResponseException)onException;

+ (void) postPMTC_sendInvoice:(NSDictionary *)parameter handle:(ApiResponseHandler)handle onError:(HandleResponseError)onError onException:(HandleResponseException)onException;

+ (void) postPMTC_updateDocument:(NSDictionary *)parameter handle:(ApiResponseHandler)handle onError:(HandleResponseError)onError onException:(HandleResponseException)onException;



@end
