//
//  PersonalInfoVC.h
//  SmartOffice
//
//  Created by Hien Tuong on 4/17/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "TTNS_BaseVC.h"
#import "TTNS_EmployeeTimeKeeping.h"
@interface MoreInfoVC : TTNS_BaseVC

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) TTNS_EmployeeTimeKeeping *employeeDetail;
@end
