//
//  SplashViewController.m
//  iPhone
//
//  Created by Aubrey Francois on 10/18/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "SplashViewController.h"
#import "iVolunteerData.h"

@implementation SplashViewController
@synthesize dismissalDelegate;
@synthesize busyIndicatorDelegate;
@synthesize zipcodeField;
@synthesize scrollView;

/*
// Override initWithNibName:bundle: to load the view using a nib file then perform additional customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view.
- (void)viewDidLoad {
	self.zipcodeField.hidden = YES;
	scrollView.contentSize = CGSizeMake(320, 550);
    [super viewDidLoad];
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
	[(NSObject *) self.dismissalDelegate release];
	[(NSObject *) self.busyIndicatorDelegate release];
	[self.zipcodeField release];
	[self.scrollView release];
	
    [super dealloc];
}

- (IBAction)splashOk:(id)sender forEvent:(UIEvent*)event
{
	[dismissalDelegate dismissScreen];
}

- (IBAction)dismissKeyboard
{
	[self.zipcodeField resignFirstResponder];
	if ([self.zipcodeField.text length] == 5)
	{
		iVolunteerData *data = [iVolunteerData sharedVolunteerData];
		data.homeZip = self.zipcodeField.text;
	}
	
}

- (IBAction)zipcodeUpdated
{
	if ([self.zipcodeField.text length] >= 5)
	{
		[self dismissKeyboard];
	}
}

-(IBAction)scrollDown
{
	[self.scrollView setContentOffset:CGPointMake(0,100) animated:YES];
}

-(IBAction)scrollUp
{
	[self.scrollView setContentOffset:CGPointMake(0,0) animated:YES];
}

#pragma mark -
#pragma mark LocationAvailabilityDelegate methods

- (void)locationIsAvailable:(CLLocation *)location
{
	[self.busyIndicatorDelegate stopAnimating];
	
	if (!location)
	{
		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Could Not Determine Location" 
														message:@"Enter the zip code from which you would like to use to find volunteer opportunities." 
													   delegate:nil 
											  cancelButtonTitle:@"Ok"
											  otherButtonTitles:nil];
		[alert show];
		[alert release];
		
		self.zipcodeField.hidden = NO;
	}
}

@end
