//
//  AttachDocVC.m
//  SmartOffice
//
//  Created by Hien Tuong on 4/17/17.
//  Copyright © 2017 Nguyen Thanh Huy. All rights reserved.
//

#import "AttachDocVC.h"
#import "AttachCell.h"
#import "TTNSProcessor.h"
#import "TTNS_AttachDocModel.h"

#import "Common.h"
#import "SOErrorView.h"
#import "MBProgressHUD.h"

@interface AttachDocVC ()<UITableViewDataSource, UITableViewDelegate, TTNS_BaseNavViewDelegate, SOErrorViewDelegate>{
    
    
    SOErrorView *soErrorView;
    
    NSMutableArray *_attachArray;
    
}

@end

@implementation AttachDocVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.backTitle = LocalizedString(@"KGENERALINFO_SCR_FILES");
    
    soErrorView = (SOErrorView *)([[UINib nibWithNibName:@"SOErrorView" bundle:nil] instantiateWithOwner:nil options:nil][0]);
    soErrorView.delegate = self;
    soErrorView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-194);
    soErrorView.lblErrorInfo.text = @"Mất kết nối hệ thống";
    [self.view addSubview:soErrorView];
    soErrorView.hidden = YES;
    
    
    _attachArray = [NSMutableArray new];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self loadData];
}

- (void)didTapBackButton {
    [self popToMoreRoot];
}

- (void) errorServerTTTS {
    soErrorView.hidden = NO;
    [self addView:soErrorView toView:self.tableView];
    [MBProgressHUD hideHUDForView:self.view animated:YES]; // hiden
}

- (void) donotInternet {
    [[Common shareInstance] showErrorHUDWithMessage:@"Mất kết nối Internet" inView: self.tableView];
    [MBProgressHUD hideHUDForView:self.view animated:YES]; // hiden
}

- (void)didRefreshOnErrorView:(SOErrorView *)errorView {
    [self loadData];
}

#pragma mark request sever
- (void)loadData {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES]; // show
    
    [TTNSProcessor getAttachFile:[GlobalObj getInstance].ttns_employID callBack:^(BOOL success, NSDictionary *resultDict, NSException *exception) {
        if (success) {
            
            //            NSDictionary *data      = [resultDict valueForKey:@"data"];
            //            NSDictionary *entity    = [data valueForKey:@"entity"];
            //            _attachModel = [[TTNS_AttachDocModel alloc] initWithDictionary:entity error:nil];
            
            NSArray *data   = resultDict[@"data"][@"entity"];
            _attachArray = [TTNS_AttachDocModel arrayOfModelsFromDictionaries:data error:nil];
            DLog(@"QQQQQQQQQ %ld",_attachArray.count);
            [self.tableView reloadData];
            
            [MBProgressHUD hideHUDForView:self.view animated:YES]; // hiden
            soErrorView.hidden = YES;
        } else {
            //pare error here
            [self handleErrorFromResult:resultDict withException:exception inView:self.view];
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _attachArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* Identifier     = @"AttachCell";
    
    AttachCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    
    
    if(cell == nil){
        [tableView registerNib:[UINib nibWithNibName:Identifier bundle:nil] forCellReuseIdentifier:Identifier];
        cell                            = [tableView dequeueReusableCellWithIdentifier:Identifier];
        cell.selectionStyle             = UITableViewCellSelectionStyleNone;
    }
    
    TTNS_AttachDocModel *_attachModel = _attachArray[indexPath.row];
    
    cell.numberLB.text = [NSString stringWithFormat:@"%ld.", indexPath.row + 1];
    
    if (_attachModel.categorProfileName == nil) {
        cell.titleLB.text = @"* File đính kèm không có tên *";
        
    } else {
        cell.titleLB.text = _attachModel.categorProfileName;
    }
    
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end
