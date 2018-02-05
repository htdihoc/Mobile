//
//  InputText_TableViewCell.h
//  SmartOffice
//
//  Created by NguyenDucBien on 9/29/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InputText_TableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *docNumberTittle;
@property (weak, nonatomic) IBOutlet UITextField *docNumberTextfile;
@property (weak, nonatomic) IBOutlet UILabel *codeTaxTittle;
@property (weak, nonatomic) IBOutlet UITextField *codeTaxTextfile;

@end
