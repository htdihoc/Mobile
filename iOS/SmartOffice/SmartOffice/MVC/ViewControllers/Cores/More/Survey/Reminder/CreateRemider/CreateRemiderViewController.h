//
//  CreateRemiderViewController.h
//  SmartOffice
//
//  Created by Vu Van Tiep on 4/17/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTNS_BaseVC.h"
#import "KPDropMenu.h"

#define KEYBOARD_ANIMATION_DURATION     0.3f
#define MINIMUM_SCROLL_FRACTION         0.2f
#define MAXIMUM_SCROLL_FRACTION         0.8f
#define PORTRAIT_KEYBOARD_HEIGHT        216

@interface CreateRemiderViewController : TTNS_BaseVC
    
@property (nonatomic, assign) float animatedDistance;
    
@property (weak, nonatomic) IBOutlet UIButton *btnCreate;
    
@property (weak, nonatomic) IBOutlet UILabel *lb_reminder_name;
@property (weak, nonatomic) IBOutlet UILabel *lb_time_remind;
@property (weak, nonatomic) IBOutlet UILabel *lb_number_remind;
@property (weak, nonatomic) IBOutlet UILabel *lb_level;
@property (weak, nonatomic) IBOutlet UILabel *lb_note;
@property (weak, nonatomic) IBOutlet UITextField *nameReminderTextField;
    
@property (weak, nonatomic) IBOutlet KPDropMenu *reminder_name;
@property (weak, nonatomic) IBOutlet KPDropMenu *time_remind;
@property (weak, nonatomic) IBOutlet KPDropMenu *number_repeat;
@property (weak, nonatomic) IBOutlet KPDropMenu *level;
@property (weak, nonatomic) IBOutlet UITextView *tv_note;

@end
