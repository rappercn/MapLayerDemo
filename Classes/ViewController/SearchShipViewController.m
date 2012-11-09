//
//  SearchShipController.m
//  MapLayerDemo
//
//  Created by 老王八 :D on 12-6-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SearchShipViewController.h"
#import "ShipData.h"
#import "ShipDetailViewController.h"
#import "JSONKit.h"
#import <CoreData/CoreData.h>
#import "ShipMajor.h"
#import "Util.h"
@implementation SearchShipViewController
@synthesize searchDisplayController, searchResults, myfav, searchType,inputShipName;
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
    rowsPerPage = 5;
    [super viewDidLoad];
    self.tableView.scrollEnabled = YES;
    //myfav = [[AppDelegate getMyFavArray] retain];
    myfav = [[AppDelegate getShipMajor] retain];
    //fen ye
    currentPage = 1;   
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

-(void)viewDidAppear:(BOOL)animated{
//    isNeedPage = NO;
//    ShipData * ship = [[[ShipData alloc] init] autorelease];
//    ship.shipName=@"123";
//    NSMutableArray *aa = [[NSMutableArray alloc] init];
//    [aa addObject:ship];
//    NSMutableArray *bb = [[NSMutableArray alloc] init];
//    [bb addObjectsFromArray:myfav];
//    [bb addObjectsFromArray:aa];
////    [myfav addObjectsFromArray:bb];
//    self.myfav = bb;
//    [aa release];
}

//-(void)viewWillAppear:(BOOL)animated{
//    [[self tableView] reloadData];
//}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows = 0;
    
    if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]){
        rows = [self.searchResults count];
    }
    else{
        rows = [myfav count];
    }
    if([tableView isEqual:self.searchDisplayController.searchResultsTableView] && isNeedPage){
        rows = rows + 1;   
    }
    return rows;
}

-(NSIndexPath *) tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView 
                             dequeueReusableCellWithIdentifier:CellIdentifier];
    if([cell.textLabel.text isEqualToString:@"没有更多数据了..."]){
        return nil;
    }
    return indexPath;
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
       if([indexPath row] == [searchResults count] && isNeedPage)  
        {  
            //新建一个单元格, 并且将其样式调整成我们需要的样子.  
            cell=[[UITableViewCell alloc] initWithFrame:CGRectZero   
                                        reuseIdentifier:@"LoadMoreIdentifier"];   
            cell.font = [UIFont boldSystemFontOfSize:13];    
            if(searchResults.count < rowsPerPage){
                cell.textLabel.text = @"没有更多数据了...";  
            }else{
                cell.textLabel.text = @"读取更多...";  
            }
        }else {
            cell.textLabel.text = ((ShipData*) [searchResults objectAtIndex:indexPath.row]).shipName; 
        }
    }
    else{
        cell.textLabel.text = ((ShipData*) [myfav objectAtIndex:indexPath.row]).shipName;
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
        ShipDetailViewController *next = [[ShipDetailViewController alloc] initWithNibName:@"ShipDetailViewController" bundle:nil];
        if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]){
            if([indexPath row] == [searchResults count] && isNeedPage)  
            {  
                UITableViewCell *loadMoreCell=[tableView cellForRowAtIndexPath:indexPath];     
                loadMoreCell.textLabel.text=@"正在读取更信息 …";
                //loadingAni = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(140, 150, 37, 37)];
                //loadingAni.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;   
//                [self.searchDisplayController.searchResultsTableView addSubview:loadingAni];
               // [self.view addSubview:loadingAni];
                [self performSelectorInBackground:@selector(loadMore) withObject:nil];     
                [tableView deselectRowAtIndexPath:indexPath animated:YES];     
                return;    
            } else {
                next.baseData = (ShipData*)[self.searchResults objectAtIndex:indexPath.row];
            }
        }
        else{
            next.baseData = (ShipData*) [myfav objectAtIndex:indexPath.row];
        }
        [self.navigationController pushViewController:next animated:YES];
}

#pragma mark - UISearchDisplayController delegate methods
- (void)filterContentForSearchText:(NSString*)searchText 
                             typeIndex:(int)typeIndex
{
//    NSPredicate *resultPredicate = [NSPredicate 
//                                    predicateWithFormat:@"SELF contains[cd] %@",
//                                    searchText];
//    NSPredicate *resultPredicate = [NSPredicate 
//                               predicateWithFormat:@"%@ contains[cd] %@",
//                               searchField,
//                               searchText];
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
        case 4:
            resultPredicate = [NSPredicate predicateWithFormat:@"callSign contains[cd] %@", searchText];
            break;
        default:
            break;
    }
    self.searchResults = [myfav filteredArrayUsingPredicate:resultPredicate];
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
    
    return NO;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller 
shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    int idx = [self.searchDisplayController.searchBar selectedScopeButtonIndex];
    [self filterContentForSearchText:[self.searchDisplayController.searchBar text] typeIndex:idx];
//                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
//                                      objectAtIndex:searchOption]];
    
    return NO;
}

-(void) searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    searchTypeIdx = [self.searchDisplayController.searchBar selectedScopeButtonIndex];
    isNeedPage = YES;
    inputShipName = [searchBar.text retain];
    //NSLog(searchBar.text);
    NSLog(@"zx coming");
    NSInteger start = 1;
    NSInteger end = rowsPerPage; 
  //  NSString *serviceUrl = [NSString stringWithFormat:@"http://test.ctrack.com.cn/ShipDBCAppServer/PhoneShipWebService?fm=getSearchRecByKeyInShipBaseInfo&&param_keystr=%@&&param_start_ship=%d&&param_end_ship=%d&&param_type=%d",searchBar.text,start,end,searchTypeIdx];
  //  NSString *json = [Util getServiceDataByJson:serviceUrl];
  //  NSDictionary *dataArray = [json mutableObjectFromJSONStringWithParseOptions:JKParseOptionLooseUnicode];
    NSDictionary *dataArray = [Util getSearchRecByKeyInShipBaseInfo:searchBar.text start_ship:[NSString stringWithFormat:@"%d",start] end_ship:[NSString stringWithFormat:@"%d",end] shipType:[NSString stringWithFormat:@"%d",searchTypeIdx]];
    NSArray *arrayDictionary = [dataArray objectForKey:@"return"];
    //NSArray *array = [arrayDictionary allKeys];
    NSMutableArray *resultTem = [[[NSMutableArray alloc] init ] autorelease];
    for(int i=0;i<arrayDictionary.count;i++){
        NSDictionary *serviceResult = [arrayDictionary objectAtIndex:i];
        ShipData *ship = [[[ShipData alloc] init] autorelease];
        [ship setShipName:[serviceResult objectForKey:@"shipname"]];
        if(searchTypeIdx == 0){

        }else if(searchTypeIdx == 1){
            [ship setCallSign:[serviceResult objectForKey:@"callsign"]];            
        }else if(searchTypeIdx == 2){
            [ship setImo:[serviceResult objectForKey:@"imo"]];            
        }else if(searchTypeIdx == 3){
            [ship setMmsi:[serviceResult objectForKey:@"mmsi"]];            
        }
        [ship setMobileId:[serviceResult objectForKey:@"shipid"]];
        [resultTem addObject:ship];
        [ship release];
        
    }
   // NSLog(@"totle %d",data.count);
   // NSLog(@"%@",[[data objectForKey:@"d"] objectForKey:@"name"]);
    
    self.searchResults = [resultTem retain];
    [self.searchDisplayController.searchResultsTableView reloadData];
    
    //insert major
    [self saveShipMajor:self.searchResults];
    
    //release 报错 arc
    //[json release];
    // [err release];
    
    //insert coreData
 


}

-(void)loadMore     
{   //当你按下这个按钮的时候, 意味着你需要看下一页了, 因此当前页码加1  
    currentPage ++;  
    NSMutableArray *more = [self GetRecord:currentPage]; //通过调用GetRecord方法, 将数据取出.  
    //insert major
    [self performSelectorOnMainThread:@selector(appendTableWith:) withObject:more waitUntilDone:NO];     
    [self saveShipMajor:more];
    
}     
-(void) appendTableWith:(NSMutableArray *)data     
{   //将loadMore中的NSMutableArray添加到原来的数据源listData中.  
   // [data retain];
    searchResults = [[NSMutableArray arrayWithArray:searchResults] retain];
    for (int i=0;i<[data count];i++) {     
        [searchResults addObject:[data objectAtIndex:i]];     
    }     
    NSMutableArray *insertIndexPaths = [NSMutableArray arrayWithCapacity:20];     
    for (int ind = 0; ind < [data count]; ind++) {     
        NSIndexPath    *newPath =  [NSIndexPath indexPathForRow:[searchResults indexOfObject:[data objectAtIndex:ind]] inSection:0];     
        [insertIndexPaths addObject:newPath];     
    }     
    //重新调用UITableView的方法, 来生成行.  
     // [self.searchDisplayController.searchResultsTableView reloadData];
   // [self.searchDisplayController retain];
   // [insertIndexPaths retain];
   // [UITableViewRowAnimationFade retain];
    [self.searchDisplayController.searchResultsTableView insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationFade];
    //[loadingAni stopAnimating]; 
}    


-(NSMutableArray *)GetRecord:(NSInteger)p  
{  
    //NSString *serviceUrl = [NSString stringWithFormat:@"http://test.ctrack.com.cn/ShipDBCAppServer/PhoneShipWebService?fm=getSearchRecByKeyInShipBaseInfo&&param_keystr=%@&&param_start_ship=%d&&param_end_ship=%d&&param_type=%d",inputShipName,currentPage * rowsPerPage,(currentPage+1) * rowsPerPage,searchTypeIdx];
    //NSString *json = [Util getServiceDataByJson:serviceUrl];
    //NSDictionary *dataArray = [json mutableObjectFromJSONStringWithParseOptions:JKParseOptionLooseUnicode];
    NSDictionary *dataArray = [Util getSearchRecByKeyInShipBaseInfo:inputShipName start_ship:[NSString stringWithFormat:@"%d",currentPage * rowsPerPage] end_ship:[NSString stringWithFormat:@"%d",(currentPage+1) * rowsPerPage] shipType:[NSString stringWithFormat:@"%d",searchTypeIdx]];
    NSArray *arrayDictionary = [dataArray objectForKey:@"return"];
    NSMutableArray *array = [[NSMutableArray alloc] init ];
    for(int i=0;i<arrayDictionary.count;i++){
        NSDictionary *serviceResult = [arrayDictionary objectAtIndex:i];
        ShipData *ship = [[[ShipData alloc] init] autorelease];
         [ship setShipName:[serviceResult objectForKey:@"shipname"]];
        if(searchTypeIdx == 0){
         
        }else if(searchTypeIdx == 1){
          [ship setCallSign:[serviceResult objectForKey:@"callsign"]];            
        }else if(searchTypeIdx == 2){
            [ship setImo:[serviceResult objectForKey:@"imo"]];            
        }else if(searchTypeIdx == 3){
            [ship setMmsi:[serviceResult objectForKey:@"mmsi"]];            
        }
        [ship setMobileId:[serviceResult objectForKey:@"shipid"]];
        [array addObject:ship];
       // [ship release];
    }
    return [array autorelease];  
}  

-(void)saveShipMajor:(NSMutableArray*) searchResultMore {
    NSMutableArray *insertArray = [[[NSMutableArray alloc] init] autorelease];
    for(int i=0;i<searchResultMore.count;i++){
        NSManagedObjectContext *context = [AppDelegate getManagedObjectContext];
        NSManagedObject *object = [NSEntityDescription insertNewObjectForEntityForName:@"ShipMajor" inManagedObjectContext:context];
        ShipData *ship = [searchResultMore objectAtIndex:i];
        
        NSPredicate *resultPredicate;
        resultPredicate = [NSPredicate predicateWithFormat:@"shipName = %@", ship.shipName];
        NSArray *tem = [myfav filteredArrayUsingPredicate:resultPredicate];
        
        if(tem.count ==0 ){
            if(searchTypeIdx == 0){

            }else if(searchTypeIdx == 1){
                 [object setValue:ship.callSign forKey:@"callSign"];
            }else if(searchTypeIdx == 2){
                 [object setValue:ship.imo forKey:@"imo"];
            }else if(searchTypeIdx == 3){
                 [object setValue:ship.mmsi forKey:@"mmsi"];
            }
            [object setValue:ship.shipName forKey:@"shipName"];
            [object setValue:ship.mobileId forKey:@"mobileId"];
           // 插入数据库暂时注销
           // [self saveContext:context];
            [insertArray addObject:ship];
           // ShipMajor *major = [[[ShipMajor alloc] init ] autorelease];
           // major.shipName = @"aaa";
        
        }
    }
    if(insertArray.count !=0){
        [insertArray addObjectsFromArray:myfav];
        NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"shipName" ascending:YES];
        NSArray *sorts = [[NSArray alloc] initWithObjects:sort,nil];
        [insertArray sortUsingDescriptors:sorts];
        self.myfav=insertArray;
        [sorts release];
        [sort release];
        [self.tableView reloadData];
    }
}

- (void)saveContext:(NSManagedObjectContext*) managedObjectContext
{
    NSError *error = nil;
   // NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil)
    {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error])
        {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }else{

        }
    }
}

-(void)whichShoudSetByIdx:(int) idx{
    if(idx == 1){
        
    }
}


#pragma mark -
- (void)dealloc {
    [searchDisplayController release];
    [myfav release];
    myfav = nil;
    [searchResults release];
    searchResults = nil;
   // [loadingAni release];
    [inputShipName release];
    inputShipName = nil;
    [searchType release];
    searchType = nil;
    [super dealloc];
}

@end
