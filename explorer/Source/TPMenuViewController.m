//
//  TPMenuViewController.m
//  explorer
//
//  Created by Kosuke Hata on 12/9/13.
//  Copyright (c) 2013 topiary. All rights reserved.
//

#import "TPMenuViewController.h"
#import "UIColor+addVeryLightGray.h"
#import "KHButton.h"
#import "TPProfileViewController.h"
#import "TPAboutViewController.h"
#import "TPMainViewController.h"
#import "UIViewController+MMDrawerController.h"

@interface TPMenuViewController ()

@end

@implementation TPMenuViewController
{
    NSArray *titles;
    NSArray *images;
    
    UINavigationController *nav;
    TPMainViewController *vc1;
    TPProfileViewController *vc2;
    TPAboutViewController *vc3;
}

- (void)loadView
{
    //programtically make things happen
    CGRect rect = [KHBase getCurrentCGRect];
    UIView *view = [[UIView alloc] initWithFrame:rect];
    view.backgroundColor = [UIColor whiteColor];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height-self.barSize)];
    tableView.separatorColor = [UIColor whiteColor];
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.scrollEnabled = NO;
    tableView.showsVerticalScrollIndicator = NO;
    [view addSubview:tableView];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.width, self.y_start+self.barSize)];
    headerView.backgroundColor = [UIColor whiteColor];
    tableView.tableHeaderView = headerView;
    
    
    self.view = view;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    // Do any additional setup after loading the view.
    titles = @[@"Map",@"Everyone",@"About"];
    
    UIImage *img1 = [UIImage imageNamed:@"map"];
    UIImage *img2 = [UIImage imageNamed:@"users"];
    UIImage *img3 = [UIImage imageNamed:@"about"];
    images = @[img1, img2, img3];
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
    cell.imageView.image = images[indexPath.row];
    
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
                vc2 = [[TPProfileViewController alloc] init];
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
