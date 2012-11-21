//
//  SettingsViewController.m
//  MapLayerDemo
//
//  Created by 老王八 :D on 12-6-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SettingsViewController.h"
#import "SimpleTableViewController.h"
#import <QuartzCore/QuartzCore.h>
@implementation SettingsViewController
@synthesize settingSections, simpleTableView;

#pragma mark - Private Methods
- (void)switchAction:(id)sender{
    UISwitch *sw = (UISwitch *)sender;
    switch (sw.tag) {
        case 100:
            [[NSUserDefaults standardUserDefaults] setBool:sw.on forKey:@"useMap"];
            break;
        case 101:
            [[NSUserDefaults standardUserDefaults] setBool:sw.on forKey:@"showTyphoon"];
            break;
        case 102:
            [[NSUserDefaults standardUserDefaults] setBool:sw.on forKey:@"showShipName"];
            break;
        default:
            break;
    }
}

#pragma mark - View Delegate
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"设置";
        self.tabBarItem.image = [UIImage imageNamed:@"settingLogo"];
    }
    return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
//    mapSwitch =[[[UISwitch alloc] initWithFrame:CGRectMake(232, 60, 322, 222)] autorelease];
//    [mapSwitch addTarget:self action: @selector(switchActionMap:) forControlEvents:UIControlEventValueChanged];
//    NSString *mapDefault = [[NSUserDefaults standardUserDefaults] objectForKey:@"isNeedMap"];
//    if(mapDefault != nil && [mapDefault isEqualToString:@"YES"]){
//        isNeedMap = YES;
//    }else{
//        isNeedMap = NO;
//    }
//    [mapSwitch setOn:isNeedMap];
//    [self.view addSubview:mapSwitch];
//    
//    typhoonSwitch =[[[UISwitch alloc] initWithFrame:CGRectMake(232,108, 322, 222)] autorelease];
//    [typhoonSwitch addTarget:self action: @selector(switchActionTyphoon:) forControlEvents:UIControlEventValueChanged];
//    NSString *typhoonDefault = [[NSUserDefaults standardUserDefaults] objectForKey:@"isNeedTyphoon"];
//    if(typhoonDefault != nil && [typhoonDefault isEqualToString:@"YES"]){
//        isNeedTyphoon = YES;
//    }else{
//        isNeedTyphoon = NO;
//    }
//    [typhoonSwitch setOn:isNeedTyphoon];
//    [self.view addSubview:typhoonSwitch];
    

}
-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}
-(void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	if(section==0){
        return @"设置";
    }
    return @"";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if (section == 0) {
        return 3;
    } else {
        return 1;
    }
}

// to determine specific row height for each cell, override this.
// In this example, each row is determined by its subviews that are embedded.
//
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	//return ([indexPath row] == 0) ? 50.0 : 38.0;
    return 40.0;
}

// to determine which UITableViewCell to be used on a given row.
//
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = nil;

    NSString *cellId = [@"SettingCell" stringByAppendingFormat:@"%d",indexPath.section];
    cell = [self.tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId] autorelease];
        if (indexPath.section == 0) {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        } else {
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        }
        
        cell.accessoryType =UITableViewCellAccessoryNone;// UITableViewCellAccessoryDisclosureIndicator;
    }
//		else
//		{
//			// the cell is being recycled, remove old embedded controls
//			UIView *viewToRemove = nil;
//			viewToRemove = [cell.contentView viewWithTag:kViewTag];
//			if (viewToRemove)
//				[viewToRemove removeFromSuperview];
//		}
  //  NSString *mapId = [[NSUserDefaults standardUserDefaults] valueForKey:@"mapType"];
    static NSString *text[] = {@"使用海图", @"显示台风", @"显示船名"};
    if (indexPath.section == 0) {
        cell.textLabel.text = text[indexPath.row];
        UISwitch *sw=[[UISwitch alloc] initWithFrame:CGRectMake(220, 6, 79, 27)];
        sw.tag = 100 + indexPath.row;
        [sw addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
        switch (sw.tag) {
            case 100:
                sw.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"useMap"];
                break;
            case 101:
                sw.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"showTyphoon"];
                break;
            case 102:
                sw.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"showShipName"];
                break;
            default:
                break;
        }
        [cell.contentView addSubview:sw];
        [sw release];
    } else {
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(110.0, 0.0, 100.0, 40.0)];
        [lbl setText:@"退出"];
        [lbl setBackgroundColor:[UIColor clearColor]];
        [lbl setTextAlignment:NSTextAlignmentCenter];
        [cell addSubview:lbl];
        [lbl release];
//        UIButton *btn = [[UIButton buttonWithType:UIButtonTypeRoundedRect] autorelease];
//        btn.frame = CGRectMake(10.0, 0.0, 300.0, 40.0);
////        [btn setBackgroundColor:[UIColor grayColor]];
//        [btn setTitle:@"退出" forState:UIControlStateNormal];
//        [btn setTitle:@"退出" forState:uicontrol]
//        btn.clipsToBounds = YES;
//        
//        btn.layer.cornerRadius = 20;//half of the width
//        
//        btn.layer.borderColor=[UIColor redColor].CGColor;
//        
//        btn.layer.borderWidth=2.0f;
//        [cell addSubview:btn];
//        [btn release];
    }

//    if(indexPath.row==0){
//        cell.textLabel.text = @;
//    }else if (indexPath.row == 1) {
//        cell.textLabel.text = @"显示台风";
//    }
//;

	    
	return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [self.navigationController popToRootViewControllerAnimated:YES];
    [self.parentViewController.navigationController popViewControllerAnimated:YES];

 //   SimpleTableViewController* next = [[SimpleTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
//    next.openSectionIndex = [indexPath row];
//    next.fatherSection = [indexPath section];
//    //	next.isOfflineMode = isOfflineMode;
//    for (UIView* view in sectionArray[indexPath.section].subviews) {
//        if ([view isKindOfClass:[UILabel class]]) {
//            next.viewTitle = ((UILabel*) view).text;
//            break;
//        }
//    }
 //   [self.navigationController pushViewController:next animated:YES];
}
@end
