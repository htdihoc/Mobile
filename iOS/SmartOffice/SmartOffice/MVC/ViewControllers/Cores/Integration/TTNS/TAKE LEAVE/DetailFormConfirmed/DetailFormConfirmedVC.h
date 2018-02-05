//
//  DetailFormConfirmedVC.h
//  SmartOffice
//
//  Created by Administrator on 6/1/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import "TTNS_BaseVC.h"

@interface DetailFormConfirmedVC : TTNS_BaseVC

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (assign, nonatomic) NSInteger personalFormId;
@property (assign, nonatomic) NSInteger typeOfForm;

@end
