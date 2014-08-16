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
    UIView *_customSelectedTableCellView;
}

- (void)getTodos;

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
    
    if (!_customSelectedTableCellView) {
        _customSelectedTableCellView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 640, 88)];
        [_customSelectedTableCellView setBackgroundColor:[UIColor colorWithRed:0.111 green:0.77 blue:0.132 alpha:0.1]];
    }
    
    if (!_todoList) {
        _todoList = [[NSMutableArray alloc] init];
    }
    // fetch all todos from sqlite db
    [self getTodos];
}

- (void)getTodos
{
    NSArray *todos = [[TodoDb database] all];
    [_todoList setArray:todos];
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
    
    // pimp cell
    [cell.detailTextLabel setBackgroundColor:[UIColor colorWithWhite:1 alpha:0]];
    [cell.textLabel setBackgroundColor:[UIColor colorWithWhite:1 alpha:0]];
    [cell setSelectedBackgroundView:_customSelectedTableCellView];

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
    if ([[TodoDb database] insertNewTodoWithTitle:title]) {
        NSLog(@"YES!");
        [self getTodos];
    } else {
        NSLog(@"NO!");
    }
    
    TodoFormViewController *todoFVM = (TodoFormViewController *)controller;
    [todoFVM dismissViewControllerAnimated:YES completion:nil];
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
