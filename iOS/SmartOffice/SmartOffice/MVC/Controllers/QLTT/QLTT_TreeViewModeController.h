//
//  QLTT_TreeViewModeController.h
//  SmartOffice
//
//  Created by NguyenVanTu on 5/16/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^CallbackQLTT_TreeViewModeController)(BOOL success, NSArray *resultArray, NSException *exception, NSDictionary *error);
@interface QLTT_TreeViewModeController : NSObject
- (void)loadData:(NSDictionary *)params completion:(CallbackQLTT_TreeViewModeController)completion;
@end
