//
//  TimeKeepingPopupVC.m
//  SmartOffice
//
//  Created by Hien Tuong on 4/8/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "TimeKeepingPopupVC.h"

@interface TimeKeepingPopupVC ()

@end

@implementation TimeKeepingPopupVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showAnimate];
    // Do any additional setup after loading the view from its nib.
}

-(void)showAnimate{
    self.view.transform = CGAffineTransformMakeScale(1.3, 1.3);
    self.view.alpha = 0.0;
    [UIView animateWithDuration:0.25 animations:^{
        self.view.alpha = 1.0;
        self.view.transform = CGAffineTransformMakeScale(1.0, 1.0);
    }];
}

-(void)removeAnimate{
    [UIView animateWithDuration:0.25 animations:^{
        self.view.transform = CGAffineTransformMakeScale(1.3, 1.3);
        self.view.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
    }];
}
- (IBAction)dismissAction:(id)sender {
    [self removeAnimate];
}
@end
