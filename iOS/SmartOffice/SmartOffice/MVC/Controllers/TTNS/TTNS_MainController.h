//
//  TTNS_MainController.h
//  SmartOffice
//
//  Created by Administrator on 5/15/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Common.h"
#import "TTNSProcessor.h"
#import "TTNSSessionModel.h"
#import "SOSessionManager.h"

@interface TTNS_MainController : NSObject

- (void)getAccessToken:(void (^)(BOOL isError))completion;

// lấy danh sách đăng ký của nhân viên
- (void)getListRegisterLeave:(void (^) (NSMutableArray *_listRegisterForm))completion;

@end
