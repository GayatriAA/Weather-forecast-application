//
//  ViewController.m
//  Dayh7_mywetherApp
//
//  Created by Student 6 on 30/05/17.
//  Copyright © 2017 Felix. All rights reserved.
//

#import "ViewController.h"
#import "secondViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tempArray=[[NSMutableArray alloc]init];
}
-(void)startLocating
{
    locationManager=[[CLLocationManager alloc]init];
    locationManager.delegate=self;
    [locationManager requestWhenInUseAuthorization];
    [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    [locationManager startUpdatingLocation];
}
-(void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    CLLocation *currentLocation=locations.lastObject;
    self.latitude=currentLocation.coordinate.latitude;
    self.longitude=currentLocation.coordinate.longitude;
    NSLog(@"Latitude %f Longitude %f", self.latitude,self.longitude);
    if (currentLocation!=NULL)
    {
        [self getCurrentWeatherDataWithlatitude:self.latitude andLongitude:self.longitude andApiKey:apiKey];
        [locationManager stopUpdatingLocation];
    }
}
-(void)getCurrentWeatherDataWithlatitude:(double)latitude andLongitude:(double)longitude andApiKey:(NSString *)key
{
    NSString *urlString=[NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/weather?lat=%f&lon=%f&appid=%@",latitude,longitude,apiKey];
    NSURL *url=[[NSURL alloc]initWithString:urlString];
    NSURLSession *session=[NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLSessionDataTask *dataTask=[session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSHTTPURLResponse *myresponse=(NSHTTPURLResponse *)response;
        if (myresponse.statusCode==200)
        {
            if(data)
            {
                 NSDictionary *outerDic=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
                if(error)
                {
                    NSLog(@"Error %@",error.localizedDescription);
                }
                else
                {
                    [self performSelectorOnMainThread:@selector(updateUI:) withObject:outerDic waitUntilDone:NO];
                }
            }
            else
            {
                NSLog(@"Data not available");
            }
        }
        else
        {
            NSLog(@"Response Failed");
        }
    }];
    [dataTask resume];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)updateUI:(NSDictionary *)dict
{
    NSLog(@"Dict %@",dict);
    NSDictionary *mainDict=[dict valueForKey:@"main"];
    NSString *temp=[mainDict valueForKey:@"temp"];
    NSLog(@"Temp %@",temp);
    NSString *t=[NSString stringWithFormat:@"%@",temp];
    [self.tempLabel setText:t];
    
    
    NSString *name=[dict valueForKey:@"name"];
    NSLog(@"City %@",name);
    [self.cityLabel setText:name];
    NSArray *cloudArray=[dict valueForKey:@"weather"];
    for(NSDictionary *clouds in cloudArray)
    {
        NSString *c=[clouds valueForKey:@"description"];
        //NSString *Cl=[NSString stringWithFormat:@"%@",c];
        [self.conditionLabel setText:c];
        NSLog(@"Clouds %@",clouds);
    }

}
- (IBAction)currWeather_Button:(id)sender
{
    [self startLocating];
}
    - (IBAction)forecast_Button:(id)sender
{
    secondViewController *svc=[self.storyboard instantiateViewControllerWithIdentifier:@"secondViewController"];
    svc.latitude=self.latitude;
    svc.longitude=self.longitude;
    svc.ApiKey=apiKey;
    
    [self.navigationController pushViewController:svc animated:NO];
    
    

}
@end
