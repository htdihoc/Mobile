//
//  QLTT_DetailView.m
//  SmartOffice
//
//  Created by NguyenVanTu on 5/5/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "QLTT_DetailView.h"
#import "NSDate+Utilities.h"
#import "UIImage+Resize.h"
#import "NSString+Util.h"
@implementation QLTT_DetailView

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.isLoading = NO;
    [self setupTitleForLabel];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(dismissKeyboard:)];
    
    [self.view addGestureRecognizer:tap];
    [self hiddenTitleAndVersion];
    [self setFrameForTittleLB];
    _iconSecurityImg.layer.cornerRadius = 3;
    _iconSecurityImg.layer.masksToBounds = YES;
    [self.iconSecurityImg setHidden:YES];
}
- (void)scrollTableView:(NSIndexPath *)indexPath animation:(BOOL)animation
{
    if (indexPath == nil) {
        indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    }
    [self.qltt_MasterTableView.tb_QLTTList scrollToRowAtIndexPath:indexPath
                                                 atScrollPosition: UITableViewScrollPositionTop
                                                         animated:animation];
}

- (void)hiddenTitleAndVersion
{
    if (IS_PAD) {
        self.cst_TopHeight.constant = 0;
    }
    else
    {
        self.cst_BottomHeight.constant = 280;
    }
}
- (void)dismissKeyboard:(UIGestureRecognizer*) recognizer
{
    if ([self.delegate respondsToSelector:@selector(dismissVC:)])
    {
        [self.delegate dismissVC:recognizer];
    }
}
- (void)setupTitleForLabel
{
    _lbl_SectionTitle.font = [UIFont systemFontOfSize:14];
    _lbl_SectionTitle.backgroundColor = AppColor_MainAppBackgroundColor;
    _lbl_SectionTitle.text = LocalizedString(@"QLTT_DetailView_Cùng_chuyên_mục");
    _lbl_CreatedTitle.text = [NSString stringWithFormat:@"%@:",LocalizedString(@"QLTT_DetailView_Thời_gian_tạo")];
    _lbl_AuthorTitle.text = LocalizedString(@"QLTT_DetailView_Tác_giả");
    _lbl_LanguageTitle.text = LocalizedString(@"QLTT_DetailView_Ngôn_ngữ");
    _lbl_CheckPersonTitle.text = LocalizedString(@"QLTT_DetailView_Người_phê_duyệt/NXB");
    _lbl_NumberOfPagesTitle.text = LocalizedString(@"QLTT_DetailView_SốTrang/DungLượng");
    _lbl_CreatedByTitle.text = LocalizedString(@"QLTT_DetailView_Người_tạo");
}
- (NSString *)getDateString:(NSDate *)date
{
    //    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //    [dateFormatter setDateFormat:@"dd MMMM yyyy hh:mm"];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear) fromDate:date];
    
    NSInteger hour = [components hour];
    NSInteger minute = [components minute];
    NSInteger month = [components month];
    NSInteger day = [components day];
    NSInteger year = [components year];
    
    return [NSString stringWithFormat:@"%02ld:%02ld - %02ld/%02ld/%ld", (long)hour, (long)minute, (long)day, (long)month, (long)year];
    
}
- (void)enterDataToView:(QLTTMasterDocumentModel *)model
{
    _img_Doc.image = [UIImage imageNamed:@"QLTTDemo"];
    _lbl_DocSize.text = [NSString stringWithFormat:@"%@ %@/%@%@",model.pageNumber, LocalizedString(@"Trang"), model.fileSize, LocalizedString(@"MB")];
    NSString *version = [NSString stringWithFormat:@"(%@ %@)", LocalizedString(@"QLTT_MasterViewCell_Phiên_bản"), model.version];
    _lbl_Version.text = version;
    _lbl_CheckPerson.text = model.approvalName;
    _lbl_Name.text = [model.name stringToShow];
    _lbl_Author.text = model.authorName;
    NSString *createDate = model.createdDate;
    
    if (![createDate isEqualToString:LocalizedString(@"N/A")]) {
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:[createDate doubleValue]/1000];
        _lbl_CreatedDate.text = [self getDateString:date];
    }else
    {
        _lbl_CreatedDate.text = LocalizedString(@"N/A");
    }
    
    _lbl_CreatedUser.text = model.createdUser;
    _lbl_StatusName.text = model.effectStatusString;
    [self imageForStatus:_lbl_StatusName.text];
    _lbl_Language.text = model.language;
    _lbl_NumReadAndDownload.minimumScaleFactor = 0.5;
    _lbl_NumReadAndDownload.adjustsFontSizeToFitWidth = YES;
    _lbl_NumReadAndDownload.text = [NSString stringWithFormat:@"%ld/%ld", [model.numRead longValue], [model.numDownload longValue]];
    NSString *fileType = [model.fileType componentsSeparatedByString:@","].firstObject;
    fileType = [fileType isEqualToString:@""] ? @"otherFile" : [NSString stringWithFormat:@"%@File", [fileType lowercaseString]];
    UIImage *imgType = [UIImage imageNamed:fileType];
    if (!imgType) {
        imgType = [UIImage imageNamed:@"otherFile"];
    }
    _img_FileType.image = imgType;
    [self addTextToLikeLbl:[model.numLike longValue] isLike:model.isLike];
    [self loadImage:model.avatar.firstObject];
    [_info loadDataWith:model];
    [_info layoutIfNeeded];
}
- (void)imageForStatus:(NSString *)status
{
    if ([status isEqualToString:@"Còn hiệu lực"]) {
        self.img_Time.image = [UIImage imageNamed:@"state1"];
        _lbl_StatusName.textColor = COLOR_FROM_HEX(0x00a651);
    }
    else if ([status isEqualToString:@"Sắp hết hiệu lực"])
    {
        self.img_Time.image = [UIImage imageNamed:@"state2"];
        _lbl_StatusName.textColor = COLOR_FROM_HEX(0xe66b29);
    }
    else if ([status isEqualToString:@"Đã hết hiệu lực"])
    {
        self.img_Time.image = [UIImage imageNamed:@"state3"];
        _lbl_StatusName.textColor = COLOR_FROM_HEX(0xff3a3a);
    }
    else
    {
        self.img_Time.image = [UIImage imageNamed:@"timer_icon"];
        _lbl_StatusName.textColor = AppColor_MainTextColor;
    }
}
- (void)loadImage:(QLTTFileAttachmentModel *)avatar
{
    if (avatar) {
        [QLTT_InfoDetailController loadData:avatar.filePath completion:^(BOOL success, NSData *resultData, NSException *exception, NSDictionary *error) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void) {

                UIImage *image = [UIImage imageWithImageCache:[UIImage imageWithData:resultData] key:avatar.filePath];
                if (image) {
                    dispatch_sync(dispatch_get_main_queue(), ^(void) {
                        _img_Doc.image = image;
                    });
                }
                else
                {
                    dispatch_sync(dispatch_get_main_queue(), ^(void) {
                        _img_Doc.image = [UIImage imageNamed:@"QLTTDemo"];
                    });
                }
                
            });
        }];
        
    }
    else
    {
        _img_Doc.image = [UIImage imageNamed:@"QLTTDemo"];
    }
}
- (void)addTextToLikeLbl:(long)modelNumLike isLike:(BOOL)isLike
{
    NSInteger numLike = modelNumLike;
    NSString *subString = LocalizedString(@"QLTT_DetailVC_hãy_là_người_đầu_tiên_thích_tài_liệu_này");
    [_img_Like setBackgroundImage:[UIImage imageNamed:@"likeIconGray"] forState:UIControlStateNormal];
    if (numLike != 0) {
        if (isLike) {
            [_img_Like setBackgroundImage:[UIImage imageNamed:@"likeIcon"] forState:UIControlStateNormal];
            numLike = numLike - 1;
            if (numLike > 0) {
                subString = [NSString stringWithFormat:@"%@ %@ %ld %@ %@", LocalizedString(@"QLTT_DetailVC_Bạn"), LocalizedString(@"QLTT_DetailVC_và"), (long)numLike, LocalizedString(@"QLTT_DetailVC_người_khác"), LocalizedString(@"QLTT_DetailVC_thích_tài_liệu_này")];
            }
            else
            {
                subString = [NSString stringWithFormat:@"%@ %@", LocalizedString(@"QLTT_DetailVC_Bạn"), LocalizedString(@"QLTT_DetailVC_thích_tài_liệu_này")];
            }
        }
        else
        {
            subString = [NSString stringWithFormat:@"%ld %@ %@", (long)numLike, LocalizedString(@"QLTT_DetailVC_người"), LocalizedString(@"QLTT_DetailVC_thích_tài_liệu_này")];
        }
        
    }
    
    _lbl_NumerLike.text = subString;
}

- (IBAction)likeDocument:(id)sender {
    [self.delegate didSelectLikeButton];
}
- (BOOL)checkVisible:(UITableViewCell *)cell
{
    return [self.qltt_MasterTableView.tb_QLTTList.visibleCells containsObject:cell];
}
- (NSIndexPath *)getIndexWith:(QLTT_MasterViewCell *)cell
{
    return [self.qltt_MasterTableView.tb_QLTTList indexPathForCell:cell];
}
- (NSIndexPath *)getIndexWithCell:(QLTT_DetailViewContentCell *)cell
{
    return [self.qltt_MasterTableView.tb_QLTTList indexPathForCell:cell];
}
- (void)reloadTable:(NSIndexPath *)index
{
    [self.qltt_MasterTableView.tb_QLTTList reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)reloadTableData
{
    [self.qltt_MasterTableView.tb_QLTTList reloadData];
    
}
- (void)reloadSections:(NSIndexSet *)sections
{
    [self.qltt_MasterTableView.tb_QLTTList reloadSections:sections withRowAnimation:UITableViewRowAnimationNone];
}
- (void)scrollTo:(CGPoint)point
{
    [self.qltt_MasterTableView.tb_QLTTList setContentOffset:point];
}
- (CGPoint)getContentOffSet
{
    return self.qltt_MasterTableView.tb_QLTTList.contentOffset;
}
//init
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    if(CGRectIsEmpty(frame)) {
        self.bounds = self.view.bounds;
    }
    return self;
}
- (void)setup {
    NSString *xibName = NSStringFromClass([self class]);
    if (IS_IPHONE) {
        xibName = [NSString stringWithFormat:@"%@_iPhoneNew", xibName];
    }
    else
    {
        xibName = [NSString stringWithFormat:@"%@New", xibName];
    }
    self.view = [[[NSBundle mainBundle] loadNibNamed:xibName owner:self options:nil] firstObject];
    self.view.frame = self.bounds;
    [self addSubview:self.view];
}


- (void)setFrameForTittleLB {
    
    if (IS_IPHONE) {
        self.lbl_SectionTitle.edgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
    } else {
        self.lbl_SectionTitle.edgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    }
}



@end
