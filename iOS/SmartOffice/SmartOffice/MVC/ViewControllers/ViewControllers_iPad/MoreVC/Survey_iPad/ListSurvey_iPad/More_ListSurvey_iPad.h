//
//  More_ListSurvey_iPad.h
//  SmartOffice
//
//  Created by NguyenDucBien on 5/19/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import "TTNS_BaseSubView_iPad.h"

@interface More_ListSurvey_iPad : TTNS_BaseSubView_iPad <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *checkOutTableView;

@end
