//
//  Voffice_MeettingScheduleDetail_iPad.h
//  VOFFICE_ListOfMeetingSchedules
//
//  Created by NguyenDucBien on 4/28/17.
//  Copyright © 2017 NguyenDucBien. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VOffice_MeetingDetailCell_iPad.h"
#import "VOffice_PersonJoinCell_iPad.h"
#import "VOffice_BaseTableViewVC_iPad.h"
#import "SOInsectTextLabel.h"
#import "FullWidthSeperatorTableView.h"
@interface VOffice_MeettingDetail_iPad : VOffice_BaseTableViewVC_iPad <UITableViewDelegate, UITableViewDataSource>
@property(weak, nonatomic) id<VOfficeProtocol> delegate;
-(void)reloadData;
@end
