//
//  secondViewController.h
//  Dayh7_mywetherApp
//
//  Created by Student 6 on 30/05/17.
//  Copyright © 2017 Felix. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface secondViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *myTableView;

@property float latitude,longitude;
@property NSString *ApiKey;

@property NSMutableArray *tempArray;
@property NSMutableArray *dayArray;
@property NSMutableArray *cloudArray;
@property NSString *cityName;
@end
