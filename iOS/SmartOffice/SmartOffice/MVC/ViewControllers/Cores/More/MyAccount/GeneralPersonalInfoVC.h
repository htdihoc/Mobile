//
//  GeneralPersonalInfoVC.h
//  SmartOffice
//
//  Created by Nguyen Thanh Huy on 4/6/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "BaseVC.h"

@interface GeneralPersonalInfoVC : BaseVC<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tbViewInfo;

- (IBAction)btnClose:(id)sender;

@end
