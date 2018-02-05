//
//  QLTT_MasterController.h
//  SmartOffice
//
//  Created by NguyenVanTu on 5/16/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^CallbackQLTT_MasterController)(BOOL success, NSArray *resultArray, NSException *exception, NSDictionary *error);
@interface QLTT_MasterController : NSObject
- (void)loadData:(NSDictionary *)params delayedBatching:(BOOL)delayedBatching completion:(CallbackQLTT_MasterController)completion;


@end
