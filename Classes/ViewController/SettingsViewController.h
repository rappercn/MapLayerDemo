//
//  SettingsViewController.h
//  MapLayerDemo
//
//  Created by 老王八 :D on 12-6-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

@class SimpleTableViewController;
@interface SettingsViewController : UITableViewController{
    BOOL isNeedMap;
    BOOL isNeedTyphoon;
    IBOutlet UISwitch *mapSwitch;
    IBOutlet UISwitch *typhoonSwitch;
}

@property (nonatomic, retain) NSArray *settingSections;
@property (nonatomic, retain) SimpleTableViewController *simpleTableView;

@end
