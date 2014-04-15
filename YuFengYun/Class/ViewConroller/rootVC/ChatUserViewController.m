//
//  LeftViewController.m
//  YunHuaShiDai
//
//  Created by 董德富 on 13-6-5.
//  Copyright (c) 2013年 董德富. All rights reserved.
//

#import "ChatUserViewController.h"
#import <CoreData/CoreData.h>
#import "XMPPCenter.h"
#import "ChatMessageViewController.h"

#import "YFYLocation.h"
#import "AlertUtility.h"

@interface ChatUserViewController ()
<
UITableViewDataSource,
UITableViewDelegate,
NSFetchedResultsControllerDelegate
>

@property (nonatomic, weak) IBOutlet UITableView *table;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@end

@implementation ChatUserViewController
- (NSFetchedResultsController *)fetchedResultsController {
	if (!_fetchedResultsController) {
		NSManagedObjectContext *moc = [XMPP_CENTER managedObjectContext_roster];
		
		NSEntityDescription *entity = [NSEntityDescription entityForName:@"XMPPUserCoreDataStorageObject"
		                                          inManagedObjectContext:moc];
		
		NSSortDescriptor *sd1 = [[NSSortDescriptor alloc] initWithKey:@"sectionNum" ascending:YES];
		NSSortDescriptor *sd2 = [[NSSortDescriptor alloc] initWithKey:@"displayName" ascending:YES];
		
		NSArray *sortDescriptors = [NSArray arrayWithObjects:sd1, sd2, nil];
		
		NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
		[fetchRequest setEntity:entity];
		[fetchRequest setSortDescriptors:sortDescriptors];
		[fetchRequest setFetchBatchSize:10];
		
		_fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                        managedObjectContext:moc
                                                                          sectionNameKeyPath:@"sectionNum"
                                                                                   cacheName:nil];
		_fetchedResultsController.delegate = self;
		
		
		NSError *error = nil;
		if (![_fetchedResultsController performFetch:&error]) {
			DEBUG_LOG_(@"Error performing fetch: %@", error);
		}
	}
	return _fetchedResultsController;
}


#pragma mark - View lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setBackNavButtonActionPop];
    
    [self.view sendSubviewToBack:self.navigationBar];
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:@"test1@ddfmac.local" forKey:@"user"];
    [user setObject:@"ddf" forKey:@"password"];
    
    [XMPP_CENTER xmppConnect];
    
    self.navigationBar.title = [XMPP_CENTER xmppStream].myJID.bare;
    
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //    [XMPP disconnect];
    //	[[XMPP xmppvCardTempModule] removeDelegate:self];
}

#pragma mark - data
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
	[self.table reloadData];
}

#pragma mark UITableView
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return [[[self fetchedResultsController] sections] count];
}
- (NSString *)tableView:(UITableView *)sender titleForHeaderInSection:(NSInteger)sectionIndex {
	NSArray *sections = [self.fetchedResultsController sections];
	
	if (sectionIndex < [sections count])
	{
		id <NSFetchedResultsSectionInfo> sectionInfo = [sections objectAtIndex:sectionIndex];
        
		int section = [sectionInfo.name intValue];
		switch (section) {
			case 0  : return @"Available";
			case 1  : return @"Away";
			default : return @"Offline";
		}
	}
	
	return @"";
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex {
	NSArray *sections = [self.fetchedResultsController sections];
	
	if (sectionIndex < [sections count]) {
		id <NSFetchedResultsSectionInfo> sectionInfo = [sections objectAtIndex:sectionIndex];
		return sectionInfo.numberOfObjects;
	}
	
	return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"Cell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
	}
	
	XMPPUserCoreDataStorageObject *user = [self.fetchedResultsController objectAtIndexPath:indexPath];
    DEBUG_LOG_(@"%@", user);
	
	cell.textLabel.text = user.displayName;
    
	if (user.photo != nil) {
		cell.imageView.image = user.photo;
	} else {
		NSData *photoData = [[XMPP_CENTER xmppvCardAvatarModule] photoDataForJID:user.jid];
        
		if (photoData != nil)
			cell.imageView.image = [UIImage imageWithData:photoData];
		else
			cell.imageView.image = [UIImage imageNamed:@"firstPage_left_item1"];
	}
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    XMPPUserCoreDataStorageObject *user = [self.fetchedResultsController objectAtIndexPath:indexPath];
    NSString *jidString = user.jidStr;
    DEBUG_LOG_(@"%@", jidString);
    
    ChatMessageViewController *chat = [[ChatMessageViewController alloc] initWithUser:user];
    [self.navigationController pushViewController:chat animated:YES];
}


@end
