//
//  VOffice_ListDocumentMain.h
//  SmartOffice
//
//  Created by NguyenVanTu on 5/3/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VOffice_DocumentDetail_iPad.h"
#import "VOffice_DocumentTypicalDetail_iPad.h"
#import "VOffice_Base_iPad.h"
@interface VOffice_ListDocumentMain : VOffice_Base_iPad
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIView *listDocument;
@property (weak, nonatomic) IBOutlet UIView *listDocumentDetail;
@end
