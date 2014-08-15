//
//  TableViewController.m
//  todo
//
//  Created by Elizar Pepino on 8/14/14.
//  Copyright (c) 2014 Elizar Pepino. All rights reserved.
//

#import "TableViewController.h"

@interface TableViewController () {
    NSMutableArray *_todoList;
}

@end

@implementation TableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    if (!_todoList) {
        _todoList = [[NSMutableArray alloc] init];
    }
    
    NSArray *todos = [TodoDb database].todoDbInfos;
    for (Todo *todo in todos) {
        [_todoList insertObject:todo atIndex:0];
    }
    [self.tableView reloadData];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return _todoList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"todocell" forIndexPath:indexPath];
    
    // Configure the cell...
    Todo *todo = [_todoList objectAtIndex:[indexPath row]];
    cell.textLabel.text = todo.title;
    // format date
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMMM d, YYYY"];
    cell.detailTextLabel.text = [formatter stringFromDate:[todo dateCreated]];
    
    // set custom bgColor for offset rows
    if ([indexPath row]%2 == 0) {
        [cell.contentView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.05]];
    }
    // pimp cell
    [cell.detailTextLabel setBackgroundColor:[UIColor colorWithWhite:1 alpha:0]];
    [cell.textLabel setBackgroundColor:[UIColor colorWithWhite:1 alpha:0]];
    [cell setSelectedBackgroundView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)]];
    [cell.selectedBackgroundView setBackgroundColor:[UIColor colorWithRed:0.122 green:.120 blue:1 alpha:0.1]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 88.0f;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        
        [_todoList removeObjectAtIndex:[indexPath row]];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)todoFormDidSubmitWithData:(NSString *)title fromController:(id)controller
{
    TodoFormViewController *todoFVM = (TodoFormViewController *)controller;
    [todoFVM dismissViewControllerAnimated:YES completion:nil];
    
    if (!_todoList) {
        _todoList = [[NSMutableArray alloc] init];
    }
    Todo *todo = [[Todo alloc] init];
    todo.title = title;
    todo.done = NO;
    todo.dateCreated = [NSDate date];
    
    [_todoList insertObject:todo atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    TodoFormViewController *todoFVC = (TodoFormViewController *)segue.destinationViewController;
    [todoFVC setDelegate:self];
}


@end
