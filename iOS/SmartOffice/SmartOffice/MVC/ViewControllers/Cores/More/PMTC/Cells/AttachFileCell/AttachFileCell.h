//
//  AttachFileCell.h
//  SmartOffice
//
//  Created by NguyenDucBien on 6/26/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AttachFileCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *tittleLB;
- (IBAction)chooseCameraAction:(id)sender;
- (IBAction)chooseImageAction:(id)sender;


@end
