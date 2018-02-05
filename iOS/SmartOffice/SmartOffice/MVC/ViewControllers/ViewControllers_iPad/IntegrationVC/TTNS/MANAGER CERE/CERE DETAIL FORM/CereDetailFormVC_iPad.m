//
//  CereDetailFormVC_iPad.m
//  SmartOffice
//
//  Created by Administrator on 5/4/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "CereDetailFormVC_iPad.h"

#import "RegisterAbsentCell.h"
#import "RegisterWatchCell.h"
#import "TTNS_WorkList.h"
#import "RegisterOtherFreeDay.h"
#import "RegisterMore_iPad.h"
#import "WYPopoverController.h"
#import "UIButton+BorderDefault.h"
#import "ChoiseLocationVC_iPad.h"
#import "MZFormSheetController.h"

@interface CereDetailFormVC_iPad ()<UITableViewDataSource, UITableViewDelegate, CheckListDelegate, WYPopoverControllerDelegate, RegisterMore_iPadDelegate, ChoiseLocationDelegate, RegisterWatchCellDelegate>{
@protected NSArray *array;
@protected WYPopoverController *popOverController;
@protected NSIndexPath *_selectedIndexPath;
@protected NSMutableArray<NSIndexPath *>*selectedIndexPathArr;
}



@end

@implementation CereDetailFormVC_iPad

#pragma mark lifecycler

- (void)viewDidLoad {
    [super viewDidLoad];
    selectedIndexPathArr = [[NSMutableArray alloc]init];
    DLog(@"%@", selectedIndexPathArr);
    [self passData];
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.view.backgroundColor = [UIColor whiteColor];
}

#pragma mark UI

- (void)setupUI{
    //    self.tableView.estimatedRowHeight = 250;
    //    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    self.mTitle.text = @"Chi tiết đăng ký";
    [self.registerMoreButton setTitleColor:AppColor_MainTextColor forState:UIControlStateNormal];
    [self.registerMoreButton setDefaultBorder];
    [self.registerButton setDefaultBorder];
    [self addTappGesture];
}

- (void)passData{
    array = @[@"1", @"2"];
}

- (void)addTappGesture{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
}

#pragma mark action
- (void)dismissKeyboard{
    [self.view endEditing:YES];
}

#pragma mark tableview datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellWatchIdentifier    = @"RegisterWatchCell";
    RegisterWatchCell *watchCell = [tableView dequeueReusableCellWithIdentifier:cellWatchIdentifier];
    if(watchCell == nil){
        [tableView registerNib:[UINib nibWithNibName:cellWatchIdentifier bundle:nil] forCellReuseIdentifier:cellWatchIdentifier];
        watchCell = [tableView dequeueReusableCellWithIdentifier:cellWatchIdentifier];
        watchCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    watchCell.delegate = self;
    
    [watchCell.btn_WorkType addTarget:self action:@selector(showPopupWorkList) forControlEvents:UIControlEventTouchUpInside];
    
    [watchCell.btn_MoreOption addTarget:self action:@selector(choiseRegisterMore:) forControlEvents:UIControlEventTouchUpInside];
    
    [watchCell.locationButton addTarget:self action:@selector(showChoiseLocation) forControlEvents:UIControlEventTouchUpInside];
    
    [watchCell.ckOff2 setSelected:YES];
    [watchCell.contentWorkView setHidden:YES];
    [watchCell.registerMoreView setHidden:YES];
    watchCell.heightOfRegisterMoreView.constant = 0;
    watchCell.heightOfContentWorkView.constant  = 0;
    
    return watchCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //    if(selectedIndexPathArr.count >= (indexPath.row + 1) ){
    //        if([indexPath compare:selectedIndexPathArr[indexPath.row]] == NSOrderedSame){
    //            return 380;
    //        }
    //    }
    //    return 240;
    
    CGFloat selectHeight = 230;
    
    for(int i = 0; i < selectedIndexPathArr.count; i++){
        if([indexPath compare:selectedIndexPathArr[i]] == NSOrderedSame){
            selectHeight = 300;
        }
    }
    
    return selectHeight;
}

#pragma mark Action

- (void)choiseRegisterMore:(UIButton*)sender{
//    DLog(@"Choise Register More");
//    [self showRegisterMore:(CGPointMake(0, 0))];
}

- (void)showPopupWorkList{
    TTNS_WorkList *workList = NEW_VC_FROM_NIB(TTNS_WorkList, @"TTNS_WorkList");
    //    workList.delegate = self;
    workList.view.backgroundColor = [UIColor whiteColor];
    MZFormSheetController *formSheet = [[MZFormSheetController alloc] initWithViewController:workList];
    formSheet.shadowRadius = 2.0;
    formSheet.shadowOpacity = 0.3;
    formSheet.cornerRadius = 12;
    formSheet.shouldDismissOnBackgroundViewTap = YES;
    formSheet.shouldCenterVertically = YES;
    formSheet.movementWhenKeyboardAppears = MZFormSheetWhenKeyboardAppearsCenterVertically;
    [self mz_presentFormSheetController:formSheet animated:YES completionHandler:^(MZFormSheetController *formSheetController) {
    }];
}

- (void)showChoiseLocation{
    ChoiseLocationVC_iPad *choiseLocationVC = NEW_VC_FROM_NIB(ChoiseLocationVC_iPad, @"ChoiseLocationVC_iPad");
    choiseLocationVC.delegate = self;
    [self showAlert:choiseLocationVC title:nil leftButtonTitle:nil rightButtonTitle:nil leftHander:nil rightHander:nil];
}

- (void)showRegisterMore:(CGPoint)position{
    if(popOverController == nil){
        RegisterMore_iPad *registerMoreVC    = NEW_VC_FROM_NIB(RegisterMore_iPad, @"RegisterMore_iPad");
        registerMoreVC.delegate = self;
        registerMoreVC.view.backgroundColor     = [UIColor whiteColor];
        
        MZFormSheetController *formSheet = [[MZFormSheetController alloc] initWithViewController:registerMoreVC];
        formSheet.presentedFormSheetSize = CGSizeMake(SCREEN_WIDTH_LANDSCAPE/2, SCREEN_WIDTH_LANDSCAPE/2 + 50);

        formSheet.shadowRadius = 2.0;
        formSheet.shadowOpacity = 0.3;
        formSheet.cornerRadius = 15;
        formSheet.shouldDismissOnBackgroundViewTap = YES;
        formSheet.shouldCenterVertically = YES;
        formSheet.movementWhenKeyboardAppears = MZFormSheetWhenKeyboardAppearsCenterVertically;
        [self mz_presentFormSheetController:formSheet animated:YES completionHandler:^(MZFormSheetController *formSheetController) {
        }];
    } else {
        [self close:nil];
    }
}

- (void)close:(id)sender
{
    [popOverController dismissPopoverAnimated:YES completion:^{
        [self popoverControllerDidDismissPopover:popOverController];
    }];
}

#pragma mark RegisterMore_iPad_Delegate
- (void)pressButton:(UIButton *)sender{
//    [self close:nil];
    [self mz_dismissFormSheetControllerAnimated:YES completionHandler:nil];
}

-(void)passDataString:(CheckList *)controller didFinishChooseItem:(NSString *)item{
    RegisterWatchCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"RegisterWatchCell"];
    [cell.btn_WorkType setTitle:item forState:UIControlStateNormal];
}

#pragma mark ChoiseLocation_iPadDelegate
-(void)passingLocation:(ChoiseLocationVC_iPad *)controller didFinishSelectItem:(NSString *)item{
    DLog(@"Do somethings here");
}

- (void)didFinishChoiseWorkPlace:(CheckList *)vc workPlaceId:(NSInteger)workPlaceId address:(NSString *)address{
    DLog(@"Do somethings heres");
}

#pragma mark RegisterWatchCellDelegate

- (void)pressButtonUnExpand:(UIButton *)sender{
    
    _selectedIndexPath = [self.tableView indexPathForCell:(RegisterWatchCell*)sender.superview.superview];
    DLog(@"UnExpand Cell");
        [self.tableView beginUpdates];
    RegisterWatchCell *cell = [self.tableView cellForRowAtIndexPath:_selectedIndexPath];
    cell.lbl_Place.text = LocalizedString(@"TTNS_RegisterAbsentCell_Nơi_nghỉ");
    [selectedIndexPathArr removeObject:_selectedIndexPath];
    
        [self.tableView endUpdates];
}

- (void)pressButtonExpand:(UIButton *)sender{
    
    DLog(@"Expand Cell");
    
    _selectedIndexPath = [self.tableView indexPathForCell:(RegisterWatchCell*)sender.superview.superview];
    
    DLog(@"%ld", (long)_selectedIndexPath.row);
    [self.tableView beginUpdates];
    
    RegisterWatchCell *cell = [self.tableView cellForRowAtIndexPath:_selectedIndexPath];
    cell.lbl_Place.text = LocalizedString(@"TTNS_RegisterWatchCell_Nơi_trực");
    
    self.expandedIndexPath = _selectedIndexPath;
    
    [selectedIndexPathArr addObject:_selectedIndexPath];
    
    [self.tableView endUpdates];
}

#pragma mark - WYPopoverControllerDelegate

- (void)popoverControllerDidPresentPopover:(WYPopoverController *)controller
{
    NSLog(@"popoverControllerDidPresentPopover");
}

- (BOOL)popoverControllerShouldDismissPopover:(WYPopoverController *)controller
{
    return YES;
}

- (void)popoverControllerDidDismissPopover:(WYPopoverController *)controller
{
    if (controller == popOverController)
    {
        popOverController.delegate = nil;
        popOverController = nil;
        // Do something
    }
}

- (BOOL)popoverControllerShouldIgnoreKeyboardBounds:(WYPopoverController *)popoverController
{
    return YES;
}

- (void)popoverController:(WYPopoverController *)popoverController willTranslatePopoverWithYOffset:(float *)value
{
    // keyboard is shown and the popover will be moved up by 163 pixels for example ( *value = 163 )
    *value = 163; // set value to 0 if you want to avoid the popover to be moved
}

#pragma mark IBAction

- (IBAction)registerAction:(id)sender {
    DLog(@"Send Register Cere");
}

- (IBAction)registerMoreAction:(id)sender {
    DLog(@"Choise Register More");
    [self showRegisterMore:(CGPointMake(0, 0))];
}
@end
