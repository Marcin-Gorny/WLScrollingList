//
//  DetailViewController.h
//  WLScrollingList
//
//  Created by Marcin Górny on 16/09/14.
//  Copyright (c) 2014 Whalla Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end

