//
//  CreateRemiderViewController.m
//  SmartOffice
//
//  Created by Vu Van Tiep on 4/17/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "CreateRemiderViewController.h"

@interface CreateRemiderViewController () <KPDropMenuDelegate, TTNS_BaseNavViewDelegate, UITextFieldDelegate> {
}

@end

@implementation CreateRemiderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.backTitle = LocalizedString(@"KMORE_SURVEY_CREATE_REMINDER");
    // LocalizedString
    
    self.lb_reminder_name.text = LocalizedString(@"KMORE_REMINDER_NAME");
    self.lb_time_remind.text = LocalizedString(@"KMORE_REMINDER_TIME");
    self.lb_number_remind.text = LocalizedString(@"KMORE_NUMBER_REPEAT");
    self.lb_level.text = LocalizedString(@"KMORE_SELECT_LEVEL");
    self.lb_note.text = LocalizedString(@"KMORE_NOTE");
    [self.btnCreate setTitle:LocalizedString(@"KMORE_COMPLETE") forState:UIControlStateNormal];
    
    // set ui
    [self setUserInterfaceObject:self.tv_note];
    [self setUserInterfaceObject:self.reminder_name];
    [self setUserInterfaceObject:self.time_remind];
    [self setUserInterfaceObject:self.number_repeat];
    [self setUserInterfaceObject:self.level];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    tap.cancelsTouchesInView = NO;
    
    self.time_remind.items = @[@"Apple", @"Grapes", @"Cherry", @"Pineapple", @"Mango", @"Orange"];
    self.time_remind.itemTextAlignment = NSTextAlignmentCenter;
    
    self.number_repeat.items = @[@"Không lặp", @"Một lần", @"Hai lần", @"Ba lần", @"Bốn lần", @"Năm lần", @"Sáu lần"];
    self.number_repeat.itemTextAlignment = NSTextAlignmentCenter;
    
    self.level.items = @[@"Bình thường", @"Khẩn", @"Nguy hiểm"];
    self.level.itemTextAlignment = NSTextAlignmentCenter;
    self.level.DirectionDown = NO;

}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    CGRect textFieldRect = [self.view.window convertRect:textField.bounds fromView:textField];
    CGRect viewRect = [self.view.window convertRect:self.view.bounds fromView:self.view];
    
    CGFloat midline = textFieldRect.origin.y + 0.5 * textFieldRect.size.height;
    CGFloat numerator =
    midline - viewRect.origin.y - MINIMUM_SCROLL_FRACTION * viewRect.size.height;
    CGFloat denominator =
    (MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION) * viewRect.size.height;
    CGFloat heightFraction = numerator / denominator;
    
    if (heightFraction < 0.0)
    {
        heightFraction = 0.0;
    }
    else if (heightFraction > 1.0)
    {
        heightFraction = 1.0;
    }

    self.animatedDistance = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction) - 45;

    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y -= self.animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    [UIView commitAnimations];
}
    
- (void)textFieldDidEndEditing:(UITextField *)textField {
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += self.animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    [UIView commitAnimations];
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

- (void)dismissKeyboard {
    [self.nameReminderTextField resignFirstResponder];
    [self.lb_note resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (IBAction)btnCreateAction:(id)sender {
}

- (void)didTapBackButton {
    [self popToMoreRoot];
    [self popToIntegrationRoot];
}

@end
