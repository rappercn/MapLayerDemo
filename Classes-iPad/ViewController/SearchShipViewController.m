
#import "SearchShipViewController.h"
#import "ShipDetailViewController.h"

@implementation SearchShipViewController
@synthesize searchDisplayController;
#define ROW_PERQUERY 10
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"搜船";
        self.tabBarItem.image = [UIImage imageNamed:@"searchLogo"];
    }
    return self;
}
#pragma mark - View Delegate
-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.scrollEnabled = YES;
    currentPage = 0;
//    [self.tableView reloadData];
    searchDisplayController.searchBar.placeholder = @"搜索";
    [searchDisplayController.searchBar setShowsCancelButton:NO];
    searchDisplayController.searchBar.scopeButtonTitles = [NSArray arrayWithObjects:@"船名", @"呼号", @"imo", @"mmsi", nil];
    searchResults = [[NSMutableArray arrayWithCapacity:0] retain];
    NSString *path = [[Util getCachePath] stringByAppendingString:@"/searchHistory.plist"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        localArray = [[NSMutableArray arrayWithContentsOfFile:path] retain];
    } else {
        localArray = [[NSMutableArray arrayWithCapacity:0] retain];
    }
}
- (void)viewDidUnload {
    [super viewDidUnload];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [searchDisplayController.searchBar becomeFirstResponder];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows = 0;
    
    if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]){
        if(searchResults.count != 0){
            rows = [searchResults count] + 1;
        }
    }
    else{
        rows = [localArray count];
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
        cell.textLabel.backgroundColor = [UIColor clearColor];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [cell.textLabel setTextAlignment:NSTextAlignmentLeft];
    cell.tag = 0;
    
    /* Configure the cell. */
    if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]){
        if([indexPath row] == [searchResults count])
        {
            [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
            cell.textLabel.text = @"查看更多结果";
            cell.accessoryType = UITableViewCellAccessoryNone;
        }else {
            NSMutableDictionary *dict = searchResults[indexPath.row];
            cell.textLabel.text = [ApplicationDelegate makeShipNameByCnName:dict[@"shipnamecn"] engName:dict[@"shipname"] imo:dict[@"imo"]];
        }
    }
    else{
        NSString *title = localArray[indexPath.row][@"shipnamecn"];
        if ([title isEqualToString:@""] || title == nil) {
            title = localArray[indexPath.row][@"shipname"];
        }
        cell.textLabel.text =  title;
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShipDetailViewController *next = [[ShipDetailViewController alloc] initWithNibName:@"ShipDetailViewController" bundle:nil];
    if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]){
        if([indexPath row] == [searchResults count])
        {
            [tableView deselectRowAtIndexPath:indexPath animated:NO];
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            if (cell.tag != 1) {
                currentPage++;
                [ApplicationDelegate displayHUD:self words:@"正在检索"];
                 NSString *operid = [[NSUserDefaults standardUserDefaults ] objectForKey:@"operid"];
                NSString *type=@"";
                if (searchTypeIdx == 0){
                    type = @"name";
                }else if(searchTypeIdx == 1){
                    type = @"callsign";
                }else if(searchTypeIdx == 2){
                    type = @"imo";
                }else if(searchTypeIdx == 3){
                    type = @"mmsi";
                }
                [Util getSearchRecByKeyInShipBaseInfo:operid keystr:searchKey
                                           start_ship:[NSString stringWithFormat:@"%d",currentPage * ROW_PERQUERY + 1]
                                             end_ship:[NSString stringWithFormat:@"%d",(currentPage+1) * ROW_PERQUERY]
                                             shipType:type
                                               onComp:^(NSObject *responseData) {
                                                   [ApplicationDelegate dismissHUD];
                                                   [self appendResultArrayWithArray:(NSArray *)responseData];
                                               }];
            }
            return;
        } else {
            next.shipdict = [searchResults objectAtIndex:indexPath.row];
        }
    }
    else{
        //next.baseData = (ShipData*) [myfav objectAtIndex:indexPath.row];
        next.shipdict = [localArray objectAtIndex:indexPath.row];
    }
    [self.navigationController pushViewController:next animated:YES];
    RELEASE_SAFELY(next);
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
//        case 4:
//            resultPredicate = [NSPredicate predicateWithFormat:@"callSign contains[cd] %@", searchText];
//            break;
        default:
            break;
    }
    RELEASE_SAFELY(searchResults);
    searchResults = [[NSMutableArray arrayWithArray:[localArray filteredArrayUsingPredicate:resultPredicate]] retain];
}
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller
shouldReloadTableForSearchString:(NSString *)searchString
{
    
    int idx = [self.searchDisplayController.searchBar selectedScopeButtonIndex];
    //    NSString *searchField = [searchType objectAtIndex:idx];
    [self filterContentForSearchText:searchString typeIndex:idx];
    [self.searchDisplayController.searchResultsTableView reloadData];
    //                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
    //                                      objectAtIndex:[self.searchDisplayController.searchBar
    //                                                     selectedScopeButtonIndex]]];
    
    return NO;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller
shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    int idx = [self.searchDisplayController.searchBar selectedScopeButtonIndex];
    [self filterContentForSearchText:[self.searchDisplayController.searchBar text] typeIndex:idx];
    [self.searchDisplayController.searchResultsTableView reloadData];
    //                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
    //                                      objectAtIndex:searchOption]];
    
    return NO;
}

-(void) appendResultArrayWithArray:(NSArray *)shipArray
{
    if (shipArray == nil) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[searchResults count] inSection:0];
        UITableViewCell *cell = [self.searchDisplayController.searchResultsTableView cellForRowAtIndexPath:indexPath];
        cell.tag = 1;
        cell.textLabel.text = @"找不到更多结果";
        return;
    }
    NSMutableArray *insertIndexPaths = [NSMutableArray arrayWithCapacity:[shipArray count]];
    NSInteger count = [searchResults count];
    for (int ind = 0; ind < [shipArray count]; ind++) {
        NSIndexPath    *newPath =  [NSIndexPath indexPathForRow:count + ind inSection:0];
        [insertIndexPaths addObject:newPath];
    }
    [searchResults addObjectsFromArray:shipArray];
    [self.searchDisplayController.searchResultsTableView reloadData];
    NSString *path = [[Util getCachePath] stringByAppendingString:@"/searchHistory.plist"];
    [searchResults writeToFile:path atomically:YES];
    RELEASE_SAFELY(localArray);
    localArray = [searchResults copy];
//    [self.searchDisplayController.searchResultsTableView insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationFade];
}

-(void) searchBarSearchButtonClicked:(UISearchBar *)searchBar{

    [ApplicationDelegate displayHUD:self words:@"正在检索"];

    searchTypeIdx = [self.searchDisplayController.searchBar selectedScopeButtonIndex];
//    isNeedPage = YES;
    currentPage = 0;
    RELEASE_SAFELY(searchKey);
    searchKey = [searchBar.text copy];
   // NSStringEncoding gbk = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    
   // NSData *data = [[[NSData alloc] init ] autorelease];
   // NSMutableData *pageData  = [[[NSMutableData alloc] init ]autorelease];
   // [pageData appendData:data];
   // NSString *text = [[NSString alloc] init:pageData encoding:gbk];
   // searchKey = text;
    NSString *operid = [[NSUserDefaults standardUserDefaults ] objectForKey:@"operid"];
    NSString *type=@"";
    if (searchTypeIdx == 0){
        type = @"name";
    }else if(searchTypeIdx == 1){
        type = @"callsign";
    }else if(searchTypeIdx == 2){
        type = @"imo";
    }else if(searchTypeIdx == 3){
        type = @"mmsi";
    }
    [Util getSearchRecByKeyInShipBaseInfo:operid keystr:searchKey
                               start_ship:[NSString stringWithFormat:@"%d",currentPage * ROW_PERQUERY + 1]
                                 end_ship:[NSString stringWithFormat:@"%d",(currentPage+1) * ROW_PERQUERY]
                                 shipType:type
                                   onComp:^(NSObject *responseData) {
                                       [ApplicationDelegate dismissHUD];
                                       RELEASE_SAFELY(searchResults);
                                       searchResults = [[NSMutableArray arrayWithArray:(NSArray*)responseData] retain];
                                       [self.searchDisplayController.searchResultsTableView reloadData];
//                                       
//                                       [self appendResultArrayWithArray:(NSArray *)responseData];
                                   }];
}
-(void) searchBarCancelButtonClicked:(UISearchBar *)searchBar {
//    if ([searchResults count] > 0) {
        [self.tableView reloadData];
//    }
}
#pragma mark -
- (void)dealloc {
    [super dealloc];
    RELEASE_SAFELY(searchDisplayController);
//    RELEASE_SAFELY(localArray);
//    RELEASE_SAFELY(searchResults);
}

@end
