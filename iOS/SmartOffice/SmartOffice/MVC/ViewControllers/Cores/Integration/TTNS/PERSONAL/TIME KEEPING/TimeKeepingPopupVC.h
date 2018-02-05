//
//  TimeKeepingPopupVC.h
//  SmartOffice
//
//  Created by Hien Tuong on 4/8/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTNS_BaseVC.h"
@interface TimeKeepingPopupVC : TTNS_BaseVC

@property (weak, nonatomic) IBOutlet UIView *popupView;
- (IBAction)dismissAction:(id)sender;

@end
