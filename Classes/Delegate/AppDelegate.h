//
//  mycompAppDelegate.h
//  Chuanbao
//
//  Created by 老王八 :D on 12-6-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

//#import <UIKit/UIKit.h>
//#import "Util.h"
#import <MapKit/MapKit.h>
#import "ImageDownloader.h"
#import "APIEngine.h"
#import "MBProgressHUD.h"
//@class MBProgressHUD;
//@class MBProgressHUDDelegate;
#define ApplicationDelegate ((AppDelegate *)[UIApplication sharedApplication].delegate)
#define IMAGE_HOST @"map.ctrack.com.cn"


@interface AppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate,MBProgressHUDDelegate> {
//    NSMutableArray* myfav;
    NSManagedObjectContext *managedObjectContext;
    MBProgressHUD* progress_;
}

@property (nonatomic, assign) CLLocationCoordinate2D coord;
@property (nonatomic, assign) BOOL showShip;
@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) UITabBarController *tabBarController;
@property (nonatomic, retain) NSMutableArray* myfav;           //local ships detail
@property (nonatomic, retain) NSMutableArray* myFocusShips;    //my focus ships
@property (nonatomic, retain) NSMutableArray* myShipsTeam;     //ship team
@property (nonatomic, retain) ImageDownloader *imageDownloader;
@property (nonatomic, retain) APIEngine *apiEngine;
@property (nonatomic, retain) NSDictionary *seletedShip;
@property (nonatomic, retain) NSMutableArray* shipMajor;       //local ships major
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, retain) NSManagedObjectModel *managedObjectModel;



+ (AppDelegate *)getAppDelegate;
+ (NSMutableArray *)getMyFavArray;
+ (NSMutableArray *)getShipMajor;
+ (NSManagedObjectContext *)getManagedObjectContext;
+ (NSMutableArray *)getMyFocusShips ;
+ (NSMutableArray *)getMyShipsTeam ;


-(void) dismissHUD;
-(void) displayHUD :(UIViewController *)controller words:(NSString *)words;

/*
 split
 */

- (void)showShipCountOnTabbarWith:(NSInteger)shipCount;
@end
