	//
//  ListRegisterInOutFormVC_iPad.h
//  SmartOffice
//
//  Created by Administrator on 4/28/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "TTNS_BaseSubView_iPad.h"

@protocol ListRegisterInOutDelegate <NSObject>

- (void)pressButton:(UIButton *)sender;

- (void)getFirstEmpId:(NSInteger)firstEmpId;

- (void)getSelectedEmpId:(NSInteger)empRegOutId;

@end

@interface ListRegisterInOutFormVC_iPad : TTNS_BaseSubView_iPad

@property (weak, nonatomic) id <ListRegisterInOutDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIButton *registerNewFormInOutButton;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)RegisterNewFormInOutAction:(id)sender;

@end
