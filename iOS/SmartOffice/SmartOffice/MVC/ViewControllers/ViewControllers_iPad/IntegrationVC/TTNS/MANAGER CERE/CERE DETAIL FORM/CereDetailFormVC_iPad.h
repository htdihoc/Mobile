//
//  CereDetailFormVC_iPad.h
//  SmartOffice
//
//  Created by Administrator on 5/4/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "TTNS_BaseSubView_iPad.h"
#import "FullWidthSeperatorTableView.h"

@interface CereDetailFormVC_iPad : TTNS_BaseSubView_iPad

@property (weak, nonatomic) IBOutlet UILabel *titleLB;

@property (weak, nonatomic) IBOutlet FullWidthSeperatorTableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;

@property (weak, nonatomic) IBOutlet UIButton *registerMoreButton;


@property (strong, nonatomic) NSIndexPath *expandedIndexPath;
@property (strong, nonatomic) NSMutableArray<NSIndexPath*> *indexPathExpandArr;

- (IBAction)registerAction:(id)sender;

- (IBAction)registerMoreAction:(id)sender;

@end
