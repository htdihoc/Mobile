//
//  ListRegisterFormVC_iPad.h
//  SmartOffice
//
//  Created by Administrator on 4/28/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "TTNS_BaseSubView_iPad.h"

@protocol ListRegisterFormVC_iPadDelegate <NSObject>

- (void)getFirstPersonalFormId:(NSInteger)personalFormFristId status:(StatusType)status;
- (void)getSelectedPersonalFormId:(NSInteger)personalFormSelectedId status:(StatusType)status;

@end

@interface ListRegisterFormVC_iPad : TTNS_BaseSubView_iPad

@property (weak, nonatomic) id <ListRegisterFormVC_iPadDelegate> delegate;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIButton *floatingButton;

- (IBAction)createNewAction:(id)sender;


@end
