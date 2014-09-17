//
//  MasterViewController.h
//  WLScrollingList
//
//  Created by Marcin Górny on 16/09/14.
//  Copyright (c) 2014 Whalla Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "WLScrollingTableView.h"
@class DetailViewController;

@interface MasterViewController : UIViewController <NSFetchedResultsControllerDelegate, WLScrollingTableViewDelegate, WLScrollingTableViewDataSource>

@property (strong, nonatomic) DetailViewController *detailViewController;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) WLScrollingTableView *scrollTableView;

@end

