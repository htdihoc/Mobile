//
//  QLTT_InfoDetailController.h
//  SmartOffice
//
//  Created by NguyenVanTu on 5/16/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QLTTFileAttachmentModel.h"
typedef void (^CallbackQLTT_InfoDetailController)(BOOL success, NSData *resultData, NSException *exception, NSDictionary *error);
typedef void (^CallbackQLTT_InfoDetailAttachmentFile)(BOOL success, NSException *exception, NSDictionary *error);
@interface QLTT_InfoDetailController : NSObject
+ (void)loadData:(NSString *)urlDownloadFile completion:(CallbackQLTT_InfoDetailController)completion;
//
//- (void)get_AttachmentFiles:(NSDictionary *)params completion:(CallbackQLTT_InfoDetailAttachmentFile)completion;
//
//- (NSArray<QLTTFileAttachmentModel *> *)getListAttachment;
//- (NSArray<QLTTFileAttachmentModel *> *)getListAvatar;
@end
