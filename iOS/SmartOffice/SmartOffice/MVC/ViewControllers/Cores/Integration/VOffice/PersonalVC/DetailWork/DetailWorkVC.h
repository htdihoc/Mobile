//
//  DetailWorkVC.h
//  SmartOffice
//
//  Created by Kaka on 4/17/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "TTNS_BaseVC.h"
@class WorkModel;

@interface DetailWorkVC : TTNS_BaseVC<UITableViewDataSource>{
	
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topMargin;

@property (strong, nonatomic) WorkModel *workModel;

@property (weak, nonatomic) IBOutlet UITableView *tblContent;
@property (assign, nonatomic) ListWorkType segmentCurrent;

@end
