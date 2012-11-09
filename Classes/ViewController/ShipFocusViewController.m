//
//  SearchShipController.m
//  MapLayerDemo
//
//  Created by 老王八 :D on 12-6-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ShipFocusViewController.h"
#import "ShipData.h"
#import "ShipDetailViewController.h"
#import "JSONKit.h"
#import <CoreData/CoreData.h>
#import "ShipMajor.h"
#import "Util.h"
@implementation ShipFocusViewController
@synthesize searchDisplayController, searchResults, searchType,myFocusArray;
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"我的关注";//NSLocalizedString(@"Second", @"Second");
        self.tabBarItem.image = [UIImage imageNamed:@"myteamLogo"];
    }
    return self;
    
}
#pragma mark - View Delegate
-(void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.scrollEnabled = YES;

    searchType = [[NSArray arrayWithObjects:@"shipName", @"callSign", @"imo", @"mmsi", nil] retain];
    [self.tableView reloadData];
    searchDisplayController.searchBar.placeholder = @"搜索";
    [searchDisplayController.searchBar setShowsCancelButton:NO];
    searchDisplayController.searchBar.scopeButtonTitles = [NSArray arrayWithObjects:@"船名", @"呼号", @"imo", @"mmsi", nil];
    
   
}
- (void)viewDidUnload {
    [searchDisplayController release];
    searchDisplayController = nil;
    [super viewDidUnload];
}

-(void)viewWillAppear:(BOOL)animated{
    myFocusArray = [AppDelegate getMyFocusShips];
    [[self tableView] reloadData];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows = 0;
    
    if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]){
        rows = [self.searchResults count];
    }
    else{
        rows = [myFocusArray count];
    }
    return rows;
}


- (UITableViewCell *)tableView:(UITableView *)tableView 
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView 
                             dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] 
                 initWithStyle:UITableViewCellStyleDefault 
                 reuseIdentifier:CellIdentifier] autorelease];
        [cell setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cellBg.png"]]];
        [cell setSelectedBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cellBg_on.png"]]];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.backgroundColor = [UIColor clearColor];
    }
    

    /* Configure the cell. */
    if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]){
      //  cell.textLabel.text = ((ShipData*) [searchResults objectAtIndex:indexPath.row]).shipName; 
        
        NSString *name = [[searchResults objectAtIndex:indexPath.row] objectForKey:@"fulldisplayname"];
        cell.textLabel.text = name;
    }
    else{
        NSString *name = [[myFocusArray objectAtIndex:indexPath.row] objectForKey:@"fulldisplayname"];
        cell.textLabel.text = name;
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
        ShipDetailViewController *next = [[ShipDetailViewController alloc] initWithNibName:@"ShipDetailViewController" bundle:nil];
        if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]){
            
            ShipData *ship = [[[ShipData alloc] init ] autorelease];
            ship.mobileId = [[self.searchResults objectAtIndex:indexPath.row] objectForKey:@"id"];
            ship.shipName = [[self.searchResults objectAtIndex:indexPath.row] objectForKey:@"fulldisplayname"];
            next.baseData = ship;
        }
        else{
            ShipData *ship = [[[ShipData alloc] init ] autorelease];
            ship.mobileId = [[myFocusArray objectAtIndex:indexPath.row] objectForKey:@"id"];
            ship.shipName = [[myFocusArray objectAtIndex:indexPath.row] objectForKey:@"fulldisplayname"];
            next.baseData = ship;
        }
        [self.navigationController pushViewController:next animated:YES];
}

#pragma mark - UISearchDisplayController delegate methods
- (void)filterContentForSearchText:(NSString*)searchText 
                             typeIndex:(int)typeIndex
{
    NSPredicate *resultPredicate;
    switch (typeIndex) {
        case 0:
            resultPredicate = [NSPredicate predicateWithFormat:@"fulldisplayname contains[cd] %@", searchText];
            break;
        case 1:
            resultPredicate = [NSPredicate predicateWithFormat:@"callSign contains[cd] %@", searchText];
            break;
        case 2:
            resultPredicate = [NSPredicate predicateWithFormat:@"imo contains[cd] %@", searchText];
            break;
        case 3:
            resultPredicate = [NSPredicate predicateWithFormat:@"mmsi contains[cd] %@", searchText];
            break;
        default:
            break;
    }
    self.searchResults = [myFocusArray filteredArrayUsingPredicate:resultPredicate];
}
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller 
shouldReloadTableForSearchString:(NSString *)searchString
{   
    
    int idx = [self.searchDisplayController.searchBar selectedScopeButtonIndex];
//    NSString *searchField = [searchType objectAtIndex:idx];
    [self filterContentForSearchText:searchString typeIndex:idx];
//                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
//                                      objectAtIndex:[self.searchDisplayController.searchBar
//                                                     selectedScopeButtonIndex]]];
    
    return YES;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller 
shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    int idx = [self.searchDisplayController.searchBar selectedScopeButtonIndex];
    [self filterContentForSearchText:[self.searchDisplayController.searchBar text] typeIndex:idx];
//                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
//                                      objectAtIndex:searchOption]];
    
    return YES;
}

-(void) searchBarSearchButtonClicked:(UISearchBar *)searchBar{
 
}




#pragma mark -
- (void)dealloc {
    [searchDisplayController release];
    [myFocusArray release];
    myFocusArray = nil;
    [searchResults release];
    searchResults = nil;

    [searchType release];
    searchType = nil;
    [super dealloc];
}

@end
