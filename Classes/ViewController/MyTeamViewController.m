//
//  mycompSecondViewController.m
//  Chuanbao
//
//  Created by 老王八 :D on 12-6-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MyTeamViewController.h"
//#import "ShipData.h"
//#import "ShipDetailViewController.h"
#import "SectionHeaderView.h"
#import "MyFavDetailViewController.h"

@implementation MyTeamViewController
@synthesize shipListTableView, openSectionIndex;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"我的船队";//NSLocalizedString(@"Second", @"Second");
        self.tabBarItem.image = [UIImage imageNamed:@"myteamLogo"];
    }
    return self;
}
							
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
//    AppDelegate* delegate = [AppDelegate getAppDelegate];
//    myFav = delegate.myfav;
    shipListTableView.delegate = self;
    openSectionIndex = NSNotFound;
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    favArray = [[[NSArray alloc] initWithObjects:[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"comname%@",userId]], nil] retain];
    teamArray = [[[NSMutableArray alloc] initWithCapacity:favArray.count] retain];
   // NSArray* tmpArray = [[NSArray alloc] initWithObjects:@"默认船队", nil];
     NSMutableArray* tmpArray = [[NSMutableArray alloc] init];
    NSDictionary *myShipGroups = [Util getCompanyGroups:userId];
    NSArray *myShipArray = [myShipGroups objectForKey:@"return"];
    for(int i=0;i<myShipArray.count;i++){
        NSString *groupId = [[myShipArray objectAtIndex:i] objectForKey:@"groupid"];
        NSString *groupName = [[myShipArray objectAtIndex:i] objectForKey:@"groupname"];
        NSDictionary *groupTem = [NSDictionary dictionaryWithObjectsAndKeys:groupId,@"groupId",groupName,@"groupName",nil];
        [tmpArray addObject:groupTem];
    }
   
    [teamArray addObject:tmpArray];
   // [tmpArray release];
   // tmpArray = nil;
   // tmpArray = [[NSArray alloc] initWithObjects:@"船队A", @"船队B", nil];
   // [teamArray addObject:tmpArray];
   // [tmpArray release];
   // tmpArray = nil;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark- TableView DataSource

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return [favArray count];
//    return [myFav count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (flag[section]) {
        return [[teamArray objectAtIndex:section] count];
//        return myFav.count;
    } else {
        return 0;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    ShipDetailViewController *next = [[ShipDetailViewController alloc] initWithNibName:@"ShipDetailViewController" bundle:nil];
//    next.baseData = [myFav objectAtIndex:indexPath.row];
    MyFavDetailViewController *next = [[MyFavDetailViewController alloc] initWithNibName:@"MyFavDetailViewController" bundle:nil];
    next.favArray = [teamArray objectAtIndex:indexPath.section];
    next.openSectionIndex = indexPath.row;
    next.title = [tableView cellForRowAtIndexPath:indexPath].textLabel.text;
    next.groupId = [[[teamArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"groupId"];
    [self.navigationController pushViewController:next animated:YES];
    
    [next release];
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
    NSDictionary *tem = [[teamArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.textLabel.text = [@"    " stringByAppendingString:[tem objectForKey:@"groupName"]];
//    ShipData* rowData = [myFav objectAtIndex:indexPath.row];
//    cell.textLabel.text = rowData.shipName;

    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (sectionArray[section] == nil) {

        NSString* title = [favArray objectAtIndex:section];
        SectionHeaderView* header = [[SectionHeaderView alloc] initWithFrame:CGRectMake(0.0, 0.0, shipListTableView.bounds.size.width, 42)
                                                                   title:title
                                                                 section:section
                                                                  opened:NO
                                                                delegate:self
                                                           courseSection:YES];
        sectionArray[section] = header;
    }
    return sectionArray[section];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return 42;
}
-(void)sectionHeaderView:(SectionHeaderView*)sectionHeaderView sectionClosed:(NSInteger)section
{
    flag[section] = NO;
	// 收缩+动画 (如果不需要动画直接reloaddata)
	NSInteger countOfRowsToDelete = [self.shipListTableView numberOfRowsInSection:section];
    NSMutableArray *indexPathsToDelete = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < countOfRowsToDelete; i++) {
        [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:i inSection:section]];
    }
    [self.shipListTableView deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:UITableViewRowAnimationTop];
    NSLog(@"section header closed : delete %d rows from section %d", countOfRowsToDelete, section);
    openSectionIndex = NSNotFound;

}
-(void)sectionHeaderView:(SectionHeaderView*)sectionHeaderView sectionOpened:(NSInteger)section
{
	flag[section] = YES;

    /*
     Create an array containing the index paths of the rows to insert: These correspond to the rows for each quotation in the current section.
     */
    NSInteger countOfRowsToInsert = [[teamArray objectAtIndex:section] count];
    NSMutableArray *indexPathsToInsert = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < countOfRowsToInsert; i++) {
        [indexPathsToInsert addObject:[NSIndexPath indexPathForRow:i inSection:section]];
    }
    
    /*
     Create an array containing the index paths of the rows to delete: These correspond to the rows for each quotation in the previously-open section, if there was one.
     */
    NSMutableArray *indexPathsToDelete = [[NSMutableArray alloc] init];
    
    NSInteger previousOpenSectionIndex = openSectionIndex;
    if (previousOpenSectionIndex != NSNotFound) {
		flag[previousOpenSectionIndex] = NO;
        [sectionArray[previousOpenSectionIndex] toggleAction:NO];
        [sectionArray[previousOpenSectionIndex].disclosureButton setBackgroundImage:[UIImage imageNamed:@"sectionHeaderClose.png"] forState:UIControlStateNormal];
        NSInteger countOfRowsToDelete = [[teamArray objectAtIndex:openSectionIndex] count];
        for (NSInteger i = 0; i < countOfRowsToDelete; i++) {
            [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:i inSection:previousOpenSectionIndex]];
        }

    }
    
    // Style the animation so that there's a smooth flow in either direction.
    UITableViewRowAnimation insertAnimation;
    UITableViewRowAnimation deleteAnimation;
    if (previousOpenSectionIndex == NSNotFound || section < previousOpenSectionIndex) {
        insertAnimation = UITableViewRowAnimationTop;
        deleteAnimation = UITableViewRowAnimationBottom;
    }
    else {
        insertAnimation = UITableViewRowAnimationBottom;
        deleteAnimation = UITableViewRowAnimationTop;
    }
    NSLog(@"section header opened : insert %d rows into section %d", countOfRowsToInsert, section);
    // Apply the updates.
    [shipListTableView beginUpdates];
    [shipListTableView insertRowsAtIndexPaths:indexPathsToInsert withRowAnimation:insertAnimation];
    [shipListTableView deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:deleteAnimation];
    [shipListTableView endUpdates];
    openSectionIndex = section;
    indexPathsToInsert = nil;
    [indexPathsToInsert release];
    indexPathsToDelete = nil;
    [indexPathsToDelete release];
}
@end
