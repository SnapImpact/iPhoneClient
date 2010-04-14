//
//  EventDetailsHeaderViewController.m
//  iPhone
//
//  Created by Ryan Schneider on 2/28/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "EventDetailsHeaderCell.h"
#import "DateUtilities.h"

@implementation EventDetailsHeaderCell

@synthesize event;
@synthesize name;
@synthesize organization;
@synthesize date;
@synthesize time;

#define SetOrigin(view,x,y) view.frame = CGRectMake(x, y, view.frame.size.width, view.frame.size.height)
#define SetSize(view,width,height) view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, width, height)
#define SetFrame(view,x,y,width,height) view.frame = CGRectMake(x, y, width, height)
#define GetSize(label) [label.text sizeWithFont:label.font constrainedToSize:CGSizeMake(label.frame.size.width, label.frame.size.height) lineBreakMode:UILineBreakModeWordWrap]
#define RePackLabel(label) SetFrame(label, label.frame.origin.x, label.frame.origin.y, label.frame.size.width,GetSize(label).height)


+ (NSString*) reuseIdentifier
{
   return @"EventDetailsHeaderCell";
}

+ (CGFloat) height
{
   return 100;
}

- (void) setEvent: (Event*) event_ 
{
   if(event)
      [event release];
   
   event = [event_ retain];
   self.name.text = event_.name;
   RePackLabel(self.name);
   self.organization.text = event_.organization.name;
   self.date.text = [[[NSString alloc] initWithFormat:@"%@ at %@", [DateUtilities formatMediumDate: event_.date ], [DateUtilities formatShortTime: event_.date ]] autorelease];
   self.time.text = [DateUtilities formatShortTime: event_.date ];
}

- (void)dealloc {
   self.name = nil;
   self.organization = nil;
   self.date =  nil;
   self.time = nil;
   self.event = nil;
   [super dealloc];
}


@end
