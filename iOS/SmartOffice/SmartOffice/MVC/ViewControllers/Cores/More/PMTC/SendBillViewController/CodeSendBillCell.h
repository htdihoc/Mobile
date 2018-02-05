//
//  CodeSendBillCell.h
//  SmartOffice
//
//  Created by Vu Van Tiep on 6/28/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CodeSendBillCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *title_header;
@property (weak, nonatomic) IBOutlet UITextField *input_code;
- (IBAction)textChange:(id)sender;
@end
