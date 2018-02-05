//
//  VOffice_DocumentTypicalProfileDetail_iPad.h
//  SmartOffice
//
//  Created by NguyenVanTu on 5/3/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VOffice_DocumentTypicalProfileDetailCell_iPad : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgAvatar;
@property (weak, nonatomic) IBOutlet UILabel *lblAcceptedSigner;
@property (weak, nonatomic) IBOutlet UILabel *lblInfoSigner;
@property (weak, nonatomic) IBOutlet UILabel *lblStatus;
- (void)setupDataFromModel:(id)model type:(DocType)type;
@end
