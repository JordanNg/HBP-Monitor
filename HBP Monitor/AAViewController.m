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
@property (weak, nonatomic) IBOutlet UITextField *readingTextField;
@property (weak, nonatomic) IBOutlet UITextView *notesTextView;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIButton *addMeasurementButton;

@end

@implementation AAViewController
- (IBAction)addMeasurementPressed:(UIButton *)sender {
    self.addMeasurementButton.alpha = 0;
    self.readingTextField.text = nil;
    [self.datePicker setDate:[NSDate date] animated:YES];
    self.notesTextView.text = nil;
    
}

- (void)setContext:(NSManagedObjectContext *)context
{
    _context = context;
    NSLog(@"context set!");
    self.readings = [BloodSugar allReadingsInManagedObjectContext:self.context];
    [self.tableView reloadData];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
    
    BloodSugar *reading = self.readings[indexPath.row];
    [self displayReading:reading];
}

-(NSString *)formattedReadingDate:(NSDate *)date
{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateStyle:NSDateFormatterMediumStyle];
    NSString *dateString = [format stringFromDate:date];

    return dateString;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    //    AAAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    //    self.context = delegate.managedObjectContext;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Reading Cell" forIndexPath:indexPath];
    BloodSugar *reading = (BloodSugar *)self.readings[indexPath.row];
    NSLog(@"%@", reading);
    
    
    cell.textLabel.text = [[reading bloodReading] description];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ - %@", [[reading bloodReading] description],
                           [self formattedReadingDate:reading.readingTime]];
    cell.detailTextLabel.text = [reading.notes description];
//    cell.textLabel.text = [NSString stringWithFormat:@"%@ - %@", reading.notes, [[reading bloodReading] description]];
//    cell.detailTextLabel.text = [reading.readingTime description];
    return cell;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.readings count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BloodSugar *reading = self.readings[indexPath.row];
    [self displayReading:reading];
}

- (void) displayReading:(BloodSugar *)reading
{
    self.readingTextField.text = [reading.bloodReading description];
    
    self.notesTextView.text = [reading.notes description];
    
    [self.datePicker setDate:reading.readingTime animated:YES];
}
@end
