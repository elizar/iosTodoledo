//
//  TodoTableViewCell.h
//  todo
//
//  Created by Elizar Pepino on 8/19/14.
//  Copyright (c) 2014 Elizar Pepino. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TodoTableViewCell : UITableViewCell <UITextFieldDelegate>

@property (assign, nonatomic) IBOutlet UITextField *titleField;
@property (assign, nonatomic) IBOutlet UILabel *dateField;
@end
