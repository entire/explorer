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
                       @"Address",
                       @"Phone Number"
                       ];
        
        self.placeholders = @[@"Enter Name of place",
                             @"looking up current address...",
                             @"Phone Number (Optional)"
                             ];
    }
    return self;
}

#pragma mark - UIViewController Life Cycle Methods

- (void)loadView
{
    UIView *view = [[UIView alloc] initWithFrame:[KHBase getCurrentCGRect]];
    
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
                                                withTitle:@"Add Meeting"];
    self.addButton.frame = CGRectMake(0, self.height-self.barSize, self.width, self.barSize);
    self.addButton.delegate = self;
    [self.view addSubview:self.addButton];

    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.barSize+160, 320, self.height-self.barSize-160)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.alpha = 0.0f;
    [self.view addSubview:self.tableView];
    
    self.view = view;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
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

#pragma mark - khbutton delegate

- (void)buttonWasTouchedUpInside:(KHButton *)button
{
    [self closeMapAndOpenDetailView];
}

- (void)closeMapAndOpenDetailView
{
    detailViewIsShowing = YES;
    
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"checkmark_icon"]
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(clickedOk:)];
    
    [self.navigationItem setRightBarButtonItem: buttonItem animated:YES];
    
    [UIView animateWithDuration:0.3f animations:^{
        self.mapView.frame = CGRectMake(0, self.barSize, self.width, 160);
        self.addButton.frame = CGRectMake(0, self.height, self.width, self.barSize);
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
    
    self.navigationItem.rightBarButtonItem = nil;
    
    [UIView animateWithDuration:0.2f animations:^{
        [self.mapView setFrame: CGRectMake(0, self.barSize+self.y_start, self.width, self.height-self.barSize-self.y_start-self.barSize)];
        self.addButton.frame = CGRectMake(0, self.height-self.barSize, self.width, self.barSize);
        self.tableView.alpha = 0.0;
    }];
}

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
        
        NSString *street = placemark.addressDictionary[@"Street"];
        NSString *zip = placemark.addressDictionary[@"ZIP"];
        NSString *city = placemark.addressDictionary[@"City"];
        NSString *state = placemark.addressDictionary[@"State"];
        NSString *country = placemark.addressDictionary[@"Country"];
        
        self.currentAddress = [NSString stringWithFormat:@"%@, %@, %@, %@, %@", street, city, state, zip, country];
        
        
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
    
    [[TPLocationManager sharedLocation] pushLocationToServer:self.location
                                              withCompletion:^(CLLocation *yourLocaiton, PFObject *object) {
                                                  
                                                  PFUser *holder = object[@"user"];
                                                  NSString *objectId = holder.objectId;
                                                  PFUser *user = [[TPUserManager sharedStore] getUserFromLocal:objectId];
                                                  
                                                  TPGeoPointAnnotation *annotation = [[TPGeoPointAnnotation alloc] initWithObject:object andUsername:user.username];
                                                  
                                                  if ([self.delegate respondsToSelector:@selector(userClickedOk:)]) {
                                                      [self.delegate userClickedOk:annotation];
                                                      [self dismissViewControllerAnimated:YES completion:nil];
                                                  }
                                              }];
}


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
    return 55.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellID = @"CellID";
    
    
    ELCTextFieldCell *cell = (ELCTextFieldCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[ELCTextFieldCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:cellID];
    }
	
	[self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(ELCTextFieldCell *)cell atIndexPath:(NSIndexPath *)indexPath {
	
	cell.leftLabel.text = [self.labels objectAtIndex:indexPath.row];
	cell.rightTextField.placeholder = [self.placeholders objectAtIndex:indexPath.row];
    cell.rightTextField.font = [UIFont systemFontOfSize:10];
	cell.indexPath = indexPath;
	cell.delegate = self;
    //Disables UITableViewCell from accidentally becoming selected.
    cell.selectionStyle = UITableViewCellEditingStyleNone;
    
    if (indexPath.row == 1) {
        cell.rightTextField.text = self.currentAddress;
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
