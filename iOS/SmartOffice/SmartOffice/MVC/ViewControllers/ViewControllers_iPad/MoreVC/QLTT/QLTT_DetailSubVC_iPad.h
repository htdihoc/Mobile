//
//  QLTT_DetailSubVC_iPad.h
//  SmartOffice
//
//  Created by NguyenVanTu on 6/1/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VOffice_Base_iPad.h"
#import "SOInsectTextLabel.h"
@interface QLTT_DetailSubVC_iPad : VOffice_Base_iPad
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) id<PassingMasterDocumentModel> delegate;
@property (assign) BOOL isTreeVC;
@property (strong, nonatomic) NSString *titleLabel;
@property (strong, nonatomic) NSString *titleSubLabel;
@end
