//
//  mycompAppDelegate.m
//  Chuanbao
//
//  Created by 老王八 :D on 12-6-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "GMapViewController.h"
#import "MyTeamViewController.h"
#import "SettingsViewController.h"
#import "ShipDetailFocused.h"
#import "LoginViewController.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize tabBarController = _tabBarController;
@synthesize myFocusShips;
@synthesize myShipsTeam;
@synthesize imageDownloader;
@synthesize opeid;
@synthesize codeArray;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSMutableDictionary *headerFields = [NSMutableDictionary dictionary];
    [headerFields setValue:@"iOS" forKey:@"x-client-identifier"];
    self.imageDownloader = [[ImageDownloader alloc] initWithHostName:IMAGE_HOST];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.apiEngine = [[APIEngine alloc] initWithHostName:@"218.241.183.164"];

    LoginViewController *login = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:login];
    [self.window addSubview:nav.view];

    nav.navigationBarHidden = YES;
    [self.window makeKeyAndVisible];
//    RELEASE_SAFELY(login);
//    RELEASE_SAFELY(nav);
    return YES;
}
-(void)dealloc{
    [myFocusShips release];
    [myShipsTeam release];
    [super dealloc];
}
-(NSString*) makeShipNameByCnName:(NSString *)cnName engName:(NSString *)eName imo:(NSString *)imo
{
    NSString *result = nil;
    if (imo != nil && imo.length > 0) {
        if (cnName != nil && cnName.length > 0) {
            result = [cnName stringByAppendingFormat:@"(%@)",imo];
        } else if (eName != nil && eName.length > 0) {
            result = [eName stringByAppendingFormat:@"(%@)",imo];
        } else {
            result = imo;
        }
    } else {
        if (cnName != nil && cnName.length > 0) {
            result = cnName;
        } else if (eName != nil && eName.length > 0) {
            result = eName;
        } else {
            result = @"";
        }
    }
    return [result autorelease];
}
-(void) displayHUD :(UIViewController *)controller words:(NSString *)words{
    progress_ = [[MBProgressHUD alloc] initWithView:controller.view];  
    [controller.view addSubview:progress_];  
    [controller.view bringSubviewToFront:progress_];  
//    progress_.delegate = self;  
    progress_.labelText = [NSString stringWithFormat:@"%@...",words];
    [progress_ show:YES];  
}

-(void) dismissHUD{
    if (progress_)   
    {  
        //sleep(3.0f);
        [progress_ removeFromSuperview];  
        RELEASE_SAFELY(progress_);
    }  
}

-(void)showShipCountOnTabbarWith:(NSInteger)shipCount {
    UITabBarItem * tabBarItem = (UITabBarItem *)[self.tabBarController.tabBar.items objectAtIndex:0];
    if (shipCount == 0) {
        tabBarItem.badgeValue = nil;
    } else {
        tabBarItem.badgeValue = [NSString stringWithFormat:@"%d", shipCount];
    }
}
@end
