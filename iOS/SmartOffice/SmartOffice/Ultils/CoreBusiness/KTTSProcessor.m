//
//  KTTSProcessor.m
//  SmartOffice
//
//  Created by Vu Van Tiep on 5/4/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "KTTSProcessor.h"
#import "GlobalObj.h"

@implementation KTTSProcessor

#define KTTS_THONG_TIN_TAI_SAN          @"ktts/getListEntityByUser"
#define KTTS_BBBG                       @"ktts/getListHandoverByUser"
#define KTTS_UPDATE_STATUS_ENTYTI       @"ktts/updateStatusEntity"
#define KTTS_DETAIL_BBBG                @"ktts/getListEntityInHan"
#define KTTS_CANCEL_NOTI                @"ktts/rejectAssetManager"
#define KTTS_COUNT_TTTS                 @"ktts/countEntityByUser"
#define KTTS_COUNT_DETAIL_BBBG          @"ktts/countEntityInHan"
#define KTTS_CANCEL_TTTS                @"ktts/rejectAssetManager"
#define KTTS_CONFIRM_TTTS               @"ktts/updateStatusEntity"

+ (void) postKTTS_CONFIRM_TTTS:(NSDictionary *)parameter handle:(ApiResponseHandler)handle onError:(HandleResponseError)onError onException:(HandleResponseException)onException {
    [THService requestPOSTFromUrl: [[GlobalObj getInstance] getApiFullUrl: KTTS_CONFIRM_TTTS] parameter: parameter withProgress:nil completion:^(NSDictionary *response) {
        if ([response[@"resultCode"] integerValue] == 200) {
            handle((NSDictionary *)response[@"data"], nil);
        }
    } onError:^(NSDictionary *error) {
        onError([error objectForKey:@"message"]);
    } onException:^(NSException *exception) {
        onException(exception.description);
    }];
}

+ (void) postKTTS_CANCEL_TTTS:(NSDictionary *)parameter handle:(ApiResponseHandler)handle onError:(HandleResponseError)onError onException:(HandleResponseException)onException {
    [THService requestPOSTFromUrl: [[GlobalObj getInstance] getApiFullUrl: KTTS_CANCEL_TTTS] parameter: parameter withProgress:nil completion:^(NSDictionary *response) {
        if ([response[@"resultCode"] integerValue] == 200) {
            handle((NSDictionary *)response[@"data"], nil);
        }
    } onError:^(NSDictionary *error) {
        onError(nil);
    } onException:^(NSException *exception) {
        onException(nil);
    }];
}

+ (void) postKTTS_THONG_TIN_TAI_SAN:(NSDictionary *)parameter handle:(ApiResponseHandler)handle onError:(HandleResponseError)onError onException:(HandleResponseException)onException {
    [THService requestPOSTFromUrl: [[GlobalObj getInstance] getApiFullUrl: KTTS_THONG_TIN_TAI_SAN] parameter: parameter withProgress:nil completion:^(NSDictionary *response) {
        if ([response[@"resultCode"] integerValue] == 200) {
            handle((NSDictionary *)response[@"data"], nil);
        }
    } onError:^(NSDictionary *error) {
        onError(nil);
    } onException:^(NSException *exception) {
        onException(nil);
    }];
}

+ (void) postKTTS_BBBG:(NSDictionary *)parameter handle:(ApiResponseHandler)handle onError:(HandleResponseError)onError onException:(HandleResponseException)onException {
    [THService requestPOSTFromUrl: [[GlobalObj getInstance] getApiFullUrl: KTTS_BBBG] parameter:parameter withProgress:nil completion:^(NSDictionary *response) {
        if ([response[@"resultCode"] integerValue] == 200) {
            handle((NSDictionary *)response[@"data"], nil);
        }
    } onError:^(NSDictionary *error) {
        onError(nil);
    } onException:^(NSException *exception) {
        onException(nil);
    }];
}

+ (void) postUpdateStatusEntity:(NSDictionary *)parameter handle:(ApiResponseHandler)handle onError:(HandleResponseError)onError onException:(HandleResponseException)onException {
    [THService requestPOSTFromUrl: [[GlobalObj getInstance] getApiFullUrl: KTTS_UPDATE_STATUS_ENTYTI] parameter:parameter withProgress:nil completion:^(NSDictionary *response) {
        if ([response[@"resultCode"] integerValue] == 200) {
            handle((NSDictionary *)response[@"data"], nil);
        }
    } onError:^(NSDictionary *error) {
        onError(nil);
    } onException:^(NSException *exception) {
        onException(nil);
    }];
}

+ (void) postDetailBBBG:(NSDictionary *)parameter handle:(ApiResponseHandler)handle onError:(HandleResponseError)onError onException:(HandleResponseException)onException {
    [THService requestPOSTFromUrl: [[GlobalObj getInstance] getApiFullUrl: KTTS_DETAIL_BBBG] parameter:parameter withProgress:nil completion:^(NSDictionary *response) {
        if ([response[@"resultCode"] integerValue] == 200) {
            handle((NSDictionary *)response[@"data"], nil);
        }
    } onError:^(NSDictionary *error) {
        onError(nil);
    } onException:^(NSException *exception) {
        onException(nil);
    }];
}

+ (void) postCancelNotification:(NSDictionary *)parameter handle:(ApiResponseHandler)handle onError:(HandleResponseError)onError onException:(HandleResponseException)onException {
    [THService requestPOSTFromUrl: [[GlobalObj getInstance] getApiFullUrl: KTTS_CANCEL_NOTI] parameter:parameter withProgress:nil completion:^(NSDictionary *response) {
        
    } onError:^(NSDictionary *error) {
        onError(nil);
    } onException:^(NSException *exception) {
        onException(nil);
    }];
}

+ (void) postCountDataTTTS:(NSDictionary *)parameter handle:(ApiResponseHandler)handle onError:(HandleResponseError)onError onException:(HandleResponseException)onException {
    [THService requestPOSTFromUrl: [[GlobalObj getInstance] getApiFullUrl: KTTS_COUNT_TTTS] parameter:parameter withProgress:nil completion:^(NSDictionary *response) {
        if ([response[@"resultCode"] integerValue] == 200) {
            handle((NSDictionary *)response[@"data"], nil);
        }
    } onError:^(NSDictionary *error) {
        onError(nil);
    } onException:^(NSException *exception) {
        onException(nil);
    }];
}

+ (void) postCountDataDetailBBBG:(NSDictionary *)parameter handle:(ApiResponseHandler)handle onError:(HandleResponseError)onError onException:(HandleResponseException)onException {
    [THService requestPOSTFromUrl: [[GlobalObj getInstance] getApiFullUrl: KTTS_COUNT_DETAIL_BBBG] parameter:parameter withProgress:nil completion:^(NSDictionary *response) {
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
