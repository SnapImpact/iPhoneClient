//
//  EventsSortedByTimeDataSource.h
//  iPhone
//
//  Created by Ryan Schneider on 2/15/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RootViewDataSourceProtocol.h"

@interface EventsSortedByTimeDataSource : NSObject <RootViewDataSourceProtocol, UITableViewDataSource> {
   NSArray* eventsSortedByTime;
   NSArray* dateNamesForEvents;
}

@property (nonatomic, retain) NSArray *dateNamesForEvents;
@property (nonatomic, retain) NSArray *eventsSortedByTime;

+ (id) dataSource;

#pragma mark RootViewDataSourceProtocol

// this property determines the style of table view displayed
@property (readonly) UITableViewStyle tableViewStyle;

// provides a standardized means of asking for the element at the specific
// index path, regardless of the sorting or display technique for the specific
// datasource
- (NSObject *)objectForIndexPath:(NSIndexPath *)indexPath;
- (enum NavigationLevel) navigationLevel;

// this optional protocol allows us to send the datasource this message, since it has the 
// required information
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section;

@end


