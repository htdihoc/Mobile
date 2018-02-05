//
//  QLTT_InfoDetailController.m
//  SmartOffice
//
//  Created by NguyenVanTu on 5/16/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import "QLTT_InfoDetailController.h"
#import "Common.h"
#import "QLTTProcessor.h"
#import "NSException+Custom.h"

@interface QLTT_InfoDetailController()
{
    NSDictionary *_resultDict;
}
@end
@implementation QLTT_InfoDetailController
- (NSArray<QLTTFileAttachmentModel *> *)getListAttachment
{
    return [QLTTFileAttachmentModel arrayOfModelsFromDictionaries:[_resultDict valueForKey:@"fileAttachment"] error:nil];
}
- (NSArray<QLTTFileAttachmentModel *> *)getListAvatar
{
    return [QLTTFileAttachmentModel arrayOfModelsFromDictionaries:[_resultDict valueForKey:@"avatar"] error:nil];
}
+ (void)loadData:(NSString *)urlDownloadFile completion:(CallbackQLTT_InfoDetailController)completion
{
    //Check Network here
    if ([Common checkNetworkAvaiable]) {
        if (urlDownloadFile == nil) {
            return;
        }
        NSDictionary *params = @{@"filePath" : urlDownloadFile};
        [QLTTProcessor getQLTTPreviewFilePath:params withComplete:^(BOOL success, NSDictionary *resultDict, NSException *exception) {
            if (success) {
                NSString *base64String = resultDict[@"data"];
                completion(success, [[NSData alloc] initWithBase64EncodedString:base64String options:NSDataBase64DecodingIgnoreUnknownCharacters], exception, resultDict);
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

- (void)get_AttachmentFiles:(NSDictionary *)params completion:(CallbackQLTT_InfoDetailAttachmentFile)completion
{
    if ([Common checkNetworkAvaiable]) {
        [QLTTProcessor getQLTTDocInfoWithComplete:params withComplete:^(BOOL success, NSDictionary *resultDict, NSException *exception) {
            if (success) {
                NSDictionary *dictModels = [[resultDict valueForKey:@"data"] valueForKey:@"result"];
                _resultDict = dictModels;
                completion(success, exception, resultDict);
            }
            else
            {
                completion(success, exception, resultDict);
            }
        }];
    }else{
        completion(NO, [NSException initWithNoNetWork], NULL);
    }
}


@end
