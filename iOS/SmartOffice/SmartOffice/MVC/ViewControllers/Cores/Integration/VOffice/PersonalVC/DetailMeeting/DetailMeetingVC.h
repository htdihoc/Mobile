//
//  DetailMeetingVC.h
//  SmartOffice
//
//  Created by NguyenVanTu on 4/20/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "VOfficeBaseWithBottomView.h"
#import "FullWidthSeperatorTableView.h"

@class MeetingModel;
@interface DetailMeetingVC : VOfficeBaseWithBottomView<UITableViewDataSource, UITableViewDelegate>{
    
}

@property (weak, nonatomic) IBOutlet FullWidthSeperatorTableView *tblContent;
@property (strong, nonatomic) MeetingModel *meetingModel;


- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil model:(MeetingModel *)model;

@end
