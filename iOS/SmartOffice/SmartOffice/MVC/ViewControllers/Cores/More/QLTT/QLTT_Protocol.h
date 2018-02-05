//
//  QLTT_Protocol.h
//  SmartOffice
//
//  Created by NguyenVanTu on 5/9/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "QLTTMasterDocumentModel.h"
#import "QLTTFileAttachmentModel.h"
#import "QLTTCommentingPerson.h"
#import "QLTT_InfoDetailController.h"
typedef void (^CallbackQLTT_DetailInfoNormal)(BOOL success, NSArray *resultArray, NSException *exception, NSDictionary *error, BOOL isSubView);
@protocol PassingMasterDocumentModel <NSObject>
@optional
- (void)addErrorView:(NSString *)content;
- (QLTT_InfoDetailController *)getQLTT_InfoDetailController;
- (void)setTile:(NSString *)title subTitle:(NSString *)subTitle;
- (void)dismissVC:(UIGestureRecognizer *)recognizer;
- (void)pushVC:(UIViewController *)vc;
- (void)didSelectRowAt:(NSIndexPath *)indexPath;
- (void)didSelect:(id)item;
- (void)didSelectRow:(QLTTMasterDocumentModel *)item;
- (NSArray *)getMasterTreeDocumentModel;
- (QLTTMasterDocumentModel *)getMasterDocumentDetailModel;
- (void)setMasterDocumentDetailModel:(QLTTMasterDocumentModel *)model;
- (QLTTMasterDocumentModel *)getMasterDocumentModel;
- (void)clearContent;
- (void)setIsSearching:(BOOL)isSearch;
//DetailInfo
- (void)getDocumentWithSameCategory:(NSInteger)page isLoadMore:(BOOL)isLoadMore isRefresh:(BOOL)isRefresh completion:(CallbackQLTT_DetailInfoNormal)completion;
- (void)didCheckLike;
- (QLTTFileAttachmentModel *)getAttachmentModel:(NSInteger)index;
- (NSInteger)numberOfFileAttachment;
- (void)loadDetailDocumentWith:(NSNumber *)documentID isRefresh:(BOOL)isRefresh;
//Comment
- (QLTTCommentingPerson *)commentAtIndex:(NSInteger)index;
- (NSInteger)numberOfComment;
- (NSNumber *)getDocumentId;

- (void)showError:(NSException *)exception isInstant:(BOOL)isInstant ismasterQLTT:(BOOL)ismasterQLTT;
- (void)showErrorWith:(id)result isInstant:(BOOL)isInstant ismasterQLTT:(BOOL)ismasterQLTT;
- (void)showLoading;
- (void)dismissLoading;
- (void)loadCompleteAPI;
- (void)isPushPreview:(BOOL)isPushPreview;
@end

