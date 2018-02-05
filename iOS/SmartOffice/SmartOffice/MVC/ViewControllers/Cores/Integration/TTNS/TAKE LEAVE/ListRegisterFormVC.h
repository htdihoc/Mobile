//
//  ListRegisterFormVC.h
//  SmartOffice
//
//  Created by Hien Tuong on 4/5/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "BaseVC.h"

#import "TTNS_BaseVC.h"
#import "TTNS_MainController.h"

@interface ListRegisterFormVC : TTNS_BaseVC

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) TTNS_MainController *taskGetListRegister;

@property (weak, nonatomic) IBOutlet UIButton *showRegisterButton;

- (IBAction)showRegisterAction:(id)sender;


@end
