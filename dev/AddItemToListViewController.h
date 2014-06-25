//
//  AddItemToListViewController.h
//  dev
//
//  Created by Ian Lockerbie on 2014-06-17.
//  Copyright (c) 2014 LockLabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddItemToListViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UILabel *costLabel;
@property (weak, nonatomic) IBOutlet UITextField *descriptField;
@property (weak, nonatomic) IBOutlet UIButton *orderPayButton;
@property (strong, nonatomic) NSString *cost;
@property (strong, nonatomic) NSString *descript;
@property (strong, nonatomic) UIImage *image;
@end
