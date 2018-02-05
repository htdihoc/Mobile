//
//  HandlerListCell.h
//  SmartOffice
//
//  Created by NguyenDucBien on 5/12/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HandlerListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgAvatarPerson;
@property (weak, nonatomic) IBOutlet UILabel *lbPersonName;
@property (weak, nonatomic) IBOutlet UILabel *lbPersonPosition;

@end
