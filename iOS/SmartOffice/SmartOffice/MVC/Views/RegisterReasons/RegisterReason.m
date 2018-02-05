//
//  RegisterReason.m
//  RegisterReason
//
//  Created by NguyenDucBien on 4/17/17.
//  Copyright © 2017 NguyenDucBien. All rights reserved.
//

#import "RegisterReason.h"
#import "Common.h"
#import "TTNSProcessor.h"

#import "ReasonModel.h"

@interface RegisterReason () {
    NSArray *reason;
}
@property (weak, nonatomic) IBOutlet FullWidthSeperatorTableView *checkoutTableView;

@end

@implementation RegisterReason

@synthesize delegate = delegate;

#pragma mark lifecycler 

- (void)viewDidLoad {
    [super viewDidLoad];
    self.checkoutTableView.delegate = self;
    self.checkoutTableView.dataSource = self;
    [self loadingData];
    [self.checkoutTableView reloadData];
    _checkoutTableView.layer.cornerRadius = 10;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark UI

#pragma mark request api

- (void)loadingData{
    [TTNSProcessor getListReason:^(BOOL success, NSDictionary *resultDict, NSException *exception) {
        if(success){
            DLog(@"Get list reason success: %@", resultDict);
            NSArray *data = [resultDict valueForKey:@"data"];
            reason = [ReasonModel arrayOfModelsFromDictionaries:data error:nil];
            [self.checkoutTableView reloadData];
        } else {
            DLog(@"Get list reason fail");
        }
    }];
}

#pragma delegate
- (void)passDataString:(NSInteger)index {
    ReasonModel *model = reason[index];
//    [self.delegate passingSelect:self didFinishSelectItem:reasonId];
    [self.delegate didFinishSelectReason:self reasonID:model.reasonOutId title:model.name];
}

#pragma mark datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return reason.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ReasonContentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myCell"];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"ReasonContentCell" bundle:nil] forCellReuseIdentifier:@"myCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"myCell"];
    }
    ReasonModel *reasonModel = reason[indexPath.row];
    cell.lbReason.text = reasonModel.name;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 50;
}

#pragma mark delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger index = indexPath.row;
    [self passDataString:index];
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
