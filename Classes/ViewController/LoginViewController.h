//
//  LoginViewController.h
//  MapLayerDemo
//
//  Created by zhengxuan on 9/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
@interface LoginViewController : UIViewController<UINavigationControllerDelegate> {
    UIButton        * checkRememberBtn;
   // UIButton        * loginBtn;
   // UIButton        * cancelBtn;
    BOOL              bRemeberPwd;
    IBOutlet UITextField *nameField;
    IBOutlet UITextField *passWordField;
//    MBProgressHUD* progress_;
    BOOL alerting;
    
}
@property (nonatomic, retain)IBOutlet UITextField *nameField;
@property (nonatomic, retain)IBOutlet UITextField *passWordField;
//@property (nonatomic, retain)IBOutlet UIButton *loginBtn;
//@property (nonatomic, retain)IBOutlet UIButton *cancelBtn;
//- (IBAction)backgroundTap:(id)sender;
//- (IBAction)login;
//- (IBAction)aboutNetSchool:(id)sender;
//- (IBAction)addMyDownloadedView:(id)sender;
//- (IBAction)addFreeCourseView:(id)sender;
//-(IBAction) closeEditByBackground:(id)sender;
//-(IBAction) cancelText;
//-(IBAction) viewOfflineVideo;

@end
