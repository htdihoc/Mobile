//
//  UserManagement.h
//  ChartsDemo
//
//  Created by NguyenVanTu on 4/14/17.
//  Copyright © 2017 dcg. All rights reserved.
//

#import "TTNS_BaseVC.h"

@interface UserManagement : BaseVC

@property (weak, nonatomic) IBOutlet UIButton *centerAbsentInfo;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Presence;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Absence;

@property (weak, nonatomic) IBOutlet UIButton *backDateButton;
@property (weak, nonatomic) IBOutlet UIButton *nextDateButton;

- (IBAction)backDateAction:(id)sender;

- (IBAction)nextDateAction:(id)sender;
- (void)reloadData;
@end
