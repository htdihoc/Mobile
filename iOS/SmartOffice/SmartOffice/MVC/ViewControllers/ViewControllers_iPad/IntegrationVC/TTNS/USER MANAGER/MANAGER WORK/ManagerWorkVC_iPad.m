//
//  ManagerWorkVC_iPad.m
//  SmartOffice
//
//  Created by Administrator on 5/8/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "ManagerWorkVC_iPad.h"
#import "ListManagerWorkVC_iPad.h"
#import "CalendarVC_iPad.h"
#import "WorkNoDataView.h"

@interface ManagerWorkVC_iPad ()

@end

@implementation ManagerWorkVC_iPad

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI{
    [self isTTNSVC:NO];
//    self.VOffice_buttonTitles = @[@"TTNS", @"Phê duyệt công"];
    self.TTNS_title = @"";
        self.TTNS_buttonTitles = @[[[NavButton_iPad alloc] initWithTitleAndIconName:@"      " iconName:@"nav_home"], @"TTNS", LocalizedString(@"TTNS_TimeKeepings_Phê_duyệt_công")];
    self.jumpVC = -1;
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    if(self.view.frame.size.width != 300)
    {
        ListManagerWorkVC_iPad *listManagerWorkVC = NEW_VC_FROM_NIB(ListManagerWorkVC_iPad, @"ListManagerWorkVC_iPad");
        [self displayVC:listManagerWorkVC container:self.containerView1];
        
        CalendarVC_iPad *calendarWorkVC = NEW_VC_FROM_NIB(CalendarVC_iPad, @"CalendarVC_iPad");
        [self displayVC:calendarWorkVC container:self.containterView2];
    }
    
    
}

@end
