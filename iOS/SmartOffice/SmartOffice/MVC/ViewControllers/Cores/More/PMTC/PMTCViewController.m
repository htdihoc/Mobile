//
//  PMTCViewController.m
//  SmartOffice
//
//  Created by Vu Van Tiep on 6/26/17.
//  Copyright © 2017 ITSOL. All rights reserved.
//

#import "PMTCViewController.h"
#import "HeaderPMTCCell.h"
#import "DebtInfoCell.h"
#import "DealHistoryCell.h"
#import "AttachedCell.h"
#import "SendBillViewController.h"
#import "PMTC_AttachedDocument_VC.h"
#import "EmployeeDebtModel.h"
#import "EmployeeDebtTransactionModel.h"
#import "PMTCProcessor.h"
#import "Common.h"
#import "SOErrorView.h"
#import "WorkNoDataView.h"
#import "NSString+StringToDate.h"
#import "SVPullToRefresh.h"

@interface PMTCViewController () <UITableViewDataSource, UITableViewDelegate, TTNS_BaseNavViewDelegate, SOErrorViewDelegate>
{
    SOErrorView *soErrorView;
    NSMutableArray *employeeDebtList;
    NSMutableArray *employeeDebtHistoryList;
    EmployeeDebtTransactionModel *debtTransactionModel;
    NSNumber* debAmountCurrennt;
    
}
@property (strong, nonatomic) EmployeeDebtModel *employee;
@property (strong, nonatomic) NSArray *data_HistoryPMTC;
@property (strong, nonatomic) NSArray *data_employeeDebt;


@end

@implementation PMTCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initErrorView];
    employeeDebtList = [NSMutableArray new];
    employeeDebtHistoryList = [NSMutableArray new];
    self.backTitle = LocalizedString(@"KMORE_PMTC");
    self.switchScreen = 0;
    self.pmtcTableView.delegate = self;
    self.pmtcTableView.dataSource = self;
    [self getDataDebtInformationHistory];
    [self getDataDebtInformation];
    self.pmtcTableView.estimatedRowHeight = 104.0;
    self.pmtcTableView.rowHeight = UITableViewAutomaticDimension;
    self.image_attach_pmtc = [NSMutableArray arrayWithObjects:@"send_menu", @"attach_documents", nil];
    self.title_attach_pmtc = [NSMutableArray arrayWithObjects:LocalizedString(@"PMTC_SEND_INVOICE"), LocalizedString(@"PMTC_ATTACH_VOUCHER"), nil];
    [AppDelegateAccessor setupSegment:_segmented_view];
    [self setTittleDebtView];
}

- (void)setTittleDebtView {
    self.HeaderTHCNtitle.text = LocalizedString(@"PMTC_MAKE_DEBT");
    self.CNHTtitle.text = [NSString stringWithFormat:@"%@%@", LocalizedString(@"PMTC_CURRENT_DEBT"), @":"];
    self.HistoryLabel.text = LocalizedString(@"PMTC_TRANSACTION_HISTORY");
}

- (void) initErrorView {
    soErrorView = (SOErrorView *)([[UINib nibWithNibName:@"SOErrorView" bundle:nil] instantiateWithOwner:nil options:nil][0]);
    soErrorView.delegate = self;
    soErrorView.frame = CGRectMake(0, 44, self.view.frame.size.width, self.view.frame.size.height);
    soErrorView.lblErrorInfo.text = @"Mất kết nối hệ thống";
    [self.view addSubview:soErrorView];
    soErrorView.hidden = YES;
}

- (void)didRefreshOnErrorView:(SOErrorView *)errorView {
    [self getDataDebtInformation];
    [self getDataDebtInformationHistory];
}

- (void) getDataDebtInformationHistory {
    [[Common shareInstance] showCustomHudInView:self.view];
    
    NSDictionary *parameter = @{
                                @"arg0": @"111999",
                                @"arg1": @"01/01/2015",
                                @"arg2": @"31/12/2017",
                                @"arg3": @10,
                                @"arg4": @0
                                };
    [PMTCProcessor postPMTC_getEmployeeDebtTransaction:parameter handle:^(id result, NSString *error) {
        [[Common shareInstance] dismissCustomHUD];
        if ([Common checkNetworkAvaiable]) {
            NSArray *data = result;
            //        [employeeDebtHistoryList addObjectsFromArray:data];
            data = [EmployeeDebtTransactionModel arrayOfModelsFromDictionaries:data error:nil];
            employeeDebtHistoryList = [NSMutableArray arrayWithArray:[self sortArray:data]];
            self.data_HistoryPMTC = employeeDebtHistoryList;
            if (employeeDebtHistoryList.count > 0 ) {
                [self.pmtcTableView reloadData];
                self.pmtcTableView.hidden = NO;
                soErrorView.hidden = YES;
            }
        }
    } onError:^(NSString *Error) {
        [self donotConnect];
    } onException:^(NSString *Exception) {
        [self donotConnect];
    }];
}

- (void) getDataDebtInformation{
    [[Common shareInstance] showCustomHudInView:self.view];
    NSDictionary *parameter = @{
                                @"arg0": @"111999"
                                };
    [PMTCProcessor postPMTC_getEmployeeDebt:parameter handle:^(id result, NSString *error) {
        [[Common shareInstance] dismissCustomHUD];
        NSDictionary *dict = result;
        self.employee = [[EmployeeDebtModel alloc] initWithDictionary:dict error:nil];
        if (self.employee != nil) {
            self.currentUinitLabel.text = [NSString stringWithFormat:@"%@%@ %@", @"*" ,LocalizedString(@"PMTC_CURRENT_UNIT"), self.employee.currencyCode];
            NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
            [numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
            self.currentCodeLabel.text = [numberFormatter stringFromNumber:[NSNumber numberWithInteger:self.employee.debtAmount]];
            soErrorView.hidden = YES;
        } else {
            [self addNoDataView];
        }
    } onError:^(NSString *Error) {
        [self donotConnect];
    } onException:^(NSString *Exception) {
        [self donotConnect];
        return;
    }];
}

- (void) errorServer {
    soErrorView.hidden = NO;
    self.pmtcTableView.hidden = YES;
    [[Common shareInstance] dismissCustomHUD];
    [[Common shareInstance] showErrorHUDWithMessage:@"Mất kết tới hệ thống vui lòng thử lại" inView: self.view];
}
- (void) donotConnect {
    soErrorView.hidden = NO;
    self.pmtcTableView.hidden = YES;
    [[Common shareInstance] dismissCustomHUD];
    if ([Common checkNetworkAvaiable]) {
        return [self errorServer];
    } else {
//        [[Common shareInstance] showErrorHUDWithMessage:@"Mất kết nối Internet" inView: self.view];
         return [self donotInternet];
    }
}

- (void) addNoDataView {
    WorkNoDataView *workNoDataView  = (WorkNoDataView*)([[UINib nibWithNibName:@"WorkNoDataView" bundle:nil] instantiateWithOwner:nil options:nil][0]);
    workNoDataView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    workNoDataView.contenLB.text    = LocalizedString(@"PMTC_NO_DATA");
    [self.pmtcTableView addSubview:workNoDataView];
}

- (void) donotInternet {
    soErrorView.hidden = NO;
    self.pmtcTableView.hidden = YES;
    self.HeaderView.hidden = YES;
    [[Common shareInstance] dismissCustomHUD];
    [[Common shareInstance] showErrorHUDWithMessage:@"Mất kết nối mạng" inView: self.view];
}

- (NSString *)convertDate:(NSString *)inDate {
    NSDateFormatter *dateFormat = [NSDateFormatter new];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [dateFormat dateFromString:inDate];
    NSDateFormatter *convert = [[NSDateFormatter alloc]init];
    [convert setDateFormat:@"dd/MM/yyyy"];
    NSString *result = [convert stringFromDate:date];
    return result;
}


- (NSArray *)sortArray:(NSArray *)data
{
    NSArray *sortedArray;
    sortedArray = [data sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        NSDate *first = [[(EmployeeDebtTransactionModel *)a documentDate] convertStringToDateWith:DATE_DOCUMENT_FROM_SERVER];
        NSDate *second = [[(EmployeeDebtTransactionModel *)b documentDate] convertStringToDateWith:DATE_DOCUMENT_FROM_SERVER];
        return [second compare:first];
    }];
    return sortedArray;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.switchScreen == 0) {
        return employeeDebtHistoryList.count;
    } else {
        return 2;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (self.switchScreen) {
        case 0:
        {
            [self.HeaderView setHidden:NO];
            self.cst_headerView.constant = 120;
            static NSString *identifier = @"dealhistoryPMTC";
            DealHistoryCell *dealHistoryCell = (DealHistoryCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
            if (dealHistoryCell == nil) {
                        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"DealHistoryCell" owner:self options:nil];
                        dealHistoryCell = [nib objectAtIndex:0];
                    }
            if (employeeDebtHistoryList.count > 0) {
                        [dealHistoryCell setHidden:NO];
                        EmployeeDebtTransactionModel *model = employeeDebtHistoryList[indexPath.row];
            NSDate *today = [NSDate date];
            NSDateFormatter *dateFormat = [NSDateFormatter new];
            [dateFormat setDateFormat:@"dd/MM/yyyy"];
            NSString *dateString = [dateFormat stringFromDate:today];
            if ([[self convertDate:model.documentDate] isEqualToString:dateString])  {
            dealHistoryCell.timeTittleLabel.text = [NSString stringWithFormat:@"%@ (%@)", @"Hôm nay", dateString];
                        } else {
            dealHistoryCell.timeTittleLabel.text = [self convertDate:model.documentDate];
                }
            dealHistoryCell.contentLabel.text = model.description;
            dealHistoryCell.currentUnitLabel.text = model.currencyCode;
            if (IS_IPAD) {
                [dealHistoryCell.currentUnitLabel setHidden:NO];
                dealHistoryCell.moneyTitleLabel.text = [NSString stringWithFormat:@"%@", LocalizedString(@"PMTC_NO_MONEY")];
                }
                else {
                [dealHistoryCell.currentUnitLabel setHidden:YES];
                }
                dealHistoryCell.moneyTitleLabel.text = [NSString stringWithFormat:@"%@:", LocalizedString(@"PMTC_NO_MONEY")];
                        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
                [numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
                        NSString *debtNumberString = [numberFormatter stringFromNumber:[NSNumber numberWithInteger:model.amount]];
                dealHistoryCell.moneyNumberLabel.text = debtNumberString;
                } else {
                    [dealHistoryCell setHidden:YES];
                }
                    
                    dealHistoryCell.selectionStyle = UITableViewCellSeparatorStyleNone;
            
            [self.pmtcTableView addPullToRefreshWithActionHandler:^{
                [self.pmtcTableView.pullToRefreshView stopAnimating];
                [self reloadDataTableView];
            }];
                    return dealHistoryCell;
                }
                    break;
        case 1:
        {
            [self.HeaderView setHidden:YES];
            self.cst_headerView.constant = 0;
            static NSString *identifier = @"attachedCell";
            AttachedCell *attachedCell = (AttachedCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
            if (attachedCell == nil) {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AttachedCell" owner:self options:nil];
                attachedCell = [nib objectAtIndex:0];
            }
            attachedCell.title_attach.text = [self.title_attach_pmtc objectAtIndex:indexPath.row];
            attachedCell.image_attach.image = [UIImage imageNamed:self.image_attach_pmtc[indexPath.row]];
            [attachedCell.image_attach sizeToFit];
            [attachedCell.image_arrow setHidden:YES];
            attachedCell.selectionStyle = UITableViewCellSeparatorStyleNone;
            return attachedCell;
        }
            break;
        default:
            return nil;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (self.switchScreen) {
        case 0:
        {
            return UITableViewAutomaticDimension;
        }
            break;
        case 1:
        {
            return 50;
        }
            break;
        default:
            return 0;
            break;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (self.switchScreen) {
        case 0:
        {
            // action nil
        }
            break;
        case 1:
        {
            switch (indexPath.row) {
                case 0:
                {
                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"SendBill" bundle:nil];
                    SendBillViewController *sendBill = (SendBillViewController *)[storyboard instantiateViewControllerWithIdentifier:@"SendBillViewController"];
                    sendBill.widthCollection = sendBill.view.frame.size.width;
                    [self.navigationController pushViewController:sendBill animated:YES];
                }
                    break;
                case 1:
                {
                    PMTC_AttachedDocument_VC *vc = NEW_VC_FROM_NIB(PMTC_AttachedDocument_VC, @"PMTC_AttachedDocument_VC");
                    [self.navigationController pushViewController:vc animated:YES];
                }
                    break;
                default:
                    break;
            }
        }
            break;
        default:
            break;
    }
}

- (void) reloadDataTableView {
    if ([Common checkNetworkAvaiable]) {
        [employeeDebtHistoryList removeAllObjects];
        [self getDataDebtInformationHistory];
        [self.pmtcTableView reloadData];
    } else {
        [self showToastWithMessage:@"Mất kết nối Internet"];
    }
    
}

- (IBAction)segmentedAction:(id)sender {
    NSUInteger selectedSegment = self.segmented_view.selectedSegmentIndex;
    [AppDelegateAccessor setupSegment:sender];
    switch (selectedSegment) {
        case 0:
        {
            self.switchScreen = 0;
            [self.pmtcTableView reloadData];
        }
            break;
        case 1:
        {
            self.switchScreen = 1;
            [self.pmtcTableView reloadData];
        }
            break;
        default:
            break;
    }
}

- (void) didTapBackButton {
    [self popToMoreRoot];
}

@end
