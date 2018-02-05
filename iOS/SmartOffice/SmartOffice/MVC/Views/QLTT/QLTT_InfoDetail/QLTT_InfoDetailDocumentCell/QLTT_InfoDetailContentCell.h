//
//  QLTT_InfoDetailContentCell.h
//  SmartOffice
//
//  Created by NguyenDucBien on 8/7/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol QLTT_InfoDetailContentCellDelegate
- (void)viewMore;
- (BOOL)isActive;
@end

@interface QLTT_InfoDetailContentCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lbl_BookDetailInfo;

@property (weak, nonatomic) IBOutlet UIButton *btn_LoadMore;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cst_LblBookDetailInfo;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cst_Top;

@property (weak, nonatomic) id<QLTT_InfoDetailContentCellDelegate> delegate;

- (IBAction)loadMore:(id)sender;

- (void)enterDataToView:(QLTTMasterDocumentModel *)model index:(NSInteger)index;


@end
