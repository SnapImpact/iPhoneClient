//
//  EventDetailsTableViewController.m
//  iPhone
//
//  Created by Ryan Schneider on 3/1/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "EventDetailsTableViewController.h"
#import "iVolunteerData.h"
#import "StringUtilities.h"
#import "iPhoneAppDelegate.h"

@implementation EventDetailsTableViewController

@synthesize floatingView;
@synthesize event;
@synthesize headerCell;
@synthesize headerActions;
@synthesize smallFont;
@synthesize mediumFont;
@synthesize largeFont;
@synthesize busyIndicatorDelegate;
@synthesize reallySmallFont;

#pragma mark Constants
#define kSectionsCount 4

#define kSectionDetailsHeader 0
#define kSectionDetailsHeaderRowCount 1
#define kSectionDetailsHeaderRow 0

#define kSectionDescription 1
#define kSectionDescriptionRowCount 1
#define kSectionDescriptionRow 0

#define kSectionContactInfo 2
#define kSectionContactInfoRowCount 4
#define kSectionContactInfoRowName 0
#define kSectionContactInfoRowPhone 1
#define kSectionContactInfoRowEmail 2
#define kSectionContactInfoRowSource 3

#define kSectionInterestAreas 3
#define kSectionInterestAreasRowCount #error not supported

#define SetOrigin(view,x,y) view.frame = CGRectMake(x, y, view.frame.size.width, view.frame.size.height)
#define SetSize(view,width,height) view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, width, height)
#define SetFrame(view,x,y,width,height) view.frame = CGRectMake(x, y, width, height)
#define GetSize(label) [label.text sizeWithFont:label.font constrainedToSize:CGSizeMake(label.frame.size.width, label.frame.size.height) lineBreakMode:UILineBreakModeWordWrap]
#define RePackLabel(label) SetFrame(label, label.frame.origin.x, label.frame.origin.y, label.frame.size.width,GetSize(label).height)


#pragma mark Allocator

+ (id) viewWithEvent: (Event*) event
{
    EventDetailsTableViewController* view = [[[EventDetailsTableViewController alloc] initWithStyle: UITableViewStyleGrouped ] autorelease ];
    view.event = event;
    return view;
}

#pragma mark Property Override

- (void) setEvent: (Event*) event_ 
{
    if(event != nil)
        [event release];
    
    event = [event_ retain];
    self.headerCell.event = event;
    self.navigationItem.title = event.name;
    
    
    [self.tableView reloadData];
}

#pragma mark UITableViewController methods

- (void)viewDidLoad {
    
    if([event.signedUp boolValue]) {
        // do something something to show your signed up
    }
    else {
        UIBarButtonItem *registerButton = [[UIBarButtonItem alloc] initWithTitle:@"Register"
																		   style:UIBarButtonItemStyleDone 
																		  target:self 
																		  action:@selector(signUp)];
		self.navigationItem.rightBarButtonItem = registerButton;
		[registerButton release];
		
    }
	self.reallySmallFont = [UIFont systemFontOfSize: 10 ];
	self.smallFont = [UIFont systemFontOfSize: 14 ];
	self.mediumFont = [UIFont systemFontOfSize: 16 ];
	self.largeFont = [UIFont systemFontOfSize: 18 ];
	
	[super viewDidLoad];
}



- (void)viewWillAppear:(BOOL)animated {
	//let's go ahead and build descriptionCell, makes life easier
    
    [super viewWillAppear:animated];
}

/*
 - (void)viewDidAppear:(BOOL)animated {
 [super viewDidAppear:animated];
 }
 */
/*
 - (void)viewWillDisappear:(BOOL)animated {
 [super viewWillDisappear:animated];
 }
 */
/*
 - (void)viewDidDisappear:(BOOL)animated {
 [super viewDidDisappear:animated];
 }
 */

/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch(section) {
        case kSectionDetailsHeader:
            return kSectionDetailsHeaderRowCount;
        case kSectionDescription:
            return kSectionDescriptionRowCount;
        case kSectionContactInfo:
            return kSectionContactInfoRowCount;
        case kSectionInterestAreas:
            return [self.event.interestAreas count];
    }
    
    NSAssert( NO, @"Invalid section. ");
    return 0;
}

- (UITableViewCell*) cellForDetailsHeader: (NSUInteger) row
{
    NSAssert( row == kSectionDetailsHeaderRow, @"Only coded to support one row in DetailsHeader section!");
    
    if( self.headerCell == nil ) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed: @"EventDetailsHeaderCell" owner: self options: nil ];
        self.headerCell = [nib objectAtIndex:0];
    }
    
    self.headerCell.event = self.event;
    return self.headerCell;
}



- (UITableViewCell*) cellForDescription: (NSUInteger) row 
{
	UITableViewCell *descriptionCell_ = [[[UITableViewCell alloc] initWithFrame: CGRectZero reuseIdentifier: @"Description" ] autorelease];
	descriptionCell_.textLabel.text = self.event.details;
	descriptionCell_.textLabel.font = self.smallFont;
	NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:kSectionDescription];
	CGFloat height = [self tableView:self.tableView heightForRowAtIndexPath:indexPath];
	SetSize(descriptionCell_.textLabel, descriptionCell_.textLabel.frame.size.width, height);
	descriptionCell_.textLabel.numberOfLines = 0;
	
    return descriptionCell_;
}

- (UITableViewCell*) cellForContactInfoRow:(NSInteger) row 
{
	UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:nil] autorelease];
	cell.detailTextLabel.font = self.smallFont;
	cell.textLabel.font = self.smallFont;
    
    //NSString* mapString = NSLocalizedString(@"Map", nil);
    NSString* callString = NSLocalizedString(@"Call", nil);
    NSString* mailString = NSLocalizedString(@"Email", nil);
    NSString* contactString = NSLocalizedString(@"Contact", nil);
    NSString* sourceString = NSLocalizedString(@"Source", nil);
    //align it with interest areas section as well
    NSString* interestAreaString;
    if( [self.event.interestAreas count] > 1 ) {
        interestAreaString = NSLocalizedString( @"Interest Areas", @"plural of Interest Area" );
    }
    else {
        interestAreaString = NSLocalizedString( @"Interest Area", nil );
    }
    
    NSString* notAvailableString = @"Not Available";

    
    switch(row) {
        case kSectionContactInfoRowName:
			cell.textLabel.text = contactString;
            if([self.event.contact.name length]) {
				cell.detailTextLabel.text = self.event.contact.name;
            }
            else {
				cell.detailTextLabel.text = notAvailableString;
            }
            break;
        case kSectionContactInfoRowPhone:
			cell.textLabel.text = callString;
            if([self.event.contact.phone length]) {
				cell.detailTextLabel.text = self.event.contact.phone;
            }
            else {
				cell.detailTextLabel.text = notAvailableString;
            }
            break;
        case kSectionContactInfoRowEmail:
			cell.textLabel.text = mailString;
            if([self.event.contact.email length]) {
				cell.detailTextLabel.text = self.event.contact.email;
            }
            else {
				cell.detailTextLabel.text = notAvailableString;
            }
            break;
        case kSectionContactInfoRowSource:
			cell.textLabel.text = sourceString;
            if(self.event.url) {
				cell.detailTextLabel.text = [self.event.url absoluteString];
            }
            else if([self.event.source.name length]) {
				cell.detailTextLabel.text = self.event.source.name;
            }
            else {
				cell.detailTextLabel.text = notAvailableString;
            }
            break;
    }
    
    return cell;
}

- (UITableViewCell*) cellForInterestArea:(NSInteger) row 
{
    NSString* interestAreaString;
    if( [self.event.interestAreas count] > 1 ) {
        interestAreaString = NSLocalizedString( @"Areas", @"plural of Interest Area" );
    }
    else {
        interestAreaString = NSLocalizedString( @"Area", nil );
    }
	UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:nil] autorelease];
	cell.detailTextLabel.font = self.smallFont;
	cell.textLabel.font = self.smallFont;
    
    NSString* value = [[self.event.interestAreas objectAtIndex: row] name];
    
    if( row == 0 ) {
		cell.textLabel.text = interestAreaString;
		cell.detailTextLabel.text = value;

    }
    else {
		cell.textLabel.text = @" ";
		cell.detailTextLabel.text = value;
    }
    
    return cell;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSUInteger row = indexPath.row;
    NSUInteger section = indexPath.section;
    
    switch(section) {
        case 0:
            return [self cellForDetailsHeader: row ];
        case 1:
            return [self cellForDescription: row ];
        case 2:
            return [self cellForContactInfoRow: row ];
        case 3:
            return [self cellForInterestArea: row ];
    }   
    
    NSString* err = [ NSString stringWithFormat: @"Unrecognized indexPath: section %d, row %d.", section, row]; 
    NSAssert( NO, err );
    return nil;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = indexPath.row;
    NSUInteger section = indexPath.section;
    
    if( section == kSectionDetailsHeader) {
        NSAssert( row == kSectionDetailsHeaderRow, @"Unsupported Row Id for DetailsHeader" );
        return [EventDetailsHeaderCell height];
    }
    else if ( section == kSectionDescription ) {
        NSAssert( row == kSectionDescriptionRow, @"Unsupported Row Id for Description" );
        int operatingWidth = [[UIScreen mainScreen] bounds].size.width - (self.tableView.sectionHeaderHeight * 4);
        CGSize size = [self.event.details sizeWithFont: self.smallFont 
                       constrainedToSize: CGSizeMake(operatingWidth - 20, 1000 ) 
                       lineBreakMode: UILineBreakModeWordWrap ];
		BOOL deviceIsPad = (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPhone);
		if (deviceIsPad)
		{
			 return size.height + 40;
		}
		else 
		{
			 return size.height + 20;
		}
    }
    
    return self.tableView.rowHeight; 
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if( section == 0)
        return self.headerActions;
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if( section == kSectionDetailsHeader ) {
        CGFloat standardFooter = self.tableView.sectionFooterHeight;
        return [self.headerActions height] + standardFooter;
    }
    
    return 0;
}

- (void) makeCall:(NSString*) phoneNumber {
    if((phoneNumber == nil) || ([phoneNumber length] == 0)) {
        return;
    }
    
    NSRange xRange = [phoneNumber rangeOfString:@"x"];
    if (xRange.length > 0 && xRange.location >= 12) {
        // 222-222-2222 x222
        // remove extension
        phoneNumber = [phoneNumber substringToIndex:xRange.location];
    }
    
    action = kMakeCall;
    action_data = phoneNumber;
    
    
    if (![[[UIDevice currentDevice] model] isEqual:@"iPhone"]) {
        UIActionSheet* sheet = [[UIActionSheet alloc] 
                                initWithTitle: @"Select an action"
                                delegate: self
                                cancelButtonTitle: @"Cancel" 
                                destructiveButtonTitle: nil
                                otherButtonTitles: @"Copy Phone Number",nil
                                ];
        
        [iPhoneAppDelegate showActionSheet: sheet];
    }
    else {
        UIActionSheet* sheet = [[UIActionSheet alloc] 
                                initWithTitle: @"Select an action"
                                delegate: self
                                cancelButtonTitle: @"Cancel" 
                                destructiveButtonTitle: nil
                                otherButtonTitles: @"Copy Phone Number", @"Call", nil
                                ];
        [iPhoneAppDelegate showActionSheet: sheet];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    NSLog(@"Action: %d Data: %@ Button: %d", action, action_data, buttonIndex);
    
    @try {
        switch(action) {
            case kOpenURL:
                switch(buttonIndex) {
                    case 0:
                        //Copy
                        [UIPasteboard generalPasteboard].URL = (NSURL*) action_data;
                        break;
                    case 1:
                        //Open
                        [[UIApplication sharedApplication] openURL: (NSURL*) action_data ];
                        break;
                    case 2:
                        //Cancel
                        break;
                        
                }
                break;
            case kMakeCall:
            {
                NSURL* url = [NSURL URLWithString: [NSString stringWithFormat:@"tel:%@", 
                                                    [StringUtilities stringByAddingPercentEscapes:action_data]]];
                switch(buttonIndex) {
                    case 0:
                        //Copy
                        [UIPasteboard generalPasteboard].string = (NSString*) action_data;
                        break;
                    case 1:
                        //Call (or cancel..)
                        if(actionSheet.numberOfButtons > 2) {
                            NSLog(@"Calling... %@", url);
                            [[UIApplication sharedApplication] openURL: url ];
                            NSLog(@"Called.");
                        }
                        break;
                    case 2:
                        //Cancel
                        break;
                }
            }
                break;
            case kSendEmail:
                switch(buttonIndex) {
                    case 0:
                        //Copy
                        [UIPasteboard generalPasteboard].string = (NSString*) action_data;
                        break;
                    case 1:
                        //Send email
                        [[UIApplication sharedApplication] openURL: [NSURL URLWithString: [NSString stringWithFormat: @"mailto:%@", self.event.contact.email ]]];
                        break;
                    case 2:
                        //Cancel
                        break;
                }
                break;
        }
    }
    @catch(...) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Unsupported" 
                                                        message: @"Operation unsupported.  You may need to upgrade to a more recent iPhone OS."
                                                       delegate:nil
                                              cancelButtonTitle: @"Ok"
                                              otherButtonTitles: nil ];
        [alert show];
        [alert release];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	// AnotherViewController *anotherViewController = [[AnotherViewController alloc] initWithNibName:@"AnotherView" bundle:nil];
	// [self.navigationController pushViewController:anotherViewController];
	// [anotherViewController release];
    NSUInteger section = indexPath.section;
    NSUInteger row = indexPath.row;
    
    UIViewController* subView = nil;
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch(section) {
        case kSectionDetailsHeader:
            break;
        case kSectionDescription:
            break;
        case kSectionContactInfo:
            switch(row) {
                case kSectionContactInfoRowName:
                    //add new contact?
                    break;
                case kSectionContactInfoRowPhone:
                    //call
                    @try {
                        [self makeCall: self.event.contact.phone];
                    }
                    @catch(...) {
                    }
                    break;
                case kSectionContactInfoRowEmail:
                    //email
                    @try {
                        UIActionSheet* sheet = [[UIActionSheet alloc] 
                                                initWithTitle: @"Select an action"
                                                delegate: self
                                                cancelButtonTitle: @"Cancel" 
                                                destructiveButtonTitle: nil
                                                otherButtonTitles: @"Copy", @"Send e-mail", nil
                                                ];
                        action = kSendEmail;
                        action_data = self.event.contact.email;
                        if((!action_data) || ([action_data length] == 0)) {
                            return;
                        }
                        [iPhoneAppDelegate showActionSheet: sheet];
                    }
                    @catch(...) {
                    }
                    break;
                case kSectionContactInfoRowSource:
                {
                    NSURL* url = nil;
                    if(self.event.url) {
                        url = self.event.url;
                    }
                    else {
                        url = self.event.source.url; 
                    }
                    if(url) {
                        UIActionSheet* sheet = [[UIActionSheet alloc] 
                                                initWithTitle: @"Select an action"
                                                delegate: self
                                                cancelButtonTitle: @"Cancel" 
                                                destructiveButtonTitle: nil
                                                otherButtonTitles: @"Copy URL", @"Open in Safari", nil
                                                ];
                        action = kOpenURL;
                        action_data = (id) url;
                        [iPhoneAppDelegate showActionSheet: sheet];
                    }
                }   
                    break;
            }
            break;
        case kSectionInterestAreas:
            break;
    }
    
    if(subView) {
        [self.navigationController pushViewController:subView animated: YES];
        [subView release];
    }
}


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */


/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
 }   
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }   
 }
 */


/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */


/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */


- (void)dealloc {
	[(NSObject *) busyIndicatorDelegate release];
	[event release];
	[headerCell release];
	[headerActions release];
	[smallFont release];
	[mediumFont release];
	[largeFont release];
	[reallySmallFont release];
    self.floatingView = nil;
    [super dealloc];
}

#pragma mark Action Callbacks
- (void) signUp {
    if (![self.event.signedUp boolValue]) {
        UIWindow* window = [[UIApplication sharedApplication].windows objectAtIndex: 0];
        [RegisterConfirmationViewController displaySheetForEvent: self.event inWindow: window delegate: self];
    }
}

- (void) didConfirmRegistration {
   
    self.event.signedUp = [NSNumber numberWithBool: YES];
    [[iVolunteerData sharedVolunteerData] updateMyEventsDataSource: self.event];
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle: @"Registered" 
                                                    message: @"An e-mail has been sent to the event organizer.  The event organizer will contact you." 
                                                   delegate: nil 
                                          cancelButtonTitle: @"Ok" 
                                          otherButtonTitles: nil];
    [alert show];
    [alert release];
}

- (void) didCancelRegistration {
}

@end


