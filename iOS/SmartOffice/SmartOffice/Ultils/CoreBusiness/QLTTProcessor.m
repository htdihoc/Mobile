//
//  QLTTProcessor.m
//  SmartOffice
//
//  Created by NguyenVanTu on 5/9/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "QLTTProcessor.h"
#define QLTT_DOCUMENT_CATEGORY_PATH                 @"qltt/getDocumentCategory"
#define QLTT_DOCUMENT_INFO_PATH                     @"qltt/getDocumentInfo"
#define QLTT_DOCUMENT_PreviewFilePath_PATH			@"qltt/downloadFile"
#define QLTT_LIKE_DOCUMENT                          @"qltt/likeDocument"
#define QLTT_LIST_COMMENT                           @"qltt/listComment"
#define QLTT_SEND_COMMENT                           @"qltt/addComment"
@implementation QLTTProcessor
+ (void)makePostRequest:(NSDictionary *)params complete:(Callback)callBack baseURL:(NSString *)baseURL
{
    [THService requestPOSTFromUrl:[[GlobalObj getInstance] getApiFullUrl:baseURL] parameter:params withProgress:nil
                       completion:^(NSDictionary *response) {
                           callBack(YES, response, nil);
                       } onError:^(NSDictionary *error) {
                           callBack(NO, error, nil);
                       } onException:^(NSException *exception) {
                           callBack(NO, nil, exception);
                       }];
}

+ (void)getQLTTDocCategoryWithComplete:(NSDictionary *)params withComplete:(Callback)callBack{
    //Prepare Params
    [self makePostRequest:params complete:callBack baseURL:QLTT_DOCUMENT_CATEGORY_PATH];
    
}

+ (void)getQLTTPreviewFilePath:(NSDictionary *)params withComplete:(Callback)callBack
{
    [self makePostRequest:params complete:callBack baseURL:QLTT_DOCUMENT_PreviewFilePath_PATH];
}

+ (void)getQLTTDocInfoWithComplete:(NSDictionary *)params withComplete:(Callback)callBack{
    [self makePostRequest:params complete:callBack baseURL:QLTT_DOCUMENT_INFO_PATH];
    
}

+ (void)postQLTTLikeDocument:(NSDictionary *)params withComplete:(Callback)callBack
{
    [self makePostRequest:params complete:callBack baseURL:QLTT_LIKE_DOCUMENT];
}

+ (void)postQLTTCheckLikeDocument:(NSDictionary *)params withComplete:(Callback)callBack
{
    [self makePostRequest:params complete:callBack baseURL:QLTT_LIKE_DOCUMENT];
}

+ (void)getQLTTListComment:(NSNumber *)documentId withComplete:(Callback)callBack
{
    [THService requestGETFromUrl:[[GlobalObj getInstance] getApiFullUrl:[NSString stringWithFormat:@"%@/%@", QLTT_LIST_COMMENT, [documentId stringValue]]] withProgress:nil
                      completion:^(NSDictionary *response) {
                          callBack(YES, response, nil);
                      } onError:^(NSDictionary *error) {
                          callBack(NO, error, nil);
                      } onException:^(NSException *exception) {
                          callBack(NO, nil, exception);
                      }];
    
}

+ (void)sendComment:(NSDictionary *)params withComplete:(Callback)callBack
{
    [self makePostRequest:params complete:callBack baseURL:QLTT_SEND_COMMENT];
}
@end
