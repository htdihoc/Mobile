//
//  VOffice_Protocol.h
//  SmartOffice
//
//  Created by NguyenVanTu on 5/22/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//
#import "MeetingModel.h"
@protocol VOfficeProtocol
@optional
- (void)endEditVC;
- (NSIndexPath *)lastIndex;
- (void)didSelectRow:(NSIndexPath *)indexPath;
- (NSArray *)listItemsToShow;
- (void)didSelectVOffice;
- (void)showError:(id)result withException:(NSException *)exception;
//Meeting
- (MeetingModel *)getMeetingModelWith:(NSIndexPath *)indexPath;
- (MeetingModel *)getCurrentMeetingModel;

//Document
- (void)setDocType:(DocType)docType;
- (DocType)docType;
- (void)didSelectDocWithID:(NSString *)docId;
- (void)reloadTypicalDetailView;
- (void)showNetworkNotAvailable;

- (void)showLoading;
- (void)dismissLoading;

- (BOOL)canShowDetail;
- (void)setCanShowDetail:(BOOL)show;

- (void)removeDetailContentLabel;

- (void)hiddenBottomView:(BOOL)isHidden;
@end
