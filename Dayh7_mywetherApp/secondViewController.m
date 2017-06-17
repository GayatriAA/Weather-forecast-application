//
//  secondViewController.m
//  Dayh7_mywetherApp
//
//  Created by Student 6 on 30/05/17.
//  Copyright © 2017 Felix. All rights reserved.
//

#import "secondViewController.h"

@interface secondViewController ()

@end

@implementation secondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tempArray=[[NSMutableArray alloc]init];
    self.cloudArray=[[NSMutableArray alloc]init];
    NSLog(@"Latitude %f",self.latitude);
    
    [self getCurrentWeatherDataWithLatitude:self.latitude andLongitude:self.longitude apiKKey:self.ApiKey];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tempArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"mycell"];
    cell.textLabel.text=[self.tempArray objectAtIndex:indexPath.row];
    cell.detailTextLabel.text=[self.cloudArray objectAtIndex:indexPath.row];
    return cell;
}
-(void)getCurrentWeatherDataWithLatitude:(double)latitude andLongitude:(double)longitude apiKKey:(NSString *)keey
{
    NSString *urlString=[NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/forecast/daily?lat=%f&lon=%f&cnt=15&appid=%@",latitude,longitude,keey];
    NSURL *url=[[NSURL alloc]initWithString:urlString];
    NSURLSession *session=[NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        NSURLSessionDataTask *dataTask=[session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
           
            NSHTTPURLResponse *myResponse=(NSHTTPURLResponse *)response;
            if (myResponse.statusCode==200) {
                
                if(data)
                {
                    NSDictionary *outerDic=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
                    if (error)
                    {
                        NSLog(@"Error %@",error.localizedDescription);
                    } else
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
-(void)updateUI:(NSDictionary *)dict
{
    NSDictionary *city=[dict valueForKey:@"city"];
    self.cityName=[city valueForKey:@"name"];
    
    NSArray *listAray=[dict valueForKey:@"list"];
    
    for (NSDictionary *list in listAray)
    {
        NSString *minTemp=@"Min=";
        NSString *maxTemp=@"Max";
        
        NSDictionary *temp=[list valueForKey:@"temp"];
        
        NSString *min=[temp valueForKey:@"min"];
        min=[NSString stringWithFormat:@"%@",min];
        
        minTemp=[minTemp stringByAppendingString:min];
        
        NSString *max=[temp valueForKey:@"max"];
        max=[NSString stringWithFormat:@"%@",max];
        
        maxTemp=[maxTemp stringByAppendingString:max];
        
        NSString *tempp=[minTemp stringByAppendingString:maxTemp];
        [self.tempArray addObject: tempp];
        NSLog(@"Temp %@",self.tempArray);
        
        NSArray *weatherArray =[list valueForKey:@"weather"];
        for (NSDictionary *weather in weatherArray)
        {
            NSString *description=[weather valueForKey:@"description"];
            [self.cloudArray addObject:description];
            NSLog(@"Cloud %@",self.cloudArray);

        }
        [self.myTableView reloadData];
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
