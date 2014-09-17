//
//  WLScrollingTableViewController.m
//  WLScrollingList
//
//  Created by Marcin Górny on 16/09/14.
//  Copyright (c) 2014 Whalla Labs. All rights reserved.
//

#import "WLScrollingTableView.h"
@implementation WLIndexPath
-(id)initWithColumn:(NSInteger)column section:(NSInteger)section row:(NSInteger)row
{
    self = [super init];
    self.column = column;
    self.section = section;
    self.row = row;
    return self;
}
@end
@interface WLScrollingTableView ()
{
    BOOL isDecelerating;
    BOOL isScrollingDown;
    BOOL didReachBounds;
}
@property (nonatomic, strong) UITableView * currentScrollingTable;
@property (nonatomic, assign) CGPoint previousPosition;
@end

@implementation WLScrollingTableView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    return self;
}
-(void)initialize
{
    NSInteger columnsCount = 2;
    if ([self.dataSource respondsToSelector:@selector(numberOfColumnsForScrollingTableView:)]) {
        columnsCount = [self.dataSource numberOfColumnsForScrollingTableView:nil];
    }
    NSMutableArray *mutableColumns = [[NSMutableArray alloc] init];
    for (int i=0; i< columnsCount; i++) {
        UITableView *tableview = [[UITableView alloc] initWithFrame:CGRectMake(i*self.frame.size.width / columnsCount, 0, self.frame.size.width / columnsCount, self.frame.size.height)];
        tableview.showsHorizontalScrollIndicator = NO;
        tableview.showsVerticalScrollIndicator = NO;
        tableview.dataSource = self;
        tableview.delegate = self;
        [mutableColumns addObject:tableview];
        [self addSubview:tableview];
    }
    self.columns = [NSArray arrayWithArray:mutableColumns];

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(heightForCellAtIndexPath:)]) {
        return [self.delegate heightForCellAtIndexPath:[[WLIndexPath alloc] initWithColumn:[self.columns indexOfObject:tableView] section:indexPath.section row:indexPath.row]];
    }
    else
        return 100;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    NSInteger itemsCount = [self.dataSource scrollingTableView:self numberOfRowsInColumnAtIndex:[self.columns indexOfObject:tableView]];
    NSLog(@"Items count is: %i for column: %i",itemsCount, [self.columns indexOfObject:tableView]);
    return itemsCount;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  [self.dataSource scrollSelect:self cellForRowAtIndexPath:[[WLIndexPath alloc] initWithColumn:[self.columns indexOfObject:tableView] section:indexPath.section row:indexPath.row]];
}

#pragma mark - UIScrollViewDelegate
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    isDecelerating = NO;
    isScrollingDown = self.previousPosition.y > scrollView.contentOffset.y;
    if ([scrollView isKindOfClass:[UITableView class]]) {
        self.currentScrollingTable = (UITableView *)scrollView;
        self.previousPosition = self.currentScrollingTable.contentOffset;
    }
    for (UITableView *tableview in self.columns) {
        if (tableview != self.currentScrollingTable) {
            //            tableview.delegate = nil;
        }
    }
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.currentScrollingTable && scrollView == self.currentScrollingTable) {
        [self adjustPositionOfColumns];
        if (! isDecelerating) {
            isScrollingDown = self.previousPosition.y < self.currentScrollingTable.contentOffset.y;
        }
        self.previousPosition = self.currentScrollingTable.contentOffset;
    }
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    isDecelerating = decelerate;
    didReachBounds = ! ((scrollView.contentOffset.y > 0) && scrollView.contentSize.height - scrollView.contentOffset.y > self.frame.size.height + self.frame.origin.y);
    
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    isDecelerating = NO;
}

-(void)adjustPositionOfColumns
{
    CGPoint delta = CGPointMake(self.previousPosition.x - self.currentScrollingTable.contentOffset.x , self.previousPosition.y - self.currentScrollingTable.contentOffset.y);
    for (UITableView *tableview in self.columns) {
        if (tableview != self.currentScrollingTable && ! didReachBounds) {
            if ((tableview.contentOffset.y - delta.y > 0) &&
                tableview.contentSize.height - tableview.contentOffset.y > self.frame.size.height + self.frame.origin.y - delta.y
                )
            {
                if (isDecelerating) {
                    if ((isScrollingDown && delta.y < 0) || (! isScrollingDown && delta.y > 0)) {
                        [tableview setContentOffset:CGPointMake(tableview.contentOffset.x - delta.x, tableview.contentOffset.y - delta.y)];
                    }
                }
                else
                    [tableview setContentOffset:CGPointMake(tableview.contentOffset.x - delta.x, tableview.contentOffset.y - delta.y)];
            }
        }
    }
}
-(void)reloadData
{
    for (UITableView *tableview in self.columns) {
        [tableview reloadData];
    }
}
-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(willSelectRowAtIndexPath:)]) {
        [self.delegate willSelectRowAtIndexPath:[[WLIndexPath alloc]initWithColumn:[self.columns indexOfObject:tableView] section:indexPath.section row:indexPath.row]];
    }
    return nil;
}
-(UITableViewCell *)cellForIndexPath:(WLIndexPath *)indexPath
{
    return [[self.columns objectAtIndex:indexPath.column] cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]];
}
-(UITableView *)columnAtIndex:(NSInteger)index
{
    return [self.columns objectAtIndex:index];
}
@end
