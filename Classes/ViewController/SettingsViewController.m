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
- (void)viewDidLoad
{
	[super viewDidLoad];
//    NSString *mapType = [[NSUserDefaults standardUserDefaults] valueForKey:@"mapType"];
    settingSections = [NSArray arrayWithObjects:
                            @"地图种类",
                            @"1",
                       nil];
}
-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}
#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	return @"地图种类";
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
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
//		else
//		{
//			// the cell is being recycled, remove old embedded controls
//			UIView *viewToRemove = nil;
//			viewToRemove = [cell.contentView viewWithTag:kViewTag];
//			if (viewToRemove)
//				[viewToRemove removeFromSuperview];
//		}
    NSString *mapId = [[NSUserDefaults standardUserDefaults] valueForKey:@"mapType"];
    cell.textLabel.text = [Util getMapNameByMapId:mapId];

	    
	return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SimpleTableViewController* next = [[SimpleTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
//    next.openSectionIndex = [indexPath row];
//    next.fatherSection = [indexPath section];
//    //	next.isOfflineMode = isOfflineMode;
//    for (UIView* view in sectionArray[indexPath.section].subviews) {
//        if ([view isKindOfClass:[UILabel class]]) {
//            next.viewTitle = ((UILabel*) view).text;
//            break;
//        }
//    }
    [self.navigationController pushViewController:next animated:YES];
}
@end
