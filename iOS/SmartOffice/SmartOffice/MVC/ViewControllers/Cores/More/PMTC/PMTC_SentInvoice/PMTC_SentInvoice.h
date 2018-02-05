//
//  PMTC_SentInvoice.h
//  SmartOffice
//
//  Created by NguyenDucBien on 6/26/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import "TTNS_BaseVC.h"
#import <AVFoundation/AVFoundation.h>

@interface PMTC_SentInvoice : TTNS_BaseVC

@property (weak, nonatomic) IBOutlet UILabel *headerLB;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
