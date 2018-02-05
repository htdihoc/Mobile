//
//  TaskVC.h
//  SmartOffice
//
//  Created by Kaka on 4/4/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "BaseVC.h"

@class SOCycleView;
@interface TaskVC : BaseVC{
	
}
@property (weak, nonatomic) IBOutlet UILabel *lblDelayProgress;
@property (weak, nonatomic) IBOutlet UILabel *lblUnInprogress;
@property (weak, nonatomic) IBOutlet UITableView *tblContent;
@property (weak, nonatomic) IBOutlet SOCycleView *dotNotProgress;
@property (weak, nonatomic) IBOutlet SOCycleView *dotSlowProgress;

-(void)loadData;
@end
