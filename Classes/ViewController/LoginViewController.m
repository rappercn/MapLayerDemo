//
//  LoginViewController.m
//  MapLayerDemo
//
//  Created by zhengxuan on 9/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LoginViewController.h"
#import "SearchShipViewController.h"
#import "MyTeamViewController.h"
#import "SettingsViewController.h"
#import "GMapViewController.h"

#import "ShipFocusViewController.h"

@implementation LoginViewController
@synthesize nameField,passWordField;

- (void) reachabilityChanged: (NSNotification* )note
{
    if (alerting) {
        return;
    }
	Reachability* curReach = [note object];
	NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    NetworkStatus status = [curReach currentReachabilityStatus];
    NSString *msg = nil;
    if (status == ReachableViaWWAN) {
        msg = @"已经连接到运营商网络，您可能因此被收取高额通信费。强烈建议您连接到WIFI网络继续使用";
    } else if (status == NotReachable) {
        msg = @"当前没有可用网络，请确保您的网络畅通";
    }
    if (msg != nil) {
        alerting = YES;
        NSString * tle = NSLocalizedString(@"提示",@"提示");
        NSString * yes = NSLocalizedString(@"确定",@"确定");
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:tle
                                                       message:msg
                                                      delegate:nil
                                             cancelButtonTitle:yes
                                             otherButtonTitles:nil,nil];
        alert.delegate = self;
        [alert show];
        RELEASE_SAFELY(alert);
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    alerting = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // hide keyboard
    UITapGestureRecognizer *tap = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTap:)] autorelease];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
    
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Default.png"]];
	
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(reachabilityChanged:) name: kReachabilityChangedNotification object: nil];
    [nameField setText:[[NSUserDefaults standardUserDefaults] valueForKey:@"userid"]];
    [nameField setText:@"zhengjun"];
    [passWordField setText:@"zhengjun"];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

-(void)tryLoadMainView {
    [ApplicationDelegate dismissHUD];
    
    GMapViewController *mapView = [[GMapViewController alloc] initWithNibName:@"GMapViewController" bundle:nil];
    UINavigationController *mapViewNaviController = [[[UINavigationController alloc] initWithRootViewController:mapView] autorelease];
    mapViewNaviController.navigationBar.tintColor=[UIColor darkGrayColor];
    [mapView release];
    
    UIViewController *myTeamView = [[MyTeamViewController alloc] initWithNibName:@"MyTeamViewController" bundle:nil];
    UINavigationController* myTeamViewNaviController = [[[UINavigationController alloc] initWithRootViewController:myTeamView] autorelease];
    myTeamViewNaviController.navigationBar.tintColor=[UIColor darkGrayColor];
    [myTeamView release];
    
    SearchShipViewController *searchView = [[SearchShipViewController alloc] initWithNibName:@"SearchShipViewController" bundle:nil];
    UINavigationController *searchViewNaviController = [[[UINavigationController alloc] initWithRootViewController:searchView] autorelease];
    searchViewNaviController.navigationBar.tintColor=[UIColor darkGrayColor];
    [searchView release];
    
    ShipFocusViewController *focusShipView = [[ShipFocusViewController alloc] initWithNibName:@"ShipFocusViewController" bundle:nil];
    UINavigationController *focusViewNaviController = [[[UINavigationController alloc] initWithRootViewController:focusShipView] autorelease];
    focusViewNaviController.navigationBar.tintColor=[UIColor darkGrayColor];
    [focusShipView release];
    
    SettingsViewController *settingsView = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:nil];
    UINavigationController *settingsController = [[[UINavigationController alloc] initWithRootViewController:settingsView] autorelease];
    settingsController.navigationBar.tintColor=[UIColor darkGrayColor];
    [settingsView release];
    
    UITabBarController *tab = [[[UITabBarController alloc] init] autorelease];
//    tab.tabBar.tintColor = [UIColor darkGrayColor];
    tab.viewControllers = [NSArray arrayWithObjects:mapViewNaviController, myTeamViewNaviController, focusViewNaviController,searchViewNaviController, settingsController, nil];
    ApplicationDelegate.tabBarController = tab;
//    NSLog(@"========%@----------", self.navigationController);
    [self.navigationController pushViewController:ApplicationDelegate.tabBarController animated:YES];
//    [self presentModalViewController:ApplicationDelegate.tabBarController animated:YES ];
//    }
}
-(void) getMyTeamShip:(NSString*)operid {
    //myshipsTeam
    [Util getSearchRecByKeyInFleetWithOperid:operid key:@"" onComp:^(NSObject *responseData) {
        if (responseData != nil) {
//            ApplicationDelegate.myShipsTeam = [[NSMutableArray alloc] init];
//        } else {
            ApplicationDelegate.myShipsTeam = [[NSMutableArray alloc] initWithArray:(NSArray*)responseData];
        }
        [self tryLoadMainView];
    }];
}
-(void) getAttentionShip:(NSString*)operid {
    ApplicationDelegate.myFocusShips = nil;
    ApplicationDelegate.myShipsTeam = nil;
    [Util getAttentionShipWithOperid:operid onComp:^(NSObject *responseData) {
        if (responseData == nil) {
            ApplicationDelegate.myFocusShips = [[NSMutableArray alloc] init];
        } else {
            ApplicationDelegate.myFocusShips = [[NSMutableArray alloc] initWithArray:(NSArray*)responseData];
        }
        [self getMyTeamShip:operid];
    }];
}
-(void) showMainViewWithDict:(NSDictionary*) dict {
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setValue:dict[@"userid"] forKey:@"userid"];
//    NSString *pwd = passWordField.text;
//    [def setValue:pwd forKey:@"password"];
    [def setValue:dict[@"operid"] forKey:@"operid"];
    [def setValue:dict[@"dispname"] forKey:@"dispname"];
    [def setValue:dict[@"comname"] forKey:@"comname"];
    [def setValue:dict[@"regdate"] forKey:@"regdate"];
    ApplicationDelegate.opeid = dict[@"operid"];
    
    //myfocusships
    [self getAttentionShip:dict[@"operid"]];
    NSString* path = [[NSBundle mainBundle] pathForResource:@"codeDict" ofType:@"plist"];
    ApplicationDelegate.codeArray = [[NSArray alloc] initWithContentsOfFile:path];
}
-(void)login{

    [ApplicationDelegate displayHUD:self words:@"正在登录"];
    ApplicationDelegate.myFocusShips = nil;
    ApplicationDelegate.myShipsTeam = nil;
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"offlineView"];
    //接口对接实例
    NSString *username = [nameField text];
    NSString *pwd = [passWordField text];
    [Util loginWithUser:username passwd:pwd onComp:^(NSObject *responseData) {
//        [ApplicationDelegate dismissHUD];
        NSDictionary *dict = (NSDictionary*)responseData;
        NSString *failMessage = nil;
        if (dict != nil) {
            failMessage = dict[@"loginfailemessage"];
        } else {
            failMessage = @"无法连接到服务器";
        }
        
        if (failMessage !=nil && ![failMessage isEqualToString:@""]) {
            //NSLog(@"帐号或密码错误，请重新输入！");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:failMessage delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
            [ApplicationDelegate dismissHUD];
            return;
        } else {
            [self showMainViewWithDict:dict];
        }
    }];
}

- (IBAction)backgroundTap:(id)sender
{
    [nameField resignFirstResponder];
    [passWordField resignFirstResponder];
}

-(IBAction) checkRemember
{
	bRemeberPwd = !bRemeberPwd;

	if(bRemeberPwd)
	{
        //		NSString * username = ((CustomCell*)[loginTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]]).cellvalue.text;
        //		NSString * pwd = ((CustomCell*)[loginTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]]).cellvalue.text;
        
       // NSString *username = [nameField text];
        NSString *pwd = [passWordField text];
        
		// set if username not null
		if(0 != [pwd length])
		{
			[checkRememberBtn setBackgroundImage:[UIImage imageNamed:@"check.png"] 
										forState:UIControlStateNormal];
		}
		else 
		{
			// don't remember if username is null
			// and don't change pic
			bRemeberPwd = !bRemeberPwd;
		}
	}
	else 
	{
		// set pic
		[checkRememberBtn setBackgroundImage:[UIImage imageNamed:@"nocheck.png"] 
									forState:UIControlStateNormal];
	}
    [[NSUserDefaults standardUserDefaults] setBool:bRemeberPwd forKey:@"isChecked"];
}


-(void)dealloc{
    [super dealloc];
    RELEASE_SAFELY(nameField);
    RELEASE_SAFELY(passWordField);
}


@end
