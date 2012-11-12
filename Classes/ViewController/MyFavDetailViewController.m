//
//  MyFavDetailViewController.m
//  MapLayerDemo
//
//  Created by 老王八 :D on 12-7-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MyFavDetailViewController.h"
#import "ShipDetailViewController.h"
#import "ShipData.h"

@implementation MyFavDetailViewController
@synthesize favItemTableView, openSectionIndex, favArray,groupId,searchResults,searchType,searchDisplayController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
   // self.view.scrollEnabled = YES;
    
    searchType = [[NSArray arrayWithObjects:@"shipName", @"callSign", @"imo", @"mmsi", nil] retain];
   // [self.tableView reloadData];
    searchDisplayController.searchBar.placeholder = @"搜索";
    [searchDisplayController.searchBar setShowsCancelButton:NO];
    searchDisplayController.searchBar.scopeButtonTitles = [NSArray arrayWithObjects:@"船名", @"呼号", @"imo", @"mmsi", nil];
    
    
    //AppDelegate* delegate = [AppDelegate getAppDelegate];
    //myFav = delegate.myfav;
    NSDictionary *myFavDictionary = [Util getMobilesInfo:[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"] groupId:groupId];
    NSArray *temarray = [myFavDictionary objectForKey:@"return"];
    NSMutableArray *ships = [[[NSMutableArray alloc] initWithCapacity:50] autorelease];
    for(int i=0;i<temarray.count;i++){
        NSDictionary *shipDetail = [temarray objectAtIndex:i];
        NSString *shipName = [shipDetail objectForKey:@"shipname"];
        NSString *shipId = [shipDetail objectForKey:@"shipid"];
        NSString *mmsi = [shipDetail objectForKey:@"mmsi"];
        NSString *iso = [shipDetail objectForKey:@"iso"];
        NSString *callSign = [shipDetail objectForKey:@"callsign"];
        NSDictionary *shipTem = [NSDictionary dictionaryWithObjectsAndKeys:shipId,@"shipId",shipName,@"shipName",callSign,@"callSign",mmsi,@"mmsi",iso,@"iso",nil];
        [ships addObject:shipTem];
    }
    myFav = [ships retain];
    favItemTableView.delegate = self;
    flag[openSectionIndex] = YES;

}

- (void)viewDidUnload
{
    [self setFavItemTableView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

- (void)dealloc {
    [favItemTableView release];
    [groupId release];
    [searchDisplayController release];
    //[myFocusArray release];
    //myFocusArray = nil;
    [searchResults release];
    searchResults = nil;
    
    [searchType release];
    searchType = nil;
    [super dealloc];
    
}

#pragma mark- TableView DataSource

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return [favArray count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (flag[section]) {
            if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]){
                return searchResults.count;
            }else{
                return myFav.count;
            }
    }
    return 0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShipDetailViewController *next = [[ShipDetailViewController alloc] initWithNibName:@"ShipDetailViewController" bundle:nil];
    ShipData *ship = [[[ShipData alloc] init ] autorelease];    
    if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]){
        ship.mobileId = [[searchResults objectAtIndex:indexPath.row] objectForKey:@"shipId"];
        ship.shipName = [[searchResults objectAtIndex:indexPath.row] objectForKey:@"shipName"];
        next.baseData = ship;
    }else{
        ship.mobileId = [[myFav objectAtIndex:indexPath.row] objectForKey:@"shipId"];
        ship.shipName = [[myFav objectAtIndex:indexPath.row] objectForKey:@"shipName"];
        next.baseData = ship;
    }
    [self.navigationController pushViewController:next animated:YES];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *SectionTableIdntifier = @"mycell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SectionTableIdntifier];
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SectionTableIdntifier] autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = [UIFont systemFontOfSize:12];
        [cell setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cellBg.png"]]];
        [cell setSelectedBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cellBg_on.png"]]];
    }
    if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]){
         cell.textLabel.text = [[searchResults objectAtIndex:indexPath.row] objectForKey:@"shipName"];
    }else{
         cell.textLabel.text = [[myFav objectAtIndex:indexPath.row] objectForKey:@"shipName"];
    }
    UIFont *font = [UIFont fontWithName:@"Arial" size:18];
    cell.textLabel.font = font;
    return cell;
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    if (sectionArray[section] == nil) {
//        
//        NSString* title = [[favArray objectAtIndex:section] objectForKey:@"groupName"];
//        BOOL opened = NO;
//        if (flag[section]) {
//            opened = YES;
//        }
//        SectionHeaderView* header = [[SectionHeaderView alloc] initWithFrame:CGRectMake(0.0, 0.0, favItemTableView.bounds.size.width, 42)
//                                                                       title:title
//                                                                     section:section
//                                                                      opened:opened
//                                                                    delegate:self
//                                                               courseSection:YES];
//        sectionArray[section] = header;
//    }
//    return sectionArray[section];
//}
//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//	return 42;
//}
//-(void)sectionHeaderView:(SectionHeaderView*)sectionHeaderView sectionClosed:(NSInteger)section
//{
//    flag[section] = NO;
//	// 收缩+动画 (如果不需要动画直接reloaddata)
//	NSInteger countOfRowsToDelete = [self.favItemTableView numberOfRowsInSection:section];
//    NSMutableArray *indexPathsToDelete = [[NSMutableArray alloc] init];
//    for (NSInteger i = 0; i < countOfRowsToDelete; i++) {
//        [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:i inSection:section]];
//    }
//    [self.favItemTableView deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:UITableViewRowAnimationTop];
//    NSLog(@"section header closed : delete %d rows from section %d", countOfRowsToDelete, section);
//    openSectionIndex = NSNotFound;
//    
//}
//-(void)sectionHeaderView:(SectionHeaderView*)sectionHeaderView sectionOpened:(NSInteger)section
//{
//	flag[section] = YES;
//    
//    /*
//     Create an array containing the index paths of the rows to insert: These correspond to the rows for each quotation in the current section.
//     */
//    NSInteger countOfRowsToInsert = [myFav count];
//    NSMutableArray *indexPathsToInsert = [[NSMutableArray alloc] init];
//    for (NSInteger i = 0; i < countOfRowsToInsert; i++) {
//        [indexPathsToInsert addObject:[NSIndexPath indexPathForRow:i inSection:section]];
//    }
//    
//    /*
//     Create an array containing the index paths of the rows to delete: These correspond to the rows for each quotation in the previously-open section, if there was one.
//     */
//    NSMutableArray *indexPathsToDelete = [[NSMutableArray alloc] init];
//    
//    NSInteger previousOpenSectionIndex = openSectionIndex;
//    if (previousOpenSectionIndex != NSNotFound) {
//		flag[previousOpenSectionIndex] = NO;
//        [sectionArray[previousOpenSectionIndex] toggleAction:NO];
//        [sectionArray[previousOpenSectionIndex].disclosureButton setBackgroundImage:[UIImage imageNamed:@"sectionHeaderClose.png"] forState:UIControlStateNormal];
//        NSInteger countOfRowsToDelete = [myFav count];
//        for (NSInteger i = 0; i < countOfRowsToDelete; i++) {
//            [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:i inSection:previousOpenSectionIndex]];
//        }
//        
//    }
//    
//    // Style the animation so that there's a smooth flow in either direction.
//    UITableViewRowAnimation insertAnimation;
//    UITableViewRowAnimation deleteAnimation;
//    if (previousOpenSectionIndex == NSNotFound || section < previousOpenSectionIndex) {
//        insertAnimation = UITableViewRowAnimationTop;
//        deleteAnimation = UITableViewRowAnimationBottom;
//    }
//    else {
//        insertAnimation = UITableViewRowAnimationBottom;
//        deleteAnimation = UITableViewRowAnimationTop;
//    }
//    NSLog(@"section header opened : insert %d rows into section %d", countOfRowsToInsert, section);
//    // Apply the updates.
//    [favItemTableView beginUpdates];
//    [favItemTableView insertRowsAtIndexPaths:indexPathsToInsert withRowAnimation:insertAnimation];
//    [favItemTableView deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:deleteAnimation];
//    [favItemTableView endUpdates];
//    openSectionIndex = section;
//    indexPathsToInsert = nil;
//    [indexPathsToInsert release];
//    indexPathsToDelete = nil;
//    [indexPathsToDelete release];
//}

#pragma mark - UISearchDisplayController delegate methods
- (void)filterContentForSearchText:(NSString*)searchText 
                         typeIndex:(int)typeIndex
{
    NSPredicate *resultPredicate;
    switch (typeIndex) {
        case 0:
            resultPredicate = [NSPredicate predicateWithFormat:@"shipName contains[cd] %@", searchText];
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
    self.searchResults = [myFav filteredArrayUsingPredicate:resultPredicate];
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
@end
