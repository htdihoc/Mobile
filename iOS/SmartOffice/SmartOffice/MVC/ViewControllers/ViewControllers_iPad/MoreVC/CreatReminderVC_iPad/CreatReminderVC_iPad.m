//
//  CreatReminderVC_iPad.m
//  SmartOffice
//
//  Created by NguyenDucBien on 5/25/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import "CreatReminderVC_iPad.h"

@interface CreatReminderVC_iPad () <KPDropMenuDelegate, TTNS_BaseNavViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *reminderScrollView;

@end

@implementation CreatReminderVC_iPad

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mTitle.text = @"Tạo mới nhắc nhở";
    
    // LocalizedString
    self.lb_reminder_name.text = LocalizedString(@"KMORE_REMINDER_NAME");
    self.lb_time_remind.text = LocalizedString(@"KMORE_REMINDER_TIME");
    self.lb_number_remind.text = LocalizedString(@"KMORE_NUMBER_REPEAT");
    self.lb_level.text = LocalizedString(@"KMORE_SELECT_LEVEL");
    self.lb_note.text = LocalizedString(@"KMORE_NOTE");
    [self.btnCreatRemind setTitle:LocalizedString(@"KMORE_COMPLETE") forState:UIControlStateNormal];
    
    
    // Setup UI
    self.tv_note.layer.borderWidth = 0.5;
    self.tv_note.layer.cornerRadius = 3;
    self.tv_note.layer.borderColor = [[UIColor darkGrayColor] CGColor];
    self.reminder_name.layer.borderWidth = 0.5;
    self.reminder_name.layer.cornerRadius = 3;
    self.reminder_name.layer.borderColor = [[UIColor darkGrayColor] CGColor];
    self.time_remind.layer.borderWidth = 0.5;
    self.time_remind.layer.cornerRadius = 3;
    self.time_remind.layer.borderColor = [[UIColor darkGrayColor] CGColor];
    self.number_repeat.layer.borderWidth = 0.5;
    self.number_repeat.layer.cornerRadius = 3;
    self.number_repeat.layer.borderColor = [[UIColor darkGrayColor] CGColor];
    self.level.layer.borderWidth = 0.5;
    self.level.layer.cornerRadius = 3;
    self.level.layer.borderColor = [[UIColor darkGrayColor] CGColor];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.reminderScrollView addGestureRecognizer:tap];
    tap.cancelsTouchesInView = NO;
    
    self.time_remind.items = @[@"Apple", @"Grapes", @"Cherry", @"Pineapple", @"Mango", @"Orange"];
    self.time_remind.itemTextAlignment = NSTextAlignmentCenter;
    
    self.number_repeat.items = @[@"Thứ 2", @"Thứ 3", @"Thứ 4", @"Thứ 5", @"Thứ 6", @"Thứ 7"];
    self.number_repeat.itemTextAlignment = NSTextAlignmentCenter;
    
    self.level.items = @[@"1", @"2", @"3", @"4", @"5", @"6"];
    self.level.itemTextAlignment = NSTextAlignmentCenter;
    self.level.DirectionDown = NO;
}



-(void)didSelectItem : (KPDropMenu *) dropMenu atIndex : (int) atIntedex{
    if (dropMenu == self.number_repeat)
        NSLog(@"%@ with TAG : %ld", dropMenu.items[atIntedex], (long)dropMenu.tag);
    else
        NSLog(@"%@", dropMenu.items[atIntedex]);
}

-(void)didShow:(KPDropMenu *)dropMenu{
    NSLog(@"didShow");
}

-(void)didHide:(KPDropMenu *)dropMenu{
    NSLog(@"didHide");
}

- (void) setUserInterfaceObject: (UIView *)object {
    object.layer.borderWidth = 0.5;
    object.layer.borderColor = RGB(204, 204, 204).CGColor;
    object.layer.cornerRadius = 4;
}

-(void)dismissKeyboard {
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)didTapBackButton {
    [self popToMoreRoot];
    [self popToIntegrationRoot];
}

- (IBAction)creatReminderAction:(id)sender {
}
@end
