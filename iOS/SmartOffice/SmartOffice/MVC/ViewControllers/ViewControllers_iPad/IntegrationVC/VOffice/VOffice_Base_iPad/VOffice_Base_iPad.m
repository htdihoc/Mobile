//
//  VOffice_Base_iPad.m
//  SmartOffice
//
//  Created by NguyenVanTu on 4/27/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "VOffice_Base_iPad.h"
#import "ListNotificationVC.h"
#import "WYPopoverController.h"
#import "NSString+Util.h"
@interface VOffice_Base_iPad ()<VOffice_NavBase_iPadDelegate, WYPopoverControllerDelegate>{
    @protected WYPopoverController *popOverController;
    BOOL _isTTNSVC;
}

@end

@implementation VOffice_Base_iPad

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    if(_nav_iPad == nil)
    {
        [self addNav];
        [_nav_iPad layoutIfNeeded];
        [_nav_iPad addButtons:self.VOffice_buttonTitles margin:4 fontSize:14 disableBackIcon:self.disableBackIcon];
    }
}
- (void)isTTNSVC:(BOOL)isTTNSVC
{
    _isTTNSVC = isTTNSVC;
}
- (void)addNav
{
    _nav_iPad = [[VOffice_NavBase_iPad alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    _nav_iPad.lbl_Title.text = self.VOffice_title;
    if (![self.VOffice_subTitle checkValidString]) {
        _nav_iPad.cst_CenterSubTitle.constant = -10;
    }
    _nav_iPad.lbl_subTitle.text = self.VOffice_subTitle;
    _nav_iPad.delegate = self;
    [self.view addSubview:_nav_iPad];
    [_nav_iPad setIsTTNSVC:_isTTNSVC];
    _nav_iPad.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint *top= [NSLayoutConstraint
                              constraintWithItem:_nav_iPad
                              attribute:NSLayoutAttributeTop
                              relatedBy:NSLayoutRelationEqual
                              toItem:self.view
                              attribute:NSLayoutAttributeTop
                              multiplier:1.0
                              constant:0];
    NSLayoutConstraint *right = [NSLayoutConstraint
                                 constraintWithItem:_nav_iPad
                                 attribute:NSLayoutAttributeRight
                                 relatedBy:NSLayoutRelationEqual toItem:self.view
                                 attribute:NSLayoutAttributeRight multiplier:1.0f
                                 constant:0];
    
    NSLayoutConstraint *left = [NSLayoutConstraint
                                constraintWithItem:_nav_iPad
                                attribute:NSLayoutAttributeLeft
                                relatedBy:NSLayoutRelationEqual
                                toItem:self.view attribute:
                                NSLayoutAttributeLeft multiplier:1.0
                                constant:0];
    NSLayoutConstraint *height = [NSLayoutConstraint
                                  constraintWithItem:_nav_iPad
                                  attribute:NSLayoutAttributeHeight
                                  relatedBy:NSLayoutRelationEqual
                                  toItem:nil attribute:
                                  NSLayoutAttributeNotAnAttribute multiplier:1.0
                                  constant:64];
    /* 4. Add the constraints to button's superview*/
    [self.view addConstraints:@[top, left, right, height]];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)setHiddenForFilterCopanyButton:(BOOL)isHidden
{
    [_nav_iPad setHiddenForBtn_Filter:isHidden];
}
//- (void)setVOffice_buttonTitles:(NSArray *)VOffice_buttonTitles
//{
//    [_nav_iPad addButtons:self.VOffice_buttonTitles margin:4 fontSize:14];
//}
- (void)setVOffice_title:(NSString *)VOffice_title
{
    _nav_iPad.lbl_Title.text = VOffice_title;
    _VOffice_title = VOffice_title;
}
- (void)setVOffice_subTitle:(NSString *)VOffice_subTitle
{
    _nav_iPad.lbl_subTitle.text = VOffice_subTitle;
    _nav_iPad.cst_CenterSubTitle.constant = 0;
    _VOffice_subTitle = VOffice_subTitle;
}
#pragma mark VOffice_NavBase_iPadDelegate
- (void)didSelectButton:(NSInteger)index
{
    if (index == -1) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else if(index >= self.navigationController.viewControllers.count)
    {
        NSArray *array = [self.navigationController viewControllers];
        [self.navigationController popToViewController:[array objectAtIndex:self.navigationController.viewControllers.count-1] animated:YES];
    }
    else
    {
        NSArray *array = [self.navigationController viewControllers];
        [self.navigationController popToViewController:[array objectAtIndex:(index + _jumpVC) == -1 ? 0 : (index + _jumpVC)] animated:YES];
    }
    
}

- (void)didSelectFilterButton:(UIButton *)sender
{
    
}
- (void)didTapRightButton:(UIButton *)sender
{
    
}

- (void)didTapNotificationButton:(UIButton *)sender{
    [self showListNotification];
}

- (void)showListNotification{
    if(popOverController == nil){
        if (popOverController.popoverVisible) {
            [popOverController dismissPopoverAnimated:YES];
            return;
        }
        ListNotificationVC *vc = NEW_VC_FROM_NIB(ListNotificationVC, @"ListNotificationVC");
        vc.title = @"";
        UINavigationController *contentVC = [[UINavigationController alloc] initWithRootViewController:vc];
        contentVC.view.backgroundColor = [UIColor whiteColor];
        
        popOverController = [[WYPopoverController alloc]initWithContentViewController:contentVC];
        popOverController.delegate = self;
        popOverController.passthroughViews = @[self];
        popOverController.popoverLayoutMargins = UIEdgeInsetsMake(44, self.view.frame.size.width-260, self.view.frame.size.height-350, 16);
        
        popOverController.wantsDefaultContentAppearance = NO;
        
        [popOverController presentPopoverAsDialogAnimated:YES options:WYPopoverAnimationOptionFadeWithScale];
    } else {
        [self close: nil];
    }
}

- (void)close:(id)sender
{
    [popOverController dismissPopoverAnimated:YES completion:^{
        [self popoverControllerDidDismissPopover:popOverController];
    }];
}

#pragma mark - WYPopoverControllerDelegate

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

@end
