//
//  TPMenuViewController.m
//  blackcard
//
//  Created by Kosuke Hata on 12/9/13.
//  Copyright (c) 2013 topiary. All rights reserved.
//

#import "TPMenuViewController.h"
#import "UIColor+addVeryLightGray.h"
#import "KHButton.h"
#import "TProfileViewController.h"
#import "TPAboutViewController.h"
#import "UIViewController+MMDrawerController.h"

@interface TPMenuViewController ()

@end

@implementation TPMenuViewController
{
    NSMutableArray *titles;
    UINavigationController *nav;
    BCMainViewController *vc1;
    TPProfileViewController.h *vc2;
    TPAboutViewController *vc3;
}

- (void)loadView
{
    //programtically make things happen
    CGRect rect = [KHBase getCurrentCGRect];
    UIView *view = [[UIView alloc] initWithFrame:rect];
    view.backgroundColor = [UIColor veryLightGray];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height-self.barSize)];
    tableView.delegate = self;
    tableView.separatorColor = [UIColor whiteColor];
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.dataSource = self;
    tableView.scrollEnabled = NO;
    tableView.showsVerticalScrollIndicator = NO;
    [view addSubview:tableView];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.width, self.y_start+self.barSize)];
    headerView.backgroundColor = [UIColor whiteColor];
    tableView.tableHeaderView = headerView;
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, self.height-self.y_start-self.barSize, kPhoneWidth, self.barSize+self.y_start)];
    footerView.backgroundColor = [UIColor clearColor];
    tableView.tableFooterView = footerView;
    
    self.view = view;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    // Do any additional setup after loading the view.
    titles = [[NSMutableArray alloc] initWithObjects:
              @"Map",
              @"Profile",
              @"About",
              nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - KHButton delegate method

- (void)buttonWasTouchedUpInside:(KHButton *)button
{
    
}

#pragma mark - UITableView Data source and delegate Method

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return titles.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    cell.textLabel.textColor = [UIColor blackColor];
    cell.textLabel.text = titles[indexPath.row];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self.mm_drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
        
        if (nav == nil) {
            nav = [[UINavigationController alloc] init];
        }
        
        if (indexPath.row == 0) {
            if (vc1 == nil) {
                vc1 = [[TPMainViewController alloc] init];
            }
            [nav setViewControllers:@[vc1]];
            
            
        } else if (indexPath.row == 1) {
            if (vc2 == nil) {
                vc2 = [[TPProfileViewController.h alloc] init];
            }
            [nav setViewControllers:@[vc2]];
            
            
        } else if (indexPath.row == 2) {
            if (vc3 == nil) {
                vc3 = [[TPAboutViewController alloc] init];
            }
            [nav setViewControllers:@[vc3]];
        }
        
        [self.mm_drawerController setCenterViewController:nav withCloseAnimation:YES completion:nil];
    }];
}

@end
