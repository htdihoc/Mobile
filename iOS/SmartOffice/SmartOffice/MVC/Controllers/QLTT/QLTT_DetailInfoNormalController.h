//
//  QLTT_DetailInfoNormalController.h
//  SmartOffice
//
//  Created by NguyenVanTu on 5/18/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QLTTMasterDocumentModel.h"
typedef void (^CallBackQLTT_DetailInfoNormalController)(BOOL success, NSNumber *resultCode, NSException *exception, NSDictionary *error);
typedef void (^CallBackQLTT_DetailInfoNormalControllerCheckLike)(BOOL success, NSNumber *resultCode, NSException *exception, BOOL isLike, NSDictionary *error);
typedef void (^CallBackQLTT_DetailInfoNormalModelDetailController)(BOOL success, QLTTMasterDocumentModel *model, NSException *exception, NSDictionary *error);
@interface QLTT_DetailInfoNormalController : NSObject
- (void)likeDocument:(NSNumber *)documentID employeeID:(NSNumber *)employeeID completion:(CallBackQLTT_DetailInfoNormalController)completion;

- (void)checkLikeDocument:(NSNumber *)documentID employeeID:(NSNumber *)employeeID completion:(CallBackQLTT_DetailInfoNormalControllerCheckLike)completion;

- (void)getDocsWith:(NSNumber *)CategoryID;

- (void)getMasterDocDetail:(NSNumber *)documentID completion:(CallBackQLTT_DetailInfoNormalModelDetailController)completion;
@end
