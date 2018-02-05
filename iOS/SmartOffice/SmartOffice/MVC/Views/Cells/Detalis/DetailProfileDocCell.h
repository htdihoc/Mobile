//
//  DetailProfileDocCell.h
//  SmartOffice
//
//  Created by Kaka on 4/17/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailProfileDocCell : UITableViewCell{
	
}
@property (weak, nonatomic) IBOutlet UIImageView *imgAvatar;
@property (weak, nonatomic) IBOutlet UILabel *lblAcceptedSigner;
@property (weak, nonatomic) IBOutlet UILabel *lblInfoSigner;
@property (weak, nonatomic) IBOutlet UILabel *lblStatus;

- (void)setupDataFromModel:(id)model forDoc:(BOOL)isDoc;

@end
