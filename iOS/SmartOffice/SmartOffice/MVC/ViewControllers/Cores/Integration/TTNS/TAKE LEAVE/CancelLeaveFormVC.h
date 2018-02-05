//no
//  CancelLeaveFormVC.h
//  SmartOffice
//
//  Created by Hien Tuong on 4/13/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "TTNS_BaseVC.h"

@interface CancelLeaveFormVC : TTNS_BaseVC

@property (weak, nonatomic) IBOutlet UILabel *titleLB;

@property (weak, nonatomic) IBOutlet UIButton *backButton;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (assign, nonatomic) NSInteger personalFormId;

@property (assign, nonatomic) NSInteger typeOfForm;

- (IBAction)backAction:(id)sender;

- (IBAction)cancelAction:(id)sender;
@end
