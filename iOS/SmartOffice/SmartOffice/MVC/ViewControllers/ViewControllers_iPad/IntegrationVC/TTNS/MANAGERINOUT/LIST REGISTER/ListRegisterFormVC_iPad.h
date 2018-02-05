//
//  ListRegisterFormVC_iPad.h
//  SmartOffice
//
//  Created by Administrator on 4/28/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "BaseVC.h"

@interface ListRegisterFormVC_iPad : BaseVC

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIButton *floatingButton;

- (IBAction)createNewAction:(id)sender;


@end
