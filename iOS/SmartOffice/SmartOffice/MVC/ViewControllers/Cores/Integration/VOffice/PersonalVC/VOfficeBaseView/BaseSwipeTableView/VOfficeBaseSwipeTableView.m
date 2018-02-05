//
//  BaseSwipeTableView.m
//  SmartOffice
//
//  Created by NguyenVanTu on 4/20/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "VOfficeBaseSwipeTableView.h"
#import "SOTableViewRowAction.h"
@interface VOfficeBaseSwipeTableView () <UITableViewDelegate>

@end

@implementation VOfficeBaseSwipeTableView

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
        return YES;
}
//Swipe Cell
- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {

//    _lastIndex = indexPath;


    SOTableViewRowAction *chatAction = [SOTableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal
                                                                          title:@"Chat"
                                                                           icon:[UIImage imageNamed:@"swipe_cell_chat_icon"]
                                                                          color:RGB(59, 111, 169)
                                                                        handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
                                                                            //Action here
																			[self showChatViewAt:indexPath];

																			
                                                                        }];
    
    SOTableViewRowAction *reminderAction = [SOTableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal
                                                                              title:@"Reminder"
                                                                               icon:[UIImage imageNamed:@"swipe_cell_reminder_icon"]
                                                                              color:RGB(255, 150, 0)
                                                                            handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
                                                                                //Action here
                                                                                [self showReminderAt:indexPath];
                                                                            }];
    
    return @[chatAction, reminderAction];
}
-(void)showChatViewAt:(NSIndexPath *)index
{
	
}
-(void)showReminderAt:(NSIndexPath *)index
{
    
}
@end
