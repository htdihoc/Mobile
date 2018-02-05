//
//  DealHistoryCell.h
//  SmartOffice
//
//  Created by Vu Van Tiep on 6/26/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EmployeeDebtTransactionModel.h"
#define DATE_DOCUMENT_FROM_SERVER @"yyyy-MM-dd"

@interface DealHistoryCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *timeTittleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyNumberLabel;

@property (weak, nonatomic) IBOutlet UIView *timeView;

@property (weak, nonatomic) IBOutlet UILabel *currentUnitLabel;

@property (weak, nonatomic) IBOutlet UILabel *noHistoryLabel;


@end
