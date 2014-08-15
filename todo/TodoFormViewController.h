//
//  TodoFormViewController.h
//  todo
//
//  Created by Elizar Pepino on 8/14/14.
//  Copyright (c) 2014 Elizar Pepino. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TodoFormDelegate <NSObject>

@required
- (void)todoFormDidSubmitWithData:(NSString *)title fromController:(id)controller;

@end

@interface TodoFormViewController : UIViewController

@property (assign, nonatomic) IBOutlet UITextField *titleField;
@property (retain, nonatomic) id <TodoFormDelegate> delegate;
@end
