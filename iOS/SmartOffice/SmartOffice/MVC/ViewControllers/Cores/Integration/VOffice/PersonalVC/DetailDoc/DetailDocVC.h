//
//  DetailDocVC.h
//  SmartOffice
//
//  Created by Kaka on 4/17/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "TTNS_BaseVC.h"

@class DocModel;
@interface DetailDocVC : TTNS_BaseVC<UITableViewDataSource, UITableViewDelegate>{
	
}

@property (weak, nonatomic) IBOutlet UITableView *tblContent;

//Data
@property (strong, nonatomic) NSString *docId;
@property (assign, nonatomic) DocType type;
@end
