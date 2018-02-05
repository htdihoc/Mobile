//
//  BaseSwipeTableView.h
//  SmartOffice
//
//  Created by NguyenVanTu on 4/20/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VOfficeBaseView.h"
@interface VOfficeBaseSwipeTableView : VOfficeBaseView
-(void)showChatViewAt:(NSIndexPath *)index;
-(void)showReminderAt:(NSIndexPath *)index;
@end
