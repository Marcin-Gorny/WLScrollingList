//
//  WLScrollingTableViewController.h
//  WLScrollingList
//
//  Created by Marcin Górny on 16/09/14.
//  Copyright (c) 2014 Whalla Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WLScrollingTableView;

@interface WLIndexPath : NSObject
@property (nonatomic, assign) NSInteger column;
@property (nonatomic, assign) NSInteger section;
@property (nonatomic, assign) NSInteger row;
-(id)initWithColumn:(NSInteger)column section:(NSInteger)section row:(NSInteger)row;
@end

@protocol WLScrollingTableViewDelegate <NSObject>



@optional
- (void) willSelectRowAtIndexPath:(WLIndexPath *)indexPath;
- (CGFloat) heightForCellAtIndexPath:(WLIndexPath *) indexPath;
- (CGFloat) scrollingSpeedForColumn:(int) column;
- (CGFloat) columnWidthAtIndex: (NSInteger) index;
@end

@protocol WLScrollingTableViewDataSource <NSObject>
- (NSInteger) scrollingTableView:(WLScrollingTableView *) scrollingTableView numberOfSectionsInColumnAtIndex:(NSInteger)index;
- (NSInteger) scrollingTableView:(WLScrollingTableView *) scrollingTableView numberOfRowsInColumnAtIndex:(NSInteger)index;
- (UITableViewCell*) scrollSelect:(WLScrollingTableView*) scrollSelect cellForRowAtIndexPath:(WLIndexPath *)indexPath;
@optional
- (NSInteger) numberOfColumnsForScrollingTableView:(WLScrollingTableView *) scrollingTableView ;

@end

@interface WLScrollingTableView : UIView <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) NSArray *columns;
@property (nonatomic, strong) id<WLScrollingTableViewDelegate> delegate;
@property (nonatomic, strong) id<WLScrollingTableViewDataSource> dataSource;
-(UITableViewCell *)cellForIndexPath:(WLIndexPath *)indexPath;
-(UITableView *)columnAtIndex:(NSInteger)index;
-(void)reloadData;
-(void)initialize;
@end

