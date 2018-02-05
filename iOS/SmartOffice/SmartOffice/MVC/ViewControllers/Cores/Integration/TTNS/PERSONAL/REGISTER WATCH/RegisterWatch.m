//
//  RegisterMainView.m
//  RegisterWorkOff
//
//  Created by NguyenDucBien on 4/14/17.
//  Copyright © 2017 NguyenDucBien. All rights reserved.
//

#import "RegisterWatch.h"

@interface RegisterWatch () <UITableViewDelegate, UITableViewDataSource>{
    
}
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet FullWidthSeperatorTableView *table_RegisterWatch;
@property (strong, nonatomic) NSArray *array;
@end


@implementation RegisterWatch

#pragma mark Lifecycler
- (void)viewDidLoad {
    [super viewDidLoad];
    self.array = @[@"1", @"2"];
    self.backTitle = LocalizedString(@"TTNS_RegisterWatch_Đăng_ký_trực_nghỉ");
    self.leftBtnAttribute = [[BottomButton alloc] initWithDefautBlueColor:LocalizedString(@"TTNS_RegisterWatch_Gửi_đăng_ký")];
    
    self.table_RegisterWatch.rowHeight = UITableViewAutomaticDimension;
    self.table_RegisterWatch.estimatedRowHeight = 80.0;
    self.table_RegisterWatch.delegate = self;
    self.table_RegisterWatch.dataSource = self;
    [self setupBorderButton];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)registerCellWith:(NSString *)identifer
{
    [self.table_RegisterWatch registerNib:[UINib nibWithNibName:identifer
                                                         bundle:[NSBundle mainBundle]]
                   forCellReuseIdentifier:identifer];
}

#pragma mark UI
- (void)setupBorderButton {
    [_btnWorkContent setTitleColor:AppColor_MainTextColor forState:UIControlStateNormal];
    [_RegisterMoreButton setTitleColor:AppColor_MainTextColor forState:UIControlStateNormal];
    [_btnrRegistrationStatus setTitleColor:AppColor_MainTextColor forState:UIControlStateNormal];
    
    [_btnWorkContent setDefaultBorder];
    [_btnrRegistrationStatus setDefaultBorder];
    [_RegisterMoreButton setDefaultBorder];
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell;
    
    [self registerCellWith:@"RegisterWatchCell"];
    static NSString *cellIdentifier = @"RegisterWatchCell";
    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[RegisterWatchCell alloc]initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}


- (IBAction)RegisterMoreAction:(id)sender {
}
@end
