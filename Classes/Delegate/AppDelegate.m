//
//  mycompAppDelegate.m
//  Chuanbao
//
//  Created by 老王八 :D on 12-6-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "GMapViewController.h"
#import "MyTeamViewController.h"
#import "SettingsViewController.h"
#import "SimpleTableViewController.h"
#import "ShipData.h"
#import "ShipDetailFocused.h"
#import "LoginViewController.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize tabBarController = _tabBarController;
@synthesize myfav;
@synthesize shipMajor;
@synthesize coord, showShip;
@synthesize managedObjectContext;
@synthesize persistentStoreCoordinator ;
@synthesize managedObjectModel ;
@synthesize myFocusShips;
@synthesize myShipsTeam;
@synthesize imageDownloader;
+ (AppDelegate *)getAppDelegate {
    return (AppDelegate *) [[UIApplication sharedApplication] delegate];
}
+ (NSMutableArray *)getMyFavArray {
    return ((AppDelegate *) [[UIApplication sharedApplication] delegate]).myfav;
}
+ (NSMutableArray *)getShipMajor {
    return ((AppDelegate *) [[UIApplication sharedApplication] delegate]).shipMajor;
}
+ (NSMutableArray *)getMyFocusShips {
    return ((AppDelegate *) [[UIApplication sharedApplication] delegate]).myFocusShips;
}
+ (NSMutableArray *)getMyShipsTeam {
    return ((AppDelegate *) [[UIApplication sharedApplication] delegate]).myShipsTeam;
}
+ (NSManagedObjectContext *)getManagedObjectContext {
    return ((AppDelegate *)[[UIApplication sharedApplication] delegate]).managedObjectContext;
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSMutableDictionary *headerFields = [NSMutableDictionary dictionary];
    [headerFields setValue:@"iOS" forKey:@"x-client-identifier"];
    self.imageDownloader = [[ImageDownloader alloc] initWithHostName:IMAGE_HOST];
//    [self.imageDownloader emptyCache];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.apiEngine = [[APIEngine alloc] initWithHostName:@"218.241.183.164"];
    // create coredata
   // [self createEditableCopyOfDatabaseIfNeeded];
    
    // read favourite coredata
//     NSManagedObjectContext *manageContext = [AppDelegate getAppDelegate].managedObjectContext;
//      NSFetchRequest *request = [[NSFetchRequest alloc] init];
//        NSEntityDescription *entity = [NSEntityDescription entityForName:@"ShipMajor" inManagedObjectContext:manageContext];
//        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Fugitive"  inManagedObjectContext:managedObjectContext];
//        [request setEntity:entity];
//        NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"englishName" ascending:YES];
//        NSArray *sorts = [[NSArray alloc] initWithObjects:sort, nil];
//        [request setSortDescriptors:sorts];
//        
//    
//        
//        NSError *error;
//        NSMutableArray *tem = [[manageContext executeFetchRequest:request error:error] mutableCopy];
//        if(tem == nil){
//            
//        }
//        myfav = tem;
//        [sorts release];
//        [sort release];
//        [tem release];
//        [request release];
   
   //[self copyDatabaseFileIfNeed];

   NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"MapLayerDemo" withExtension:@"momd"];
    NSManagedObjectModel *managedObjectModelTem = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    self.managedObjectModel = managedObjectModelTem;     
   // NSURL *storeURL = [NSURL URLWithString:[Util getDocumentPath] URLByAppendingPathComponent:@"MapLayerDemo.sqlite"];
    NSURL *storeURL = [[self applicationDocumentsDirectory2] URLByAppendingPathComponent:@"MapLayerDemo.sqlite"];
    NSError *error = nil;
    NSPersistentStoreCoordinator *p = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:managedObjectModel];
   if(![p addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]){
        NSLog(@"%@,%@",error,[error userInfo]);
    }else{
       NSManagedObjectContext *managedObjectContextTem = [[NSManagedObjectContext alloc] init];
        self.managedObjectContext = managedObjectContextTem;
        [managedObjectContext setPersistentStoreCoordinator:p];
        [managedObjectContextTem release];
    }
    
    [managedObjectModelTem release];
    [p release];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ShipDetailFocused" inManagedObjectContext:managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    
   // NSPredicate *pre = [NSPredicate predicateWithFormat:@""];
    
   // NSManagedObject *managedObject = nil;
    NSMutableArray *arrays = [[managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    
    [request release];
    
    
    //major
    NSEntityDescription *entityMajor = [NSEntityDescription entityForName:@"ShipMajor" inManagedObjectContext:managedObjectContext];
    NSFetchRequest *requestMajor = [[NSFetchRequest alloc] init];
    NSPredicate *resultPredicate;
    resultPredicate = [NSPredicate predicateWithFormat:@"shipName != %@", @""];
    [requestMajor setPredicate:resultPredicate];
    
    [requestMajor setEntity:entityMajor];
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"shipName" ascending:YES];
    NSArray *sorts = [[NSArray alloc] initWithObjects:sort,nil];
    [requestMajor setSortDescriptors:sorts];
    [sorts release];
    [sort release];
    NSMutableArray *arraysMajor = [[managedObjectContext executeFetchRequest:requestMajor error:&error] mutableCopy];

    [requestMajor release];
    
//    if(arrays == nil){
//        NSLog(@"error");
//    }
//    
//    if(arrays.count >0){
//        managedObject = [arrays objectAtIndex:0];
//    }else{
//        
//    }
    
    // read favourite
//    NSString* favFile = [[Util getDocumentPath] stringByAppendingString:@"/myfav.csv"];
//    NSString* content = [[NSString alloc] initWithContentsOfFile:favFile encoding:NSUTF8StringEncoding error:nil];
//    NSArray* array = [content componentsSeparatedByString:@"\n"];
//    NSMutableArray* shipArray = [[NSMutableArray alloc] init];
//    for (int i = 2, len = array.count; i < len; i++) {
//        if ([[array objectAtIndex:i] isEqual:@""]) {
//            continue;
//        }
//        ShipData* shipData = [Util parseShipDataString:[array objectAtIndex:i]];
//        [shipArray addObject:shipData];
//    }
//    NSSortDescriptor* sorter = [[NSSortDescriptor alloc] initWithKey:@"shipName" ascending:YES];
//    NSArray* sortDescriptors = [[NSArray alloc] initWithObjects:&sorter count:1];
//    NSArray* tmpArray = [shipArray sortedArrayUsingDescriptors:sortDescriptors];
//    myfav = [[[NSMutableArray alloc] initWithArray:tmpArray] retain];
//    [sorter release];
   

    //zx cut
   self.myfav = arrays;
   self.shipMajor = arraysMajor;
    LoginViewController *login = [[LoginViewController alloc] init ];    
   // MyFocusShipViewController *login = [[MyFocusShipViewController alloc] init];
    self.window.rootViewController = login;
    [self.window makeKeyAndVisible];
    [login release];
    [arrays release];
    [arraysMajor release];
    NSLog(@"init with %d ship data", myfav.count);
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}



-(void)dealloc{
     [managedObjectContext release];
    [persistentStoreCoordinator release];
    [managedObjectModel release];
    [myFocusShips release];
    [myShipsTeam release];
    [super dealloc];
}


- (NSURL *)applicationDocumentsDirectory2
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    //return  [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES) lastObject];
}

- (void)hudWasHidden
{  
//    NSLog(@"Hud: %@", hud);  
    // Remove HUD from screen when the HUD was hidded
    [progress_ removeFromSuperview];  
    [progress_ release];  
    progress_ = nil;  
    
} 

-(void) displayHUD :(UIViewController *)controller words:(NSString *)words{
    progress_ = [[MBProgressHUD alloc] initWithView:controller.view];  
    [controller.view addSubview:progress_];  
    [controller.view bringSubviewToFront:progress_];  
    progress_.delegate = self;  
    progress_.labelText = [NSString stringWithFormat:@"%@...",words];  
    [progress_ show:YES];  
}

-(void) dismissHUD{
    if (progress_)   
    {  
        //sleep(3.0f);
        [progress_ removeFromSuperview];  
        [progress_ release];  
        progress_ = nil;  
    }  
}

/*
 
 split
 
 */

-(void)showShipCountOnTabbarWith:(NSInteger)shipCount {
    UITabBarItem * tabBarItem = (UITabBarItem *)[self.tabBarController.tabBar.items objectAtIndex:0];
    if (shipCount > 99) {
        tabBarItem.badgeValue = @"99+";
    } else if (shipCount == 0) {
        tabBarItem.badgeValue = nil;
    } else {
        tabBarItem.badgeValue = [NSString stringWithFormat:@"%d", shipCount];
    }
}
@end
