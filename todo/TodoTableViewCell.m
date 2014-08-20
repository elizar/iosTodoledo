//
//  TodoTableViewCell.m
//  todo
//
//  Created by Elizar Pepino on 8/19/14.
//  Copyright (c) 2014 Elizar Pepino. All rights reserved.
//

#import "TodoTableViewCell.h"

@interface TodoTableViewCell () {
    BOOL _isEditing;
    IBOutlet UIView *_labelView;
    IBOutlet UIButton *_cancelButton;
    NSString *_titleText;
}

@end

@implementation TodoTableViewCell

- (void)awakeFromNib
{
    [super layoutSubviews];
    // Initialization code
    UISwipeGestureRecognizer *recognizer;
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(willEnterEditMode:)];
    [recognizer setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self addGestureRecognizer:recognizer];
    _isEditing = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willExitFromEditMode:) name:@"cellWillEnterEditMode" object:nil];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)willExitFromEditMode:(id)object
{
    if (_isEditing) {
        [self exitEditMode];
    }
}

- (void)exitEditMode
{
    [self.titleField setEnabled:NO];
    [self.titleField resignFirstResponder];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.25];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(didExitEditMode:)];

    [_labelView setCenter:CGPointMake(_labelView.center.x + 66, 44)];
    [_labelView setBackgroundColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:1]];
    [self.dateField setHidden:NO];
    [self.titleField setFrame:CGRectMake(self.titleField.frame.origin.x - 66, 20, self.titleField.bounds.size.width + 66, self.titleField.bounds.size.height)];
    
    [UIView commitAnimations];
}

- (void)didExitEditMode:(id)sender
{
    _titleField.text = _titleText;
    _isEditing = false;
}

- (void)willEnterEditMode:(id)sender
{
    if (_isEditing) {
        return;
    }
    _titleText = _titleField.text;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"cellWillEnterEditMode" object:nil];
    // Todo animate this shit
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.23];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(didEnterEditMode:)];
    
    [_labelView setCenter:CGPointMake(_labelView.center.x - 66, 44)];
    [_labelView setBackgroundColor:[UIColor colorWithRed:0.88 green:0.99 blue:0.88 alpha:1]];
    [self.dateField setHidden:YES];
    [self.titleField setFrame:CGRectMake(self.titleField.frame.origin.x + 66, self.contentView.center.y - self.titleField.frame.size.height/2, self.titleField.bounds.size.width - 66, self.titleField.bounds.size.height)];
    
    [UIView commitAnimations];
}

- (void)didEnterEditMode:(id)sender
{
    [self.titleField setEnabled:YES];
    [self.titleField becomeFirstResponder];
    _isEditing = true;
}

- (IBAction)saveChanges:(id)sender
{
    // save changes
    [self exitEditMode];
    if ([_titleField.text isEqualToString:@""]) {
        return;
    }
    
    NSLog(@"saving content please wait...");
}

- (IBAction)cancelEditing:(id)sender
{
    [self exitEditMode];
}

- (IBAction)textFieldHasBeganEditing:(id)sender
{
    if ([_titleField.text isEqualToString:_titleText]) {
        [_cancelButton setHidden:NO];
        return;
    }
    
    if (!_cancelButton.isHidden) {
        [_cancelButton setHidden:YES];
    }
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self saveChanges:nil];
    return YES;
}

@end
