//
//  ApprovedDetailVC_iPad.h
//  SmartOffice
//
//  Created by NguyenDucBien on 5/30/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import "TTNS_BaseSubView_iPad.h"
#import "InfoDetailCell_iPad.h"
#import "PersonDetail_iPad.h"


@interface ApprovedDetailVC_iPad : TTNS_BaseSubView_iPad <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (void)loadingData:(NSInteger)personalFormId;


@end
