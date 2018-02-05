//
//  DetaiReminderListVC.h
//  SmartOffice
//
//  Created by NguyenDucBien on 5/26/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import "TTNS_BaseSubView_iPad.h"

@protocol ListReminderDetailDelegate <NSObject>

- (void)pressButton:(UIButton *)sender;

@end

@interface DetaiReminderListVC : TTNS_BaseSubView_iPad  <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) id <ListReminderDetailDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *btnCreat;
- (IBAction)creatReminderNewAction:(id)sender;

@end
