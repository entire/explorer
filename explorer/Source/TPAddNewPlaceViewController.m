//
//  TPAddNewPlaceViewController.m
//  explorer
//
//  Created by Kosuke Hata on 12/19/13.
//  Copyright (c) 2013 topiary. All rights reserved.
//

#import "TPAddNewPlaceViewController.h"
#import <Parse/Parse.h>
#import "TPUserManager.h"
#import "TPLocationManager.h"
#import "TPGeoPointAnnotation.h"
#import "KHButton.h"

@interface TPAddNewPlaceViewController ()

@end

@implementation TPAddNewPlaceViewController
{
    BOOL detailViewIsShowing;
}

- (id)initWithLocation:(CLLocation *)location
{
    self = [super init];
    if (self) {
        self.location = location;
        detailViewIsShowing = NO;
        self.currentAddress = [NSString stringWithFormat:@"..."];
        
        self.labels = @[@"Name",
                        @"Why Visit",
                       @"Street Address",
                       @"City",
                        @"State",
                        @"Postal Code",
                        @"Country"
                       ];
        
        self.placeholders = @[@"Enter Name of place",
                             @"Why it's interesting...",
                             @"Address",
                             @"City",
                             @"State",
                             @"Postal Code",
                             @"Country"
                             ];
    }
    return self;
}

#pragma mark - UIViewController Life Cycle Methods

- (void)loadView
{
    UIView *view = [[UIView alloc] initWithFrame:[KHBase getCurrentCGRect]];
    view.backgroundColor = [UIColor whiteColor];
    
    self.mapView = [[MKMapView alloc] init];
    [self.mapView setFrame: CGRectMake(0, self.barSize+self.y_start, self.width, self.height-self.barSize-self.y_start-self.barSize)];
    [self.mapView setShowsUserLocation:NO];
    [self.mapView setMapType:MKMapTypeStandard];
    [self.mapView setZoomEnabled:YES];
    [self.mapView setScrollEnabled:YES];
    self.mapView.delegate = self;
    [self.mapView setRegion:MKCoordinateRegionMake(self.location.coordinate, MKCoordinateSpanMake(0.005, 0.005)) animated:YES];
    [view addSubview:self.mapView];
    
    CGSize size = CGSizeMake(self.width, self.barSize);
    UIColor *color = [UIColor colorWithRed:0.2 green:0.3 blue:0.4 alpha:1.0];
    self.addButton = [[KHButton alloc] initWithButtonSize:size
                                                withColor:color
                                                withTitle:@"Add Location"];
    self.addButton.frame = CGRectMake(0, self.height-self.barSize, self.width, self.barSize);
    self.addButton.delegate = self;
    [view addSubview:self.addButton];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.barSize+self.y_start+160, 320, 245)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.alpha = 0.0f;
    [view addSubview:self.tableView];
    
    
    self.view = view;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBar.translucent = YES;

    
    UITapGestureRecognizer *singleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture:)];
    singleTapRecognizer.numberOfTapsRequired = 1;
    singleTapRecognizer.numberOfTouchesRequired = 1;
    [self.mapView addGestureRecognizer:singleTapRecognizer];
    
    UITapGestureRecognizer *doubleTapRecognizer = [[UITapGestureRecognizer alloc] init];
    doubleTapRecognizer.numberOfTapsRequired = 2;
    doubleTapRecognizer.numberOfTouchesRequired = 1;
    
    // In order to pass double-taps to the underlying MKMapView the delegate
    // for this recognizer (self) needs to return YES from
    // gestureRecognizer:shouldRecognizeSimultaneouslyWithGestureRecognizer:
    doubleTapRecognizer.delegate = self;
    [self.mapView addGestureRecognizer:doubleTapRecognizer];
    
    // This delays the single-tap recognizer slightly and ensures that it
    // will _not_ fire if there is a double-tap
    [singleTapRecognizer requireGestureRecognizerToFail:doubleTapRecognizer];
    
    
    self.navigationItem.title = @"Tap To Set Location";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"cancel_icon"]
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(clickedCancel:)];
    
    [self findAddress];
    
}

// display a given NSError in an UIAlertView
- (void)displayError:(NSError*)error
{
    dispatch_async(dispatch_get_main_queue(),^ {
        
        NSString *message;
        switch ([error code])
        {
            case kCLErrorGeocodeFoundNoResult: message = @"kCLErrorGeocodeFoundNoResult";
                break;
            case kCLErrorGeocodeCanceled: message = @"kCLErrorGeocodeCanceled";
                break;
            case kCLErrorGeocodeFoundPartialResult: message = @"kCLErrorGeocodeFoundNoResult";
                break;
            default: message = [error description];
                break;
        }
        
        UIAlertView *alert =  [[UIAlertView alloc] initWithTitle:@"An error occurred."
                                                         message:message
                                                        delegate:nil
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil];;
        [alert show];
    });   
}

- (void)viewWillAppear:(BOOL)animated
{
    [self moveAnnotationToCoordinate:self.location.coordinate];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - KHbutton delegate methods

- (void)buttonWasTouchedUpInside:(KHButton *)button
{
    [self closeMapAndOpenDetailView];
}

#pragma mark - Open and Close

- (void)closeMapAndOpenDetailView
{
    detailViewIsShowing = YES;
    
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"checkmark_icon"]
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(clickedOk:)];
    
    [self.navigationItem setRightBarButtonItem: buttonItem animated:YES];
    
    [UIView animateWithDuration:0.3f animations:^{
        self.mapView.frame = CGRectMake(0, self.y_start+self.barSize, self.width, 160);
        self.addButton.alpha = 0.0f;
        self.tableView.alpha = 1.0;
        
        CLLocationDistance distance = 2000;
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(self.annotation.coordinate, distance, distance);
        [self.mapView setRegion:region animated:YES];
        [self.mapView deselectAnnotation:self.annotation animated:NO];
        [self.mapView selectAnnotation:self.annotation animated:NO];
    }];
}

- (void)openMapAndCloseDetailView
{
    detailViewIsShowing = NO;
    [self setEditing:NO animated:YES];
    
    self.navigationItem.rightBarButtonItem = nil;
    
    [UIView animateWithDuration:0.2f animations:^{
        [self.mapView setFrame: CGRectMake(0, self.y_start+self.barSize, self.width, self.height-self.barSize-self.y_start-self.barSize)];
        self.addButton.alpha = 1.0f;
        self.tableView.alpha = 0.0f;
    }];
}

#pragma mark - UITouch Methods

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchLocation = [touch locationInView:self.mapView];
    
    for (UIView *view in self.view.subviews)
    {
        if ([view isKindOfClass:[MKMapView class]] && CGRectContainsPoint(self.mapView.frame, touchLocation))
        {
            if (detailViewIsShowing) {
                [self openMapAndCloseDetailView];
            }
        }
    }
}

#pragma mark - address finding methods

- (void)findAddress
{
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:self.location completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error){
            NSLog(@"Geocode failed with error: %@", error);
            [self displayError:error];
            return;
        }
        CLPlacemark *placemark = placemarks[0];
        NSLog(@"%@", placemark.addressDictionary);
        self.currentAddress = placemark.addressDictionary[@"Street"];
        self.currentZIP = placemark.addressDictionary[@"ZIP"];
        self.currentCity = placemark.addressDictionary[@"City"];
        self.currentState = placemark.addressDictionary[@"State"];
        self.currentCountry = placemark.addressDictionary[@"Country"];
        
        [self.tableView reloadData];
    }];
}

#pragma mark - target action methods

- (void)clickedCancel:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)clickedOk:(id)sender
{
    NSLog(@"ok!");
    
    NSIndexPath *namePath = [NSIndexPath indexPathForRow:0 inSection:0];
    NSIndexPath *whyPath = [NSIndexPath indexPathForRow:1 inSection:0];
    NSIndexPath *addressPath = [NSIndexPath indexPathForRow:2 inSection:0];
    NSIndexPath *citypath = [NSIndexPath indexPathForRow:3 inSection:0];
    NSIndexPath *statePath = [NSIndexPath indexPathForRow:4 inSection:0];
    NSIndexPath *codePath = [NSIndexPath indexPathForRow:4 inSection:0];
    NSIndexPath *countryPath = [NSIndexPath indexPathForRow:4 inSection:0];
    
    ELCTextFieldCell *nameCell = (ELCTextFieldCell*)[self.tableView cellForRowAtIndexPath:namePath];
    ELCTextFieldCell *whyCell = (ELCTextFieldCell*)[self.tableView cellForRowAtIndexPath:whyPath];
    ELCTextFieldCell *addCell = (ELCTextFieldCell*)[self.tableView cellForRowAtIndexPath:addressPath];
    ELCTextFieldCell *cityCell = (ELCTextFieldCell*)[self.tableView cellForRowAtIndexPath:citypath];
    ELCTextFieldCell *stateCell = (ELCTextFieldCell*)[self.tableView cellForRowAtIndexPath:statePath];
    ELCTextFieldCell *codeCell = (ELCTextFieldCell*)[self.tableView cellForRowAtIndexPath:codePath];
    ELCTextFieldCell *countCell = (ELCTextFieldCell*)[self.tableView cellForRowAtIndexPath:countryPath];
    
    self.nameOfPlace = nameCell.rightTextField.text;
    self.whyInteresting = whyCell.rightTextField.text;
    self.currentAddress = addCell.rightTextField.text;
    self.currentCity = cityCell.rightTextField.text;
    self.currentState = stateCell.rightTextField.text;
    self.currentZIP = codeCell.rightTextField.text;
    self.currentCountry = countCell.rightTextField.text;
    
    PFACL *ACL = [PFACL ACL];
    [ACL setWriteAccess:YES forUser:[PFUser currentUser]];
    [ACL setReadAccess:YES forUser:[PFUser currentUser]];
    [ACL setPublicReadAccess:YES];
    [ACL setPublicWriteAccess:YES];
    
	// Configure the new event with information from the location.
	CLLocationCoordinate2D coordinate = self.annotation.coordinate;
    
    PFGeoPoint *geoPoint = [PFGeoPoint geoPointWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    PFObject *object = [PFObject objectWithClassName:@"Places"];
    [object setObject:geoPoint forKey:@"location"];
    [object setObject:[PFUser currentUser] forKey:@"user"];
    
    [object setObject:self.nameOfPlace forKey:@"nameOfPlace"];
    [object setObject:self.whyInteresting forKey:@"reasonToVisit"];
    [object setObject:self.currentAddress forKey:@"address"];
    [object setObject:self.currentCity forKey:@"city"];
    [object setObject:self.currentState forKey:@"state"];
    [object setObject:self.currentZIP forKey:@"postalcode"];
    [object setObject:self.currentCountry forKey:@"country"];
    
    
    [object setACL:ACL];
    
    [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            PFUser *user = [PFUser currentUser];
            PFRelation *relation = [user relationforKey:@"Places"];
            [relation addObject:object];
            
            NSString *tag = object.objectId;
            TPGeoPointAnnotation *annotation = [[TPGeoPointAnnotation alloc] initWithObject:object andUsername:user.username andTag:tag];
            [self.delegate userClickedOk:annotation];
            
            [self dismissViewControllerAnimated:YES completion:^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [user saveInBackground];
                });
            }];
        }
    }];
}

#pragma mark - Annotation related methods

- (void)moveAnnotationToCoordinate:(CLLocationCoordinate2D)coordinate
{
    NSLog(@"move!");
    if (self.annotation) {
        [UIView beginAnimations:[NSString stringWithFormat:@"slideannotation%@", self.annotation] context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        [UIView setAnimationDuration:0.2];
        
        self.annotation.coordinate = coordinate;

        NSLog(@"%f, %f", coordinate.latitude, coordinate.longitude);
        
        self.location = [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
        [UIView commitAnimations];
        [self findAddress];
        
    } else {
        NSLog(@"new!");
        self.annotation = [[MKPointAnnotation alloc] init];
        self.annotation.coordinate = self.location.coordinate;
        
        [self.mapView addAnnotation:self.annotation];
    }
}


#pragma mark UIGestureRecognizerDelegate methods

/**
 Asks the delegate if two gesture recognizers should be allowed to recognize gestures simultaneously.
 */
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    // Returning YES ensures that double-tap gestures propogate to the MKMapView
    return YES;
}

#pragma mark UIGestureRecognizer handlers

- (void)handleSingleTapGesture:(UIGestureRecognizer *)gestureRecognizer
{
    if (!detailViewIsShowing) {
        if (gestureRecognizer.state != UIGestureRecognizerStateEnded)
        {
            return;
        }
        
        CGPoint touchPoint = [gestureRecognizer locationInView:self.mapView];
        [self moveAnnotationToCoordinate:[self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView]];
    }
}

#pragma mark - MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if (![annotation isKindOfClass:[MKUserLocation class]]) {

        MKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"DragAnnotationView"];
        
        if (!annotationView) {
            annotationView = [[TPDragAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"DragAnnotationView"];
        }
        
        ((TPDragAnnotationView *)annotationView).delegate = self;
        ((TPDragAnnotationView *)annotationView).mapView = self.mapView;
        
        return annotationView;
        
    } else {
        return nil;
    }
}

#pragma mark - stuff that needs to be moved

- (void)userClickedOk:(TPGeoPointAnnotation *)annotation
{

}

#pragma mark - TPDragAnnotationView delegate

- (void)movedAnnotation:(MKPointAnnotation *)annotation
{
    NSLog(@"Dragged annotation to %f,%f", annotation.coordinate.latitude, annotation.coordinate.longitude);
    [self findAddress];
}

#pragma mark - BCNewPlaceDetailViewController delegate methods

- (void)userHadSelectedLocation:(CLLocation *)location
{
    self.location = location;
}

#pragma mark - UITableViewCell Data Source Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.labels.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 35.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellID = @"CellID";
    
    
    ELCTextFieldCell *cell = (ELCTextFieldCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[ELCTextFieldCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:cellID];
    }
	cell.delegate = self;
	[self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(ELCTextFieldCell *)cell atIndexPath:(NSIndexPath *)indexPath {
	
	cell.leftLabel.text = [self.labels objectAtIndex:indexPath.row];
	cell.rightTextField.placeholder = [self.placeholders objectAtIndex:indexPath.row];
    cell.rightTextField.font = [UIFont systemFontOfSize:14];
    cell.rightTextField.tag = indexPath.row;
	cell.indexPath = indexPath;

    //Disables UITableViewCell from accidentally becoming selected.
    cell.selectionStyle = UITableViewCellEditingStyleNone;
    
    if (indexPath.row == 2) {
        cell.rightTextField.text = self.currentAddress;
    } else if (indexPath.row == 3) {
        cell.rightTextField.text = self.currentCity;
    } else if (indexPath.row == 4) {
        cell.rightTextField.text = self.currentState;
    } else if (indexPath.row == 5) {
        cell.rightTextField.text = self.currentZIP;
    } else if (indexPath.row == 6) {
        cell.rightTextField.text = self.currentCountry;
    }
}

#pragma mark - UITableView Delegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark ELCTextFieldCellDelegate Methods

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    ELCTextFieldCell *textFieldCell = (ELCTextFieldCell*)textField.superview;
    if (![textFieldCell isKindOfClass:ELCTextFieldCell.class]) {
        return;
    }
    //It's a better method to get the indexPath like this, in case you are rearranging / removing / adding rows,
    //the set indexPath wouldn't change
    NSIndexPath *indexPath = [self.tableView indexPathForCell:textFieldCell];
	if(indexPath != nil && indexPath.row < [self.labels count]-1) {
		NSIndexPath *path = [NSIndexPath indexPathForRow:indexPath.row+1 inSection:indexPath.section];
		[[(ELCTextFieldCell*)[self.tableView cellForRowAtIndexPath:path] rightTextField] becomeFirstResponder];
		[self.tableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionTop animated:YES];
	}
	else {
		[[(ELCTextFieldCell*)[self.tableView cellForRowAtIndexPath:indexPath] rightTextField] resignFirstResponder];
	}
    
}

- (void)textFieldCell:(ELCTextFieldCell *)inCell updateTextLabelAtIndexPath:(NSIndexPath *)indexPath string:(NSString *)string {

}


@end
