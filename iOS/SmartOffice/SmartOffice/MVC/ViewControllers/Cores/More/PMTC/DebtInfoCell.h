//
//  DebtInfoCell.h
//  SmartOffice
//
//  Created by Vu Van Tiep on 6/26/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DebtInfoCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *debtNumberLabel;

@property (weak, nonatomic) IBOutlet UILabel *currentDebtLabel;
@property (weak, nonatomic) IBOutlet UILabel *lineLabel;

@end
