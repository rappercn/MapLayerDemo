//
//  SearchShipController.m
//  MapLayerDemo
//
//  Created by 老王八 :D on 12-6-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ShipFocusViewController.h"
//#import "ShipData.h"
#import "ShipDetailViewController.h"
//#import "JSONKit.h"
//#import <CoreData/CoreData.h>
//#import "ShipMajor.h"
//#import "Util.h"
@implementation ShipFocusViewController
//@synthesize searchDisplayController, searchResults, searchType,myFocusArray;
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"我的关注";//NSLocalizedString(@"Second", @"Second");
        self.tabBarItem.image = [UIImage imageNamed:@"myfocus"];
    }
    return self;
    
}
#pragma mark - View Delegate
-(void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.scrollEnabled = YES;

//    searchType = [[NSArray arrayWithObjects:@"shipName", @"callSign", @"imo", @"mmsi", nil] retain];
//    [self.tableView reloadData];
    searchController.searchBar.placeholder = @"搜索";
    [searchController.searchBar setShowsCancelButton:NO];
    searchController.searchBar.scopeButtonTitles = [NSArray arrayWithObjects:@"船名", @"呼号", @"imo", @"mmsi", nil];
    
   
}
- (void)viewDidUnload {
//    [searchBar release];
//    searchBar = nil;

    [super viewDidUnload];
}

-(void)viewWillAppear:(BOOL)animated{
//    myFocusArray = [AppDelegate getMyFocusShips];
    [[self tableView] reloadData];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    NSInteger rows = 0;
    
    if ([tableView isEqual:searchController.searchResultsTableView]){
        return [searchResults count];
    }
    else{
        return [ApplicationDelegate.myFocusShips count];
    }
//    return rows;
}


- (UITableViewCell *)tableView:(UITableView *)tableView 
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid = @"focusCellId";
    
    UITableViewCell *cell = [tableView 
                             dequeueReusableCellWithIdentifier:cellid];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] 
                 initWithStyle:UITableViewCellStyleDefault 
                 reuseIdentifier:cellid] autorelease];
        [cell setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cellBg.png"]]];
//        [cell setSelectedBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cellBg_on.png"]]];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = [UIFont systemFontOfSize:12];
    }
    

    NSString *title = nil;
    if ([tableView isEqual:searchController.searchResultsTableView]){
        title = searchResults[indexPath.row][@"shipnamecn"];
        if (title != nil && ![title isEqualToString:@""]) {
            cell.textLabel.text = title;
        } else {
            cell.textLabel.text = searchResults[indexPath.row][@"shipname"];
        }
    }else{
        title = ApplicationDelegate.myFocusShips[indexPath.row][@"shipnamecn"];
        if (title != nil && ![title isEqualToString:@""]) {
            cell.textLabel.text = title;
        } else {
            cell.textLabel.text = ApplicationDelegate.myFocusShips[indexPath.row][@"shipname"];
        }
    }
//    UIFont *font = [UIFont fontWithName:@"Arial" size:18];
//    cell.textLabel.font = font;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
        ShipDetailViewController *next = [[ShipDetailViewController alloc] initWithNibName:@"ShipDetailViewController" bundle:nil];
        if ([tableView isEqual:searchController.searchResultsTableView]){
            
           // ShipData *ship = [[[ShipData alloc] init ] autorelease];
           // ship.mobileId = [[self.searchResults objectAtIndex:indexPath.row] objectForKey:@"id"];
           // ship.shipName = [[self.searchResults objectAtIndex:indexPath.row] objectForKey:@"shipname"];
           // next.baseData = ship;
           
             next.shipdict = [searchResults objectAtIndex:indexPath.row];
        }
        else{
           // ShipData *ship = [[[ShipData alloc] init ] autorelease];
           // ship.mobileId = [[myFocusArray objectAtIndex:indexPath.row] objectForKey:@"id"];
           // ship.shipName = [[myFocusArray objectAtIndex:indexPath.row] objectForKey:@"shipname"];
           // next.baseData = ship;
               next.shipdict = [ApplicationDelegate.myFocusShips objectAtIndex:indexPath.row];
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
            resultPredicate = [NSPredicate predicateWithFormat:@"(shipname contains[cd] %@) OR (shipnamecn contains[cd] %@)", searchText, searchText];
            break;
        case 1:
            resultPredicate = [NSPredicate predicateWithFormat:@"callsign contains[cd] %@", searchText];
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
    RELEASE_SAFELY(searchResults);
    searchResults = [[NSMutableArray alloc] initWithArray:[ApplicationDelegate.myFocusShips filteredArrayUsingPredicate:resultPredicate]];
}
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller 
shouldReloadTableForSearchString:(NSString *)searchString
{   
    
    int idx = [searchController.searchBar selectedScopeButtonIndex];
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
    int idx = [searchController.searchBar selectedScopeButtonIndex];
    [self filterContentForSearchText:[searchController.searchBar text] typeIndex:idx];
//                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
//                                      objectAtIndex:searchOption]];
    
    return YES;
}

-(void) searchBarSearchButtonClicked:(UISearchBar *)searchBar{
 
}




#pragma mark -
- (void)dealloc {
//    [searchDisplayController release];
    RELEASE_SAFELY(searchController);
//    [myFocusArray release];
//    myFocusArray = nil;
//    [searchResults release];
//    searchResults = nil;

    RELEASE_SAFELY(searchResults);
//    [searchType release];
//    searchType = nil;
//    RELEASE_SAFELY(searchType);

    [super dealloc];
}

@end
