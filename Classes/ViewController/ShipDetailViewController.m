//
//  ShipDetailViewController.m
//  MapLayerDemo
//
//  Created by 老王八 :D on 12-6-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ShipDetailViewController.h"
//#import "ShipData.h"
//#import <MapKit/MapKit.h>
//#import "AppDelegate.h"
//#import "ShipDetailFocused.h"
//#import "Util.h"
//#import "JSONKit.h"
@implementation ShipDetailViewController
@synthesize focusButton;
@synthesize shipdict;
@synthesize baseData;
-(void)showShip
{
//    double lat = [[shipdict objectForKey:@"lat"] floatValue];
//    double lon = [[shipdict objectForKey:@"lon"] floatValue];
//    CLLocationCoordinate2D coord = 
//        CLLocationCoordinate2DMake(lat, lon);
//    AppDelegate *delegate = [AppDelegate getAppDelegate];
//    delegate.coord = coord;
//    delegate.showShip = YES;
    ApplicationDelegate.seletedShip = shipdict;
    ApplicationDelegate.tabBarController.selectedIndex = 0;
//    delegate.tabBarController.selectedIndex = 0;
}
-(id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        UIBarButtonItem *jumpButton = [[UIBarButtonItem alloc] initWithTitle:@"定位" style:UIBarButtonItemStylePlain target:self action:@selector(showShip)];
        self.navigationItem.rightBarButtonItem = jumpButton;
        [jumpButton release];
        self.title = @"详细信息";
    }
    return self;
}
-(id) initWithNibName:(NSString *)nibNameOrNil
{
    return [super initWithNibName:nibNameOrNil bundle:nil];
}
-(void)showButtonTitle{
    focusButton.frame = CGRectMake(230, 300, 80, 40);
    [focusButton setTitle:@"test" forState:UIControlStateNormal];
    [focusButton setTitle:@"test" forState:UIControlStateHighlighted];
    if(!isFocused){
        //        self.focusButton.titleLabel.text = @"关注";
        [focusButton setTitle:@"关注" forState:UIControlStateNormal];
    }else{
        //        self.focusButton.titleLabel.text = @"";
        [focusButton setTitle:@"取消关注" forState:UIControlStateNormal];
    }
}

-(void)alertFocusMessage:(NSString *)returnData{
    NSString *message = @"";
    isFocused = !isFocused;
    if(returnData != nil && [returnData isEqualToString:@"1"]){
        message = @"成功";
        [self showButtonTitle];
        [Util getAttentionShipFullInfo:[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"] onComp:^(NSObject *responseData) {
            if (responseData != nil) {
                ApplicationDelegate.myFocusShips = [[NSMutableArray alloc] initWithArray:(NSArray*)responseData];
            }
        }];
        
    }else{
        message = @"失败";
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"操作%@",message]  delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
}

- (IBAction)focusButtonPress:(UIButton *)sender {
    NSDictionary *returnDic = [[[NSDictionary alloc] init ] autorelease];
    
    
   // __block NSString  *returnData = @"";

    if(isFocused){
        [Util delAttentionShip:[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]  shipId:[shipdict objectForKey:@"shipid"] onComp:^(NSObject *responseData) {
            
            [self alertFocusMessage:(NSString *)responseData];
        }];
    }else{
        [Util addAttentionShip:[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]  shipId:[shipdict objectForKey:@"shipid"] onComp:^(NSObject *responseData) {
            [self alertFocusMessage:(NSString *)responseData];

        }];
    }
 
    
//    if(isFocused){
//        returnDic = [Util delAttentionShip:[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]  shipId:[shipdict objectForKey:@"shipid"]];
//    }else{
//        returnDic = [Util addAttentionShip:[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]  shipId:[shipdict objectForKey:@"shipid"]];
//    }
//    isFocused = !isFocused;
//
//    NSString *message = @"";
//    if([returnDic objectForKey:@"return"] != nil && [[returnDic objectForKey:@"return"] isEqual:@"1"]){
//        message = @"成功";
//        [self showButtonTitle];
//        NSDictionary *shipsDictionary = [Util getAttentionShip:[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]];
//        NSMutableArray *shipsArray = [shipsDictionary objectForKey:@"return"];
//        [AppDelegate getAppDelegate].myFocusShips = shipsArray;
//    }else {
//        message = @"失败";
//    }
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"操作%@",message]  delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//    [alert show];
//    [alert release];
}

#pragma mark - View Delegate
- (void)viewDidLoad
{
    NSArray *myfocus = [AppDelegate getMyFocusShips];
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"shipname contains[cd] %@", [shipdict objectForKey:@"shipname"]];
    NSArray *isFocusArray = [myfocus filteredArrayUsingPredicate:resultPredicate];
    if(isFocusArray == nil || isFocusArray.count == 0){
        isFocused = false;
    }else{
        isFocused = true;
    }
    [self showButtonTitle];

    //self.shipfocused = [AppDelegate getMyFavArray];
//    [self saveShipDetailFocused:[shipdict objectForKey:@"shipname"]];
    // genarate label
    NSString *leftCaps[] = {
        @"中文船名:",
        @"英文船名:",
        @"船舶类型:",
        @"船籍:",
        @"船长(米):",
        @"船宽(米):",
        @"时间:",
        @"纬度:",
        @"经度:",
        @"航速(节):",
        @"航向:",
        @"平均速度:",
        @"最后距离(海里):"
    };
   // NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
   // [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
   // NSString *gpsTime;
    NSString *leftData[] = {
        [shipdict objectForKey:@"shipnamecn"],
        [shipdict objectForKey:@"shipname"],
        [shipdict objectForKey:@"shiptype"],
        @"/",
        [NSString stringWithFormat:@"%d",[[shipdict objectForKey:@"shiplength"] intValue]],
        [NSString stringWithFormat:@"%d",[[shipdict objectForKey:@"shipwidth"] intValue]],
        [shipdict objectForKey:@"gpstime"],
        [shipdict objectForKey:@"longitude"],
        [shipdict objectForKey:@"latitude"],
        [NSString stringWithFormat:@"%@",[shipdict objectForKey:@"speed"]],
        [NSString stringWithFormat:@"%@",[shipdict objectForKey:@"direction"]],
        [NSString stringWithFormat:@"%.1f",[[shipdict objectForKey:@"averagespeed"] floatValue]],
        [NSString stringWithFormat:@"%.1f",[[shipdict objectForKey:@"distanceMoved"] floatValue]]
    };
//    NSLog(@"%f,%d,%u",[shipdict objectForKey:@"distanceMoved"],[shipdict objectForKey:@"distanceMoved"],[shipdict objectForKey:@"distanceMoved"]);
    NSString *rightCaps[] = {
        @"MMSI:",
        @"IMO:",
        @"呼号:"
    };

    NSString *rightData[] = {
        [NSString stringWithFormat:@"%d",[[shipdict objectForKey:@"mmsi"] intValue]],
        [NSString stringWithFormat:@"%d",[[shipdict objectForKey:@"imo"] intValue]],
        [shipdict objectForKey:@"callsign"]
    };
    
    int lCount = 13;
    for (int i = 0; i < lCount; i++) {
        UILabel *label;
        if (i == lCount - 1) {
            label = [[UILabel alloc] initWithFrame:CGRectMake(5, 5 + i * 28, 103, 21)];
        } else {
            label = [[UILabel alloc] initWithFrame:CGRectMake(5, 5 + i * 28, 64, 21)];
        }
        label.font = [UIFont systemFontOfSize:14];
        label.textAlignment = UITextAlignmentRight;
        label.text = leftCaps[i];
        [self.view addSubview:label];
        [label release];
        
        if (i <= 1) {
            // name field
            label = [[UILabel alloc] initWithFrame:CGRectMake(77, 5 + i * 28, 200, 21)];
        } else if (i < lCount - 1) {
            label = [[UILabel alloc] initWithFrame:CGRectMake(77, 5 + i * 28, 150, 21)];
        } else {
            label = [[UILabel alloc] initWithFrame:CGRectMake(116, 5 + i * 28, 150, 21)];
        }
        label.font = [UIFont systemFontOfSize:14];
        label.text = leftData[i];
        [self.view addSubview:label];
        [label release];
    }
    
    int rCount = 3;
    for (int i = 0; i < rCount; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(165, 61 + i * 28, 42, 21)];
        label.font = [UIFont systemFontOfSize:14];
        label.textAlignment = UITextAlignmentRight;
        label.text = rightCaps[i];
        [self.view addSubview:label];
        [label release];
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(215, 61 + i * 28, 100, 21)];
        label.font = [UIFont systemFontOfSize:14];
        label.text = rightData[i];
        [self.view addSubview:label];
        [label release];
    }
}
-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.navigationController popViewControllerAnimated:NO];
}
//-(void)viewWillAppear:(BOOL)animated{
//       // [self saveShipDetailFocused:baseData.shipName];
//}


//-(void)saveShipDetailFocused:(NSString*) shipName  {
//        NSDictionary *detailDictionary = [Util getAisShipFullInfoByShipId:baseData.mobileId];
//
//        if(detailDictionary != nil ){
//
//            ShipData *dataTmp = [[[ShipData alloc] init] autorelease];
//        
//            self.baseData = [dataTmp retain];
//    }
//}


//- (void)saveContext:(NSManagedObjectContext*) managedObjectContext
//{
//    NSError *error = nil;
//    // NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
//    if (managedObjectContext != nil)
//    {
//        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error])
//        {
//            /*
//             Replace this implementation with code to handle the error appropriately.
//             
//             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
//             */
//            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//            abort();
//        }else{
//            
//        }
//    }
//}


#pragma mark -
- (void)dealloc {
   // [shipfocused release];
   // shipfocused = nil;
    [focusButton removeFromSuperview];
    [focusButton release];
    focusButton = nil;
    [super dealloc];
}
//- (void)viewDidUnload {
//    [self setFocusButton:nil];
//    [super viewDidUnload];
//}
@end
