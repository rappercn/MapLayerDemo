//
//  SettingsViewController.m
//  MapLayerDemo
//
//  Created by 老王八 :D on 12-6-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SettingsViewController.h"
#import "SimpleTableViewController.h"

@implementation SettingsViewController
@synthesize settingSections, simpleTableView;
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"设置";
        self.tabBarItem.image = [UIImage imageNamed:@"settingLogo"];
    }
    return self;
}

- (void)switchActionMap:(id)sender{
    UISwitch *switchap = (UISwitch *)sender;
    if(switchap.on){
        [[NSUserDefaults standardUserDefaults] setValue:@"YES" forKey:@"isNeedMap"];
    }else{
        [[NSUserDefaults standardUserDefaults] setValue:@"NO" forKey:@"isNeedMap"];
    }
}

- (void)switchActionTyphoon:(id)sender{
    UISwitch *switchTy = (UISwitch *)sender;
    if(switchTy.on){
        [[NSUserDefaults standardUserDefaults] setValue:@"YES" forKey:@"isNeedTyphoon"];
    }else{
        [[NSUserDefaults standardUserDefaults] setValue:@"NO" forKey:@"isNeedTyphoon"];
    }
}

- (void)viewDidLoad
{
	[super viewDidLoad];
    mapSwitch =[[[UISwitch alloc] initWithFrame:CGRectMake(232, 62, 322, 222)] autorelease];
    [mapSwitch addTarget:self action: @selector(switchActionMap:) forControlEvents:UIControlEventValueChanged];
    NSString *mapDefault = [[NSUserDefaults standardUserDefaults] objectForKey:@"isNeedMap"];
    if(mapDefault != nil && [mapDefault isEqualToString:@"YES"]){
        isNeedMap = YES;
    }else{
        isNeedMap = NO;
    }
    [mapSwitch setOn:isNeedMap];
    [self.view addSubview:mapSwitch];
    
    typhoonSwitch =[[[UISwitch alloc] initWithFrame:CGRectMake(232, 162, 322, 222)] autorelease];
    [typhoonSwitch addTarget:self action: @selector(switchActionTyphoon:) forControlEvents:UIControlEventValueChanged];
    NSString *typhoonDefault = [[NSUserDefaults standardUserDefaults] objectForKey:@"isNeedTyphoon"];
    if(typhoonDefault != nil && [typhoonDefault isEqualToString:@"YES"]){
        isNeedTyphoon = YES;
    }else{
        isNeedTyphoon = NO;
    }
    [typhoonSwitch setOn:isNeedTyphoon];
    [self.view addSubview:typhoonSwitch];
    

}
-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}
#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	if(section==0){
        return @"地图";
    }else if (section == 1) {
        return @"台风";
    }
    return @"";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 1;
}

// to determine specific row height for each cell, override this.
// In this example, each row is determined by its subviews that are embedded.
//
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return ([indexPath row] == 0) ? 50.0 : 38.0;
}

// to determine which UITableViewCell to be used on a given row.
//
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = nil;

    static NSString *cellId = @"cell";
    cell = [self.tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
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
    if(indexPath.row==0){
        cell.textLabel.text = @"地图";
    }else if (indexPath.row == 1) {
        cell.textLabel.text = @"台风";
    }
;

	    
	return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
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
