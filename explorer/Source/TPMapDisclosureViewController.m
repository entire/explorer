//
//  TPMapDisclosureViewController.m
//  explorer
//
//  Created by Kosuke Hata on 12/23/13.
//  Copyright (c) 2013 topiary. All rights reserved.
//

#import "TPMapDisclosureViewController.h"
#import <Parse/Parse.h>
#import "TPGeoPointAnnotation.h"

@interface TPMapDisclosureViewController ()

@end

@implementation TPMapDisclosureViewController


- (id)initWithObject:(PFObject *)object
{
    self = [super init];
    if (self) {
        self.selectedObject = object;
        
        PFGeoPoint *point = object[@"location"];
        self.location = [[CLLocation alloc] initWithLatitude:point.latitude longitude:point.longitude];
        
        self.labels = @[@"Name",
                        @"Why Visit",
                        @"Address",
                        @"City",
                        @"State",
                        @"Postal Code",
                        @"Country"
                        ];
        
        self.placeholders = @[
                              object[@"nameOfPlace"],
                              object[@"reasonToVisit"],
                              object[@"address"],
                              object[@"city"],
                              object[@"state"],
                              object[@"postalcode"],
                              object[@"country"]
                              ];

        
    }
    return self;
}

- (void)loadView
{
    UIView *view = [[UIView alloc] initWithFrame:[KHBase getCurrentCGRect]];
    view.backgroundColor = [UIColor whiteColor];
    
    self.view = view;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"Location";
	// Do any additional setup after loading the view.
    
    CGSize size = CGSizeMake(self.width, self.barSize);
    UIColor *color = [UIColor colorWithRed:0.2 green:0.3 blue:0.4 alpha:1.0];
    KHButton *button = [[KHButton alloc] initWithButtonSize:size
                                                  withColor:color
                                                  withTitle:@"delete!"];
    button.frame = CGRectMake(0, self.height-self.barSize, self.width, self.barSize);
    button.delegate = self;
    
    //    [self.view addSubview:button];
    
    self.mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, self.y_start+self.barSize, 320, 160)];
    [self.mapView setShowsUserLocation:NO];
    [self.mapView setMapType:MKMapTypeHybrid];
    [self.mapView setZoomEnabled:YES];
    [self.mapView setScrollEnabled:YES];
    self.mapView.delegate = self;
    [self.mapView setRegion:MKCoordinateRegionMake(self.location.coordinate, MKCoordinateSpanMake(0.001, 0.001)) animated:YES];
    [self.view addSubview:self.mapView];

    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    [annotation setCoordinate:self.location.coordinate];
    [self.mapView addAnnotation:annotation];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.y_start+self.barSize+160, 320, 245)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorColor = [UIColor clearColor];
    [self.view addSubview:self.tableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)buttonWasTouchedUpInside:(KHButton *)button
{
    
}

#pragma mark - UITableViewCell Data Source Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.placeholders.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellID = @"CellID";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:cellID];
    }
    
    cell.textLabel.text = self.labels[indexPath.row];
    cell.detailTextLabel.text = self.placeholders[indexPath.row];
    cell.detailTextLabel.numberOfLines = 0;
    
    return cell;
}

#pragma mark - UITableView Delegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

@end
