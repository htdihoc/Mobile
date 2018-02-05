//
//  QLTTProcessor.h
//  SmartOffice
//
//  Created by NguyenVanTu on 5/9/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "THService.h"
@interface QLTTProcessor : NSObject

//Get list documents to show with param
//{
//"documentCategoryId": 2051,
//"type": 1
//}
+ (void)getQLTTDocCategoryWithComplete:(NSDictionary *)params withComplete:(Callback)callBack;

//Get path preview file
//{
//    "filePath": "document/20161203/520070/E40bMroV74HHGHuRnej3yfdMPhU=.pdf"
//}
+ (void)getQLTTPreviewFilePath:(NSDictionary *)params withComplete:(Callback)callBack;

//Get doc info with optional info {
//"name": "Ten tai lieu",
//"code": "ma tai lieu",
//"description": "mo ta",
//"authorName": "ten tac gia",
//"type": "0"
//}
+ (void)getQLTTDocInfoWithComplete:(NSDictionary *)params withComplete:(Callback)callBack;

+ (void)postQLTTLikeDocument:(NSDictionary *)params withComplete:(Callback)callBack;

+ (void)postQLTTCheckLikeDocument:(NSDictionary *)params withComplete:(Callback)callBack;

+ (void)getQLTTListComment:(NSNumber *)documentId withComplete:(Callback)callBack;

+ (void)sendComment:(NSDictionary *)params withComplete:(Callback)callBack;
@end
