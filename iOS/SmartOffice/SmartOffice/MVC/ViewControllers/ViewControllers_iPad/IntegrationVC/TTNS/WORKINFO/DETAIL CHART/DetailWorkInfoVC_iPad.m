//
//  DetailWorkInfoVC_iPad.m
//  SmartOffice
//
//  Created by Administrator on 5/9/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "DetailWorkInfoVC_iPad.h"
#import "WorkListVC_iPad.h"
#import "CalendarVC_iPad.h"


@interface DetailWorkInfoVC_iPad ()

@end

@implementation DetailWorkInfoVC_iPad

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI{
    self.TTNS_title     = @"";
    self.TTNS_buttonTitles = @[[[NavButton_iPad alloc]initWithTitleAndIconName:@"      " iconName:@"nav_home"], @"TTNS", LocalizedString(@"TTNS_UMTimeKeepingDetail_Chi_tiết_công")];
    self.jumpVC = -1;
}

- (void)viewDidLayoutSubviews{
    
    [super viewDidLayoutSubviews];
    
    if(self.view.frame.size.width != 300){
        WorkListVC_iPad *workListVC = NEW_VC_FROM_NIB(WorkListVC_iPad, @"WorkListVC_iPad");
        [self displayVC:workListVC container:self.containerView1];
        [workListVC.bottomView setHidden:YES];
        workListVC.isShowCalendar = NO;
        workListVC.ContentView.layer.borderWidth = 0;
        workListVC.view.backgroundColor = [UIColor whiteColor];
        
        CalendarVC_iPad *calendarVC = NEW_VC_FROM_NIB(CalendarVC_iPad, @"CalendarVC_iPad");
        [self displayVC:calendarVC container:self.containerView2];
        [calendarVC.bottomView setHidden:YES];
    }
}



@end
