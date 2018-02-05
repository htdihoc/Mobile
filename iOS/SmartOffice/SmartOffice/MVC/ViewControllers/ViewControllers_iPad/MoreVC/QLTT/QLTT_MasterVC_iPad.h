//
//  QLTT_MasterVC_iPad.h
//  SmartOffice
//
//  Created by NguyenVanTu on 5/26/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QLTT_MasterVCBase.h"
@interface QLTT_MasterVC_iPad : QLTT_MasterVCBase <PassingMasterDocumentModel>
@property (weak, nonatomic) IBOutlet UIView *containerView;

@end
