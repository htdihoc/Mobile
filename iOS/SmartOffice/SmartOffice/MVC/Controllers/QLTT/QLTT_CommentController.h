//
//  QLTT_CommentController.h
//  SmartOffice
//
//  Created by NguyenVanTu on 5/24/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^CallbackQLTT_CommentController)(BOOL success, NSArray *resultArray, NSException *exception, NSDictionary *error);
@interface QLTT_CommentController : NSObject
- (void)loadComment:(NSNumber *)documentId completion:(CallbackQLTT_CommentController)completion;

- (void)sendComment:(NSNumber *)documentId content:(NSString *)content createdUser:(NSString *)createdUser completion:(CallbackQLTT_CommentController)completion;
@end
