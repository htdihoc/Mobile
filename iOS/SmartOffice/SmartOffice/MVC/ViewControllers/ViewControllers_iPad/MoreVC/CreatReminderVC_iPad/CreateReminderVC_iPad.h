//
//  CreateReminderVC_iPad.h
//  SmartOffice
//
//  Created by NguyenDucBien on 5/25/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import "TTNS_BaseSubView_iPad.h"
#import "KPDropMenu.h"
@protocol CreateReminderVC_iPadDelegate
- (void)dismissVC;
@end
@interface CreateReminderVC_iPad : TTNS_BaseSubView_iPad

@property (weak, nonatomic) IBOutlet UILabel *lb_reminder_name;
@property (weak, nonatomic) IBOutlet UILabel *lb_time_remind;
@property (weak, nonatomic) IBOutlet UILabel *lb_number_remind;
@property (weak, nonatomic) IBOutlet UILabel *lb_level;
@property (weak, nonatomic) IBOutlet UILabel *lb_note;

@property (weak, nonatomic) IBOutlet KPDropMenu *reminder_name;
@property (weak, nonatomic) IBOutlet KPDropMenu *time_remind;
@property (weak, nonatomic) IBOutlet KPDropMenu *number_repeat;
@property (weak, nonatomic) IBOutlet KPDropMenu *level;
@property (weak, nonatomic) IBOutlet UITextView *tv_note;

@property (weak, nonatomic) IBOutlet UIButton *btnCreatRemind;

@property (weak, nonatomic) id<CreateReminderVC_iPadDelegate> delegate;
- (IBAction)createReminderAction:(id)sender;


@end
