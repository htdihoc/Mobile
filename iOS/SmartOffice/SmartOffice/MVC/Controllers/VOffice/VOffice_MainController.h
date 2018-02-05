//
//  VOffice_MainVC.h
//  SmartOffice
//
//  Created by NguyenVanTu on 5/15/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Common.h"
#import "VOfficeProcessor.h"
#import "VOfficeSessionModel.h"
#import "SOSessionManager.h"

@protocol DataNUllDelegate <NSObject>

- (void)dataNULL;

@end

@interface VOffice_MainController : NSObject
typedef void (^CallbackVOffice_Main)(BOOL network, BOOL success, NSException *exception, NSDictionary *error);
- (void)loadData:(CallbackVOffice_Main)completion;
@property (weak, nonatomic) id<DataNUllDelegate> delegate;

@end
