//
//  ViewController.h
//  Dayh7_mywetherApp
//
//  Created by Student 6 on 30/05/17.
//  Copyright © 2017 Felix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <MapKit/MapKit.h>

#define apiKey @"f3ddfbc548d7aa5b4abfd3a9835ef5f6"
@interface ViewController : UIViewController<CLLocationManagerDelegate,MKMapViewDelegate>
{
    CLLocationManager *locationManager;
}
@property (strong, nonatomic) IBOutlet UILabel *tempLabel;
@property (strong, nonatomic) IBOutlet UILabel *conditionLabel;
@property (strong, nonatomic) IBOutlet UILabel *cityLabel;
- (IBAction)currWeather_Button:(id)sender;

- (IBAction)forecast_Button:(id)sender;

@property NSMutableArray *tempArray,*conditionArray,*cityArray;
@property float latitude,longitude;


@end

