//
//  PMTCProcessor.m
//  SmartOffice
//
//  Created by Nguyen Duc Bien on 9/19/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import "PMTCProcessor.h"
#import "GlobalObj.h"
#import "SOSessionManager.h"
#import "VOfficeSessionModel.h"

@implementation PMTCProcessor

#define PMTC_GET_DOCUMENT_BY_CATEGORY           @"pmtc/getDocumentByCategory"
#define PMTC_GET_DOCUMENT_CATEGORY              @"pmtc/getDocumentCategory"
#define PMTC_GET_DOCUMENT_DETAIL                @"pmtc/getDocumentDetail"
#define PMTC_GET_EMPLOYEE_DEBT                  @"pmtc/getEmployeeDebt"
#define PMTC_GET_EMPLOYEE_DEBT_TRANSACTION      @"pmtc/getEmployeeDebtTransaction"
#define PMTC_SEARCH_DOCUMENT_BY_CATEGORY        @"pmtc/searchDocumentByCategory"
#define PMTC_SEARCH_DOCUMENT_CATEGORY           @"pmtc/searchDocumentCategory"
#define PMTC_SEND_INVOICE                       @"pmtc/sendInvoice"
#define PMTC_UPDATE_DOCUMENT                    @"pmtc/updateDocument"


+ (void) postPMTC_getDocumentByCategory:(NSDictionary *)parameter handle:(ApiResponseHandler)handle onError:(HandleResponseError)onError onException:(HandleResponseException)onException {
    [THService requestPOSTFromUrl: [[GlobalObj getInstance] getApiFullUrl: PMTC_GET_DOCUMENT_BY_CATEGORY] parameter: parameter withProgress:nil completion:^(NSDictionary *response) {
        if ([response[@"resultCode"] integerValue] == 200) {
            handle((NSDictionary *)response[@"data"], nil);
        }
    } onError:^(NSDictionary *error) {
        onError(nil);
    } onException:^(NSException *exception) {
        onException(nil);
    }];
}

+ (void) postPMTC_getDocumentCategory:(NSDictionary *)parameter handle:(ApiResponseHandler)handle onError:(HandleResponseError)onError onException:(HandleResponseException)onException {
    [THService requestPOSTFromUrl: [[GlobalObj getInstance] getApiFullUrl: PMTC_GET_DOCUMENT_CATEGORY] parameter: nil withProgress:nil completion:^(NSDictionary *response) {
        if ([response[@"resultCode"] integerValue] == 200) {
            handle((NSDictionary *)response[@"data"], nil);
        }
    } onError:^(NSDictionary *error) {
        onError(nil);
    } onException:^(NSException *exception) {
        onException(nil);
    }];
}

+ (void) postPMTC_getDocumentDetail:(NSDictionary *)parameter handle:(ApiResponseHandler)handle onError:(HandleResponseError)onError onException:(HandleResponseException)onException {
    [THService requestPOSTFromUrl: [[GlobalObj getInstance] getApiFullUrl: PMTC_GET_DOCUMENT_DETAIL] parameter: parameter withProgress:nil completion:^(NSDictionary *response) {
        if ([response[@"resultCode"] integerValue] == 200) {
            handle((NSDictionary *)response[@"data"], nil);
        }
    } onError:^(NSDictionary *error) {
        onError(nil);
    } onException:^(NSException *exception) {
        onException(nil);
    }];
}

+ (void) postPMTC_getEmployeeDebt:(NSDictionary *)parameter handle:(ApiResponseHandler)handle onError:(HandleResponseError)onError onException:(HandleResponseException)onException {
    [THService requestPOSTFromUrl: [[GlobalObj getInstance] getApiFullUrl: PMTC_GET_EMPLOYEE_DEBT] parameter: parameter withProgress:nil completion:^(NSDictionary *response) {
        if ([response[@"resultCode"] integerValue] == 200) {
            handle((NSDictionary *)response[@"data"], nil);
        }
    } onError:^(NSDictionary *error) {
        onError(nil);
    } onException:^(NSException *exception) {
        onException(nil);
    }];
}

+ (void) postPMTC_getEmployeeDebtTransaction:(NSDictionary *)parameter handle:(ApiResponseHandler)handle onError:(HandleResponseError)onError onException:(HandleResponseException)onException {
    [THService requestPOSTFromUrl: [[GlobalObj getInstance] getApiFullUrl: PMTC_GET_EMPLOYEE_DEBT_TRANSACTION] parameter: parameter withProgress:nil completion:^(NSDictionary *response) {
        if ([response[@"resultCode"] integerValue] == 200) {
            handle((NSDictionary *)response[@"data"], nil);
        }
    } onError:^(NSDictionary *error) {
        onError(nil);
    } onException:^(NSException *exception) {
        onException(nil);
    }];
}

+ (void) postPMTC_searchDocumentByCategory:(NSDictionary *)parameter handle:(ApiResponseHandler)handle onError:(HandleResponseError)onError onException:(HandleResponseException)onException {
    [THService requestPOSTFromUrl: [[GlobalObj getInstance] getApiFullUrl: PMTC_SEARCH_DOCUMENT_BY_CATEGORY] parameter: parameter withProgress:nil completion:^(NSDictionary *response) {
        if ([response[@"resultCode"] integerValue] == 200) {
            handle((NSDictionary *)response[@"data"], nil);
        }
    } onError:^(NSDictionary *error) {
        onError(nil);
    } onException:^(NSException *exception) {
        onException(nil);
    }];
}

+ (void) postPMTC_searchDocumentCategory:(NSDictionary *)parameter handle:(ApiResponseHandler)handle onError:(HandleResponseError)onError onException:(HandleResponseException)onException {
    [THService requestPOSTFromUrl: [[GlobalObj getInstance] getApiFullUrl: PMTC_SEARCH_DOCUMENT_CATEGORY] parameter: parameter withProgress:nil completion:^(NSDictionary *response) {
        if ([response[@"resultCode"] integerValue] == 200) {
            handle((NSDictionary *)response[@"data"], nil);
        }
    } onError:^(NSDictionary *error) {
        onError(nil);
    } onException:^(NSException *exception) {
        onException(nil);
    }];
}


+ (void) postPMTC_sendInvoice:(NSDictionary *)parameter handle:(ApiResponseHandler)handle onError:(HandleResponseError)onError onException:(HandleResponseException)onException {
    [THService requestPOSTFromUrl: [[GlobalObj getInstance] getApiFullUrl: PMTC_SEND_INVOICE] parameter: parameter withProgress:nil completion:^(NSDictionary *response) {
        if ([response[@"resultCode"] integerValue] == 200) {
            handle((NSDictionary *)response[@"data"], nil);
        }
    } onError:^(NSDictionary *error) {
        onError(nil);
    } onException:^(NSException *exception) {
        onException(nil);
    }];
}


+ (void) postPMTC_updateDocument:(NSDictionary *)parameter handle:(ApiResponseHandler)handle onError:(HandleResponseError)onError onException:(HandleResponseException)onException {
    [THService requestPOSTFromUrl: [[GlobalObj getInstance] getApiFullUrl: PMTC_UPDATE_DOCUMENT] parameter: parameter withProgress:nil completion:^(NSDictionary *response) {
        if ([response[@"resultCode"] integerValue] == 200) {
            handle((NSDictionary *)response[@"data"], nil);
        }
    } onError:^(NSDictionary *error) {
        onError(nil);
    } onException:^(NSException *exception) {
        onException(nil);
    }];
}

//#pragma mark - Singleton
//
//+ (PMTCProcessor *)shareInstance{
//	static PMTCProcessor *_instance = nil;
//	static dispatch_once_t onceToken;
//	dispatch_once(&onceToken, ^{
//		_instance = [[PMTCProcessor alloc] init];
//	});
//	
//	return _instance;
//}
//
//#pragma mark - MAIN API
//- (void) postPMTC_getDocumentByCategory:(NSString *)documentType pageSize:(NSInteger)pageSize pageNumber:(NSInteger) pageNumber completion:(Callback)callBack{
//    NSDictionary *params = @{@"arg0": @"HDMH",
//                             @"arg1": @20,
//                             @"arg2": @0};
//    [THService requestPOSTFromUrl:PMTC_GET_DOCUMENT_BY_CATEGORY parameter:params withProgress:^(float progress) {
//    } completion:^(NSDictionary *response) {
//        callBack(YES, response, nil);
//    } onError:^(NSDictionary *error) {
//        callBack(NO, error, nil);
//    } onException:^(NSException *exception) {
//        callBack(NO, nil, exception);
//    }];
//}
//
//
//- (void)postPMTC_getDocumentCategory:(Callback)callBack{
//    [THService requestPOSTFromUrl:PMTC_GET_DOCUMENT_CATEGORY parameter:nil withProgress:^(float progress) {
//        
//    } completion:^(NSDictionary *response) {
//        callBack(YES, response, nil);
//    } onError:^(NSDictionary *error) {
//        callBack(NO, error, nil);
//    } onException:^(NSException *exception) {
//        callBack(NO, nil, exception);
//    }];
//}
//
//
//- (void) postPMTC_getDocumentDetail:(NSString *)documentType documentNo:(NSString *)documentNo completion:(Callback)callBack{
//    NSDictionary *params = @{@"arg0": @"HDMH",
//                             @"arg1": @"quanph4"
//                             };
//    [THService requestPOSTFromUrl:PMTC_GET_DOCUMENT_DETAIL parameter:params withProgress:^(float progress) {
//        
//    } completion:^(NSDictionary *response) {
//        callBack(YES, response, nil);
//    } onError:^(NSDictionary *error) {
//        callBack(NO, error, nil);
//    } onException:^(NSException *exception) {
//        callBack(NO, nil, exception);
//    }];
//}
//
//- (void)postPMTC_getEmployeeDebt:(NSString *)employeeID completion:(Callback)callBack{
//    NSDictionary *params = @{@"arg0": @"111999"
//                             };
//    [THService requestPOSTFromUrl:PMTC_GET_DOCUMENT_DETAIL parameter:params withProgress:^(float progress) {
//        
//    } completion:^(NSDictionary *response) {
//        callBack(YES, response, nil);
//    } onError:^(NSDictionary *error) {
//        callBack(NO, error, nil);
//    } onException:^(NSException *exception) {
//        callBack(NO, nil, exception);
//    }];
//}
//
//
//- (void)postPMTC_getDocumentByCategory:(NSString *)imageData andOhter:(NSString *)vaulueOther completion:(Callback)callBack{
//    //Need change token and name keyp arams
//    NSString *access_token = [SOSessionManager sharedSession].vofficeSession.access_token;
//    NSDictionary *params = @{@"access_token" : access_token, @"contentImage": imageData, @"otherKey": vaulueOther};
//    [THService requestPOSTFromUrl:PMTC_UPLOAD_API parameter:params withProgress:^(float progress) {
//        
//    } completion:^(NSDictionary *response) {
//        callBack(YES, response, nil);
//    } onError:^(NSDictionary *error) {
//        callBack(NO, error, nil);
//    } onException:^(NSException *exception) {
//        callBack(NO, nil, exception);
//    }];
//}

@end
