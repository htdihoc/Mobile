//
//  CancelRegisterVC_iPad.h
//  SmartOffice
//
//  Created by NguyenDucBien on 5/23/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import "TTNS_BaseSubView_iPad.h"

@interface CancelRegisterVC_iPad : TTNS_BaseSubView_iPad
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (assign, nonatomic) NSInteger personalFormId;
- (IBAction)cancelAction:(id)sender;
- (void)loadingData:(NSInteger)personalFormId;


@end
