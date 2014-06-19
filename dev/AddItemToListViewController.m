//
//  AddItemToListViewController.m
//  dev
//
//  Created by Ian Lockerbie on 2014-06-17.
//  Copyright (c) 2014 LockLabs. All rights reserved.
//

#import "AddItemToListViewController.h"

@interface AddItemToListViewController ()

@end

@implementation AddItemToListViewController {
    BOOL picking;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    picking = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    if (!picking){
        self.addItem = [[DataModelElement alloc] init];
        self.addItem.image = nil;
    }
    picking = NO;
}

-(void)prepareNewItem{
    NSLog(@"Preparing NewItem");
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"AddToListCancelToListView"]){
        NSLog(@"Cancelled");
    } else if ([segue.identifier isEqualToString:@"AddToListDoneToListView"]) {
        NSLog(@"Done");
        [self prepareNewItem];
    }
}


- (IBAction)takePhoto:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.imageView.image = chosenImage;
    self.addItem.image = chosenImage;
    picking = YES;
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
