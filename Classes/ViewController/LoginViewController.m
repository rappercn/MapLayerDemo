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

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    NSLog(@"%@..........",[[UIDevice currentDevice] systemVersion]);
    // hide keyboard
    UITapGestureRecognizer *tap = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTap:)] autorelease];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
    
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"loginbg.png"]];
    // reachability
//    Reachability *r = [[Reachability alloc] init];
//    NetworkStatus netStatus = [r currentReachabilityStatus];
//	NetworkStatus netStatus = [r internetConnectionStatus];
	NSString * mes = nil;    
//    BOOL isReach = [r isReachable];
//    if(isReach){
//        BOOL isWiFi = [r isReachableViaWiFi];
//        if(isWiFi){
//            mes = NSLocalizedString(@"当前使用WIFI连接网络",@"成功");
//        }else if ([r isReachableViaWWAN]) {
//            mes = NSLocalizedString(@"当前使用3G连接网络",@"成功");
//        }else {
//            mes = NSLocalizedString(@"当前无可用网络",@"失败");
//        }
//    }else {
//        mes = NSLocalizedString(@"当前无可用网络",@"失败");
//    }

//	switch (netStatus) {
//		case NotReachable:
//			mes = NSLocalizedString(@"当前无可用网络",@"失败");
//			break;
//		case ReachableViaWiFi:
//			//mes = NSLocalizedString(@"当前使用WIFI连接网络",@"成功");
//			break;
//		case ReachableViaWWAN:
//			mes = NSLocalizedString(@"当前使用3G连接网络",@"成功");
//			break;
//	}

    if(mes != nil){
        NSString * tle = NSLocalizedString(@"提示",@"提示");
        NSString * yes = NSLocalizedString(@"确定",@"确定");
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:tle 
                                                       message:mes 
                                                      delegate:nil 
                                             cancelButtonTitle:yes 
                                             otherButtonTitles:nil,nil];
        alert.delegate = self;
        [alert show];
        [alert release];
    }
		
//	[r release];
    
    //bRemeberPwd = NO;
  
    NSString *isChecked = [[NSUserDefaults standardUserDefaults] objectForKey:@"isChecked"];
    if(isChecked != nil){
        bRemeberPwd = isChecked.boolValue;
    }else{
        bRemeberPwd = NO;
    }

	// create check-box
	checkRememberBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	checkRememberBtn.frame = CGRectMake(48, 192, 22, 21);
	if(bRemeberPwd)
	{
        NSString *passDefault = [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
        if(passWordField != nil){
            passWordField.text = passDefault;
        }
		[checkRememberBtn setBackgroundImage:[UIImage imageNamed:@"check.png"] 
									forState:UIControlStateNormal];
	}
	else 
	{
		[checkRememberBtn setBackgroundImage:[UIImage imageNamed:@"nocheck.png"] 
									forState:UIControlStateNormal];
	}
	[checkRememberBtn addTarget:self action:@selector(checkRemember) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:checkRememberBtn];
	
    [nameField setText:@"shsdadmin"];
    [passWordField setText:@"123456"];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

-(void)tryLoadMainView {
//    if (ApplicationDelegate.myFocusShips != nil && ApplicationDelegate.myShipsTeam != nil) {
//        NSLog(@"%@",ApplicationDelegate.myShipsTeam);
//        NSLog(@"%@",ApplicationDelegate.myFocusShips);
        //view
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
    
    SettingsViewController *settingsView = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:nil];
    UINavigationController *settingsController = [[[UINavigationController alloc] initWithRootViewController:settingsView] autorelease];
    settingsController.navigationBar.tintColor=[UIColor darkGrayColor];
    [settingsView release];
    
    ShipFocusViewController *focusShipView = [[ShipFocusViewController alloc] initWithNibName:@"ShipFocusViewController" bundle:nil];
    UINavigationController *focusViewNaviController = [[[UINavigationController alloc] initWithRootViewController:focusShipView] autorelease];
    focusViewNaviController.navigationBar.tintColor=[UIColor darkGrayColor];
    [focusShipView release];
    
    
    UITabBarController *tab = [[[UITabBarController alloc] init] autorelease];
//    tab.tabBar.tintColor = [UIColor darkGrayColor];
    tab.viewControllers = [NSArray arrayWithObjects:mapViewNaviController, myTeamViewNaviController, searchViewNaviController, settingsController,focusViewNaviController, nil];
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
        if (responseData != nil) {
//            ApplicationDelegate.myFocusShips = [[NSMutableArray alloc] init];
//        } else {
//            ApplicationDelegate.myFocusShips = [[NSMutableArray alloc] initWithArray:(NSArray*)responseData];
            NSString *idlist = @"";
            for (NSDictionary *dic in (NSArray*)responseData) {
                if (dic[@"id"] != nil && dic[@"id"] != @"") {
                    idlist = [idlist stringByAppendingFormat:@"%@,",dic[@"id"]];
                }
            }
            if ([idlist length] > 0) {
                [Util getFleetShipWithShipIds:idlist onComp:^(NSObject *responseData) {
                    if (responseData != nil) {
                        ApplicationDelegate.myFocusShips = [[NSMutableArray alloc] initWithArray:(NSArray*)responseData];
                    }
                    [self getMyTeamShip:operid];
                }];
            } else {
                [self getMyTeamShip:operid];
            }
        } else {
            [self getMyTeamShip:operid];
        }
    }];
}
-(void) showMainViewWithDict:(NSDictionary*) dict {
    
    [[NSUserDefaults standardUserDefaults] setValue:dict[@"userid"] forKey:@"userid"];
    NSString *pwd = passWordField.text;
    [[NSUserDefaults standardUserDefaults] setValue:pwd forKey:@"password"];
    
    //myfocusships
    [self getAttentionShip:dict[@"operid"]];
    

//    //多用户的公司名称应写成plist，以userid为主件 暂时先放到defalt里面 有空改
//    [[NSUserDefaults standardUserDefaults] setValue:[loginDictionary objectForKey:@"comname"] forKey:[NSString stringWithFormat:@"comname%@",userId]];
//    NSDictionary *myShips =  [Util getSearchRecByKeyInFleet:[loginDictionary objectForKey:@"operid"] key:@"" start:@"1" end:[NSString stringWithFormat:@"%d",NSIntegerMax]];
//    NSMutableArray *myShipsArray = [myShips objectForKey:@"return"];
//    delegate.myShipsTeam = myShipsArray;
    
    
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
//-(void) gotoNextView:(NSDictionary *)loginDictionary{
//
//    AppDelegate *delegate = [AppDelegate getAppDelegate];
//    [delegate dismissHUD];
//    NSString *failMessage = nil;
//    if (loginDictionary != nil) {
//        failMessage = [loginDictionary objectForKey:@"loginfailemessage"];
//    } else {
//        failMessage = @"连接服务器时发生错误";
//    }
//    NSString *pwd = [passWordField text]; 
//    
//    if (failMessage !=nil && ![failMessage isEqualToString:@""]) {
//        //NSLog(@"帐号或密码错误，请重新输入！");
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:failMessage delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alert show];
//        [alert release];
//        return;
//    }
//    else
//    {
//        
//    }
//}

//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
//{
//    return (interfaceOrientation == UIInterfaceOrientationPortrait);
//}

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
    [nameField release];
    [passWordField release];
    [super dealloc];
}


@end
