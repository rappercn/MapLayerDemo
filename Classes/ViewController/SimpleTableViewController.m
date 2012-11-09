//
//  SimpleTableViewController.m
//  MapLayerDemo
//
//  Created by 老王八 :D on 12-6-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SimpleTableViewController.h"

@implementation SimpleTableViewController
@synthesize dataSource;

-(void)viewDidLoad
{
    idx[0] = MAP_CUSTOM;
    idx[1] = MAP_GOOGLE;
    idx[2] = MAP_OSM;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	return @"选择地图";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 3;
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
    if (idx[indexPath.row] == mapId.intValue) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    cell.textLabel.text = [Util getMapNameByMapId:[[NSString alloc] initWithFormat:@"%d", idx[indexPath.row]]];
    
    
	return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* value = [[NSString alloc] initWithFormat:@"%d", idx[indexPath.row]];
    [[NSUserDefaults standardUserDefaults] setValue:value forKey:@"mapType"];
    [tableView reloadData];
}
@end
