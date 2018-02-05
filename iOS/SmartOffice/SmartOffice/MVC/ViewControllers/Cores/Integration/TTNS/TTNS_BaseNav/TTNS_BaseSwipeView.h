//
//  TTNS_BaseSwipeView.h
//  SmartOffice
//
//  Created by NguyenVanTu on 4/21/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SOTableViewRowAction.h"
#import "BaseListView.h"
#import "DismissTimeKeeping.h"

typedef void (^CallbackLeftActopm)();
typedef void (^CallbackRightActopm)();
@interface TTNS_BaseSwipeView : BaseListView

@property DismissTimeKeeping *content;

-(void)reject:(NSIndexPath *)index;
-(void)accpet:(NSIndexPath *)index;

- (void)showDismissTimeKeeping:(void (^)(void))rightAction andLeftAction:(void (^)(void))leftAction;
@end
