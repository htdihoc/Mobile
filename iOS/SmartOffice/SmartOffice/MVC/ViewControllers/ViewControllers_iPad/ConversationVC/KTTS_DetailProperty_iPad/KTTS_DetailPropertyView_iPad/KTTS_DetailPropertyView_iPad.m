//
//  KTTS_DetailPropertyView_iPad.m
//  SmartOffice
//
//  Created by KhacViet Dinh on 5/10/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import "KTTS_DetailPropertyView_iPad.h"
#import "KTTS_ConfirmProperty_iPad.h"
#import "WYPopoverController.h"

@interface KTTS_DetailPropertyView_iPad () <WYPopoverControllerDelegate> {
@protected WYPopoverController *popOverController;
}

@end

@implementation KTTS_DetailPropertyView_iPad

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.lbl_title.text = @"Chi tiết tài sản";
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    if (CGRectIsEmpty(frame)) {
        self.bounds = self.view.bounds;
    }
    return self;
}

- (void)setup {
    self.view = [[[NSBundle mainBundle] loadNibNamed:@"KTTS_DetailPropertyView_iPad" owner:self options:nil] firstObject];
    self.view.frame = self.bounds;
    [self addSubview:self.view];
}

- (IBAction)action_Confirm:(id)sender {
    
    [self.delegate buttonShowConfirmVC:sender];
}

/*
 
 khi su dung thu vien WYPopup
 
 - (void) showConfirmView:(CGPoint)position {
 
 if (popOverController == nil) {
 KTTS_ConfirmProperty_iPad *confirmVC = NEW_VC_FROM_NIB(KTTS_ConfirmProperty_iPad, @"KTTS_ConfirmProperty_iPad");
 
 confirmVC.title = @"Xác nhận tài sản";
 UINavigationController *contenVC = [[UINavigationController alloc] initWithRootViewController:confirmVC];
 popOverController = [[WYPopoverController alloc] initWithContentViewController:contenVC];
 popOverController.delegate = self;
 popOverController.passthroughViews = @[self];
 popOverController.popoverLayoutMargins = UIEdgeInsetsMake(150, 500, 150, 400);
 popOverController.wantsDefaultContentAppearance = NO;
 
 [popOverController presentPopoverAsDialogAnimated:YES options:WYPopoverAnimationOptionFadeWithScale];
 } else {
 [self close:nil];
 
 }
 }
 
 
 - (void)close:(id)sender {
 [popOverController dismissPopoverAnimated:YES completion:^{
 [self popoverControllerDidDismissPopover:popOverController];
 }];
 }
 
 
 #pragma Mark Delegate
 
 - (void)popoverControllerDidPresentPopover:(WYPopoverController *)controller
 {
 NSLog(@"popoverControllerDidPresentPopover");
 }
 
 - (BOOL)popoverControllerShouldDismissPopover:(WYPopoverController *)controller
 {
 return YES;
 }
 
 - (void)popoverControllerDidDismissPopover:(WYPopoverController *)controller
 {
 if (controller == popOverController)
 {
 popOverController.delegate = nil;
 popOverController = nil;
 // Do something
 }
 }
 
 - (BOOL)popoverControllerShouldIgnoreKeyboardBounds:(WYPopoverController *)popoverController
 {
 return YES;
 }
 
 - (void)popoverController:(WYPopoverController *)popoverController willTranslatePopoverWithYOffset:(float *)value
 {
 // keyboard is shown and the popover will be moved up by 163 pixels for example ( *value = 163 )
 *value = 0; // set value to 0 if you want to avoid the popover to be moved
 }
 */

@end
