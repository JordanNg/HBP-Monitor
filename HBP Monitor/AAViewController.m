//
//  AAViewController.m
//  HBP Monitor
//
//  Created by Jordan Ng on 4/3/14.
//  Copyright (c) 2014 Agency Agency. All rights reserved.
//

#import "AAViewController.h"
#import "BloodSugar+Create.h"
#import "AAAppDelegate.h"

@interface AAViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *readings;

@end

@implementation AAViewController

- (void)setContext:(NSManagedObjectContext *)context
{
    _context = context;
    NSLog(@"context set!");
    self.readings = [BloodSugar allReadingsInManagedObjectContext:self.context];
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    AAAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    self.context = delegate.managedObjectContext;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Reading Cell" forIndexPath:indexPath];
    BloodSugar *reading = (BloodSugar *)self.readings[indexPath.row];
    NSLog(@"%@", reading);
    cell.textLabel.text = [[reading bloodReading] description];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ - %@", [[reading bloodReading] description], reading.notes];
    cell.detailTextLabel.text = [reading.readingTime description];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.readings count];
}

@end
