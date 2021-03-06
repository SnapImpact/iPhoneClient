//
//  EventDetailsTableViewController.h
//  iPhone
//
//  Created by Ryan Schneider on 3/1/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event.h"
#import "EventDetailsHeaderCell.h"
#import "ActionsView.h"
#import "BusyIndicatorDelegate.h"
#import "RegisterConfirmationViewController.h"

enum Actions {
    kOpenURL,
    kSendEmail,
    kMakeCall
};

@interface EventDetailsTableViewController : UITableViewController<RegisterConfirmationProtocol, UIActionSheetDelegate> {
   id <BusyIndicatorDelegate> busyIndicatorDelegate;
   Event* event;
   EventDetailsHeaderCell* headerCell;
   ActionsView* headerActions;
   UIFont* reallySmallFont;
   UIFont* smallFont;
   UIFont* mediumFont;
   UIFont* largeFont;
   IBOutlet UIView* floatingView;
   int descriptionHeight;
   enum Actions action;
   id action_data;
}

@property (nonatomic, retain) UIView *floatingView;
@property (nonatomic,retain) id <BusyIndicatorDelegate> busyIndicatorDelegate;
@property (retain) Event* event;
@property (retain) EventDetailsHeaderCell* headerCell;
@property (retain) ActionsView* headerActions;
@property (retain) UIFont* reallySmallFont;
@property (retain) UIFont* smallFont;
@property (retain) UIFont* mediumFont;
@property (retain) UIFont* largeFont;

- (void) didConfirmRegistration;
- (void) didCancelRegistration;

+ (id) viewWithEvent: (Event*) event;

@end

