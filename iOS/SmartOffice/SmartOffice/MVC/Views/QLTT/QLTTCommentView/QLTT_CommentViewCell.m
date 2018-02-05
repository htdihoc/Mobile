//
//  QLTTCommentViewCell.m
//  SmartOffice
//
//  Created by NguyenVanTu on 5/5/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "QLTT_CommentViewCell.h"
#import "NSString+StringToDate.h"
#import "NSDate+Utilities.h"
#import "UILabel+Util.h"
@interface QLTT_CommentViewCell()
{
    NSInteger _index;
}

@end
@implementation QLTT_CommentViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.btn_ViewMore.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [self.lbl_Content setFont:[UIFont systemFontOfSize:15]];
    [self.btn_ViewMore setTitleColor:AppColor_MainAppTintColor forState:UIControlStateNormal];
    // Initialization code
}
- (void)checkLoadMore
{
    NSInteger lines = [self.lbl_Content lineCount];
    if(lines > 2)
    {
        self.lbl_Content.numberOfLines = 2;
        [self.btn_ViewMore setHidden:NO];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}
- (void)setupDataForView:(QLTTCommentingPerson *)model index:(NSInteger)index isViewMore:(BOOL)isViewMore
{
    _index = index;
    self.lbl_Name.text = [model.sysUser valueForKey:@"fullName"];
    self.lbl_Date.text = [self dateStringToShow:model.createdDate];
    self.lbl_Content.text = model.content;
    if (isViewMore) {
        [self.btn_ViewMore setHidden:NO];
        self.lbl_Content.numberOfLines = 0;
        [self.btn_ViewMore setTitle:LocalizedString(@"QLTT_CommentView_Ẩn_đi") forState:UIControlStateNormal];
        [self layoutIfNeeded];
    }
    else
    {
        [self.btn_ViewMore setTitle:LocalizedString(@"QLTT_DetailVC_Xem_thêm") forState:UIControlStateNormal];
        [self.btn_ViewMore setHidden:YES];
        self.lbl_Content.numberOfLines = 2;
        [self layoutIfNeeded];
        [self checkLoadMore];
    }
    
    
}
- (NSString *)dateStringToShow:(NSString *)dateString
{
    NSDate *date = [self convertStringToDate:dateString];
    NSString *dayOfWeek = [self getDayOfWeek:date];
    NSString *dateToShow = [date stringWithFormat:DATE_COMMENT_FORMAT_DISPLAY];
    dateToShow = [NSString stringWithFormat:@"%@, %@", dayOfWeek, dateToShow];
    return dateToShow;
}
- (NSDate *)convertStringToDate:(NSString *)dateString
{
    return [dateString convertStringToDateWith:DATE_COMMENT_FORMAT_FROM_SERVER];
}

- (NSString *)getDayOfWeek:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEEE"];
    return [dateFormatter stringFromDate:date];
}
- (IBAction)viewMore:(id)sender {
    [self loadMore];
}
- (void)loadMore
{
//    _isLoadView = !_isLoadView;
//    if (_isLoadView) {
//        self.lbl_Content.numberOfLines = 0;
//        [self.btn_ViewMore setTitle:LocalizedString(@"QLTT_CommentView_Ẩn_đi") forState:UIControlStateNormal];
//    }
//    else
//    {
//        self.lbl_Content.numberOfLines = 2;
//        [self.btn_ViewMore setTitle:LocalizedString(@"QLTT_DetailVC_Xem_thêm") forState:UIControlStateNormal];
//    }
    [self.delegate viewMore:_index];
}
@end
