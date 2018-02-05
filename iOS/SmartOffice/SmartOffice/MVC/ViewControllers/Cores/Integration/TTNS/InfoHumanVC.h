//
//  InfoHumanVC.h
//  SmartOffice
//
//  Created by Kaka on 4/4/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "BaseVC.h"

@protocol IncomeDelegate <NSObject>

- (void)setDataForView:(NSArray *)data;

@end



@interface InfoHumanVC : BaseVC

@property (weak, nonatomic) IBOutlet UIButton *centerTimeKeepingButton;

@property (weak, nonatomic) IBOutlet UIButton *centerInComeButton;

@property (strong, nonatomic) IBOutlet UILabel *incomeLB;

@property (strong, nonatomic) IBOutlet UILabel *dateLB;

@property (strong, nonatomic) IBOutlet UILabel *workInfoLB;

@property (strong, nonatomic) IBOutlet UILabel *countWorkDayLB;

@property (strong, nonatomic) IBOutlet UILabel *countLB;

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) id <IncomeDelegate> delegate;
- (void)reloadData;

@end
