//
//  QLTT_InfoDetailDocumentCell.h
//  SmartOffice
//
//  Created by NguyenVanTu on 5/8/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QLTTFileAttachmentModel.h"
//@protocol QLTT_InfoDetailDocumentDelegate <NSObject>
//- (void)dismissVC:(UIGestureRecognizer *)recognizer;
//@end
@interface QLTT_InfoDetailDocumentCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *img_Document;
@property (weak, nonatomic) IBOutlet UILabel *lbl_DocumentName;
@property (weak, nonatomic) IBOutlet UILabel *lbl_DocumentSize;
@property (weak, nonatomic) IBOutlet UILabel *lbl_State;

//@property (weak, nonatomic) id<QLTT_InfoDetailDocumentDelegate> delegate;
- (void)setupdataForView:(QLTTFileAttachmentModel *)model;

@end
