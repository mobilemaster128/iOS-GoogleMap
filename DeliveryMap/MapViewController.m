//
//  ViewController.m
//  DeliveryMap
//
//  Created by Apple on 8/16/16.
//  Copyright © 2016 LixueLixueWeb. All rights reserved.
//

#import "MapViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <GoogleMaps/GoogleMaps.h>
//@import MapKit;

@interface MapViewController ()<CLLocationManagerDelegate>{
    CLLocationManager *locationManager;
    CLLocation *currentLocation;
    CLLocationCoordinate2D targetLocation;
    GMSMapView *mapView;
    GMSMarker *targetMarker;
}

@end

@implementation MapViewController {
    
}

- (void)initLocationManager {
    // Location Manager create
    locationManager = [[CLLocationManager alloc] init];
    
    // Location Receiver delegate
    locationManager.delegate = self;
    
    locationManager.pausesLocationUpdatesAutomatically = false;
    locationManager.allowsBackgroundLocationUpdates = true;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    [locationManager allowDeferredLocationUpdatesUntilTraveled:CLLocationDistanceMax timeout:5];
    
    /*if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [locationManager requestWhenInUseAuthorization];
    }*/
    
    if ([locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
     [locationManager requestAlwaysAuthorization];
    }
    
    // Location Manager
    [locationManager startUpdatingLocation];
    //[locationManager startMonitoringSignificantLocationChanges];
}

-(void)loadMap {
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithTarget:targetLocation zoom:13];
    mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView.myLocationEnabled = YES;
    mapView.mapType = kGMSTypeSatellite;
    self.view = mapView;
}

- (void)loadView {
    targetLocation = CLLocationCoordinate2DMake(49.282051, -123.119823);
    [self initLocationManager];
    [self loadMap];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    targetMarker = [[GMSMarker alloc] init];
    targetMarker.position = targetLocation;
    targetMarker.title = @"target";
    targetMarker.snippet = @"destination";
    targetMarker.map = mapView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    currentLocation = [locations lastObject];
    [mapView animateToLocation:currentLocation.coordinate];
    NSLog(@"%@", currentLocation);
}


@end
