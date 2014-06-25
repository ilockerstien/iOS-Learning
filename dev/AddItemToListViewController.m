//
//  AddItemToListViewController.m
//  dev
//
//  Created by Ian Lockerbie on 2014-06-17.
//  Copyright (c) 2014 LockLabs. All rights reserved.
//

#import "AddItemToListViewController.h"

@interface AddItemToListViewController ()
@property (nonatomic, weak) NSTimer *cameraTimer;
@property (nonatomic) UIImagePickerController *imagePickerController;
@property (weak, nonatomic) IBOutlet UIImageView *overlayView;
@property (nonatomic) NSMutableArray *capturedImages;
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
    self.descriptField.delegate = self;
}

-(void)viewWillAppear:(BOOL)animated{

    self.costLabel.text = self.cost;
    NSLog(@"%@", self.costLabel.text);
    self.descriptField.text = self.descript;
//    self.imageView.image = self.image;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)prepareNewItem{
    NSLog(@"Preparing NewItem");
    
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.descriptField resignFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (self.descriptField){
        [self.descriptField resignFirstResponder];
    }
    return NO;
}

- (IBAction)increaseCost:(id)sender{
    self.costLabel.text = [NSString stringWithFormat:@"%ld", [self.costLabel.text integerValue]+1];
}

- (IBAction)decreaseCost:(id)sender {
    self.costLabel.text = [NSString stringWithFormat:@"%ld", [self.costLabel.text integerValue]-1];
}

- (IBAction)orderPayPressed:(id)sender {
    NSLog(@"orderPayButton Text:%@", self.orderPayButton.titleLabel.text);
    if ([self.orderPayButton.titleLabel.text isEqual:@"Ordered $"]){
        [self.orderPayButton setTitle:@"Paid $" forState:UIControlStateNormal];
    } else {
        [self.orderPayButton setTitle:@"Ordered $" forState:UIControlStateNormal];
    }
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
    
/*
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:NULL];
 */
    [self showImagePickerForSourceType:UIImagePickerControllerSourceTypeCamera];
    [self.imagePickerController takePicture];
    

}
/*
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.imageView.image = chosenImage;
//    self.addItem.image = chosenImage;
    picking = YES;
    self.imageView = nil;
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}*/

- (IBAction)showImagePickerForCamera:(id)sender
{
    [self showImagePickerForSourceType:UIImagePickerControllerSourceTypeCamera];
}


- (IBAction)showImagePickerForPhotoPicker:(id)sender
{
    [self showImagePickerForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}


- (void)showImagePickerForSourceType:(UIImagePickerControllerSourceType)sourceType
{
    if (self.imageView.isAnimating)
    {
        [self.imageView stopAnimating];
    }
    
    if (self.capturedImages.count > 0)
    {
        [self.capturedImages removeAllObjects];
    }
    
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.modalPresentationStyle = UIModalPresentationCurrentContext;
    imagePickerController.sourceType = sourceType;
    imagePickerController.delegate = self;
    
    if (sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        /*
         The user wants to use the camera interface. Set up our custom overlay view for the camera.
         */
        imagePickerController.showsCameraControls = YES;
        
        /*
         Load the overlay view from the OverlayView nib file. Self is the File's Owner for the nib file, so the overlayView outlet is set to the main view in the nib. Pass that view to the image picker controller to use as its overlay view, and set self's reference to the view to nil.
         */

    }
    
    self.imagePickerController = imagePickerController;
    [self presentViewController:self.imagePickerController animated:YES completion:nil];
}


#pragma mark - Toolbar actions

- (IBAction)done:(id)sender
{
    // Dismiss the camera.
    if ([self.cameraTimer isValid])
    {
        [self.cameraTimer invalidate];
    }
    [self finishAndUpdate];
}










- (void)finishAndUpdate
{
    [self dismissViewControllerAnimated:YES completion:NULL];
    
    if ([self.capturedImages count] > 0)
    {
        if ([self.capturedImages count] == 1)
        {
            // Camera took a single picture.
            [self.imageView setImage:[self.capturedImages objectAtIndex:0]];
        }
        else
        {
            // Camera took multiple pictures; use the list of images for animation.
            self.imageView.animationImages = self.capturedImages;
            self.imageView.animationDuration = 5.0;    // Show each captured photo for 5 seconds.
            self.imageView.animationRepeatCount = 0;   // Animate forever (show all photos).
            [self.imageView startAnimating];
        }
        
        // To be ready to start again, clear the captured images array.
        [self.capturedImages removeAllObjects];
    }
    
    self.imagePickerController = nil;
}


#pragma mark - Timer

// Called by the timer to take a picture.
- (void)timedPhotoFire:(NSTimer *)timer
{

    [self.imagePickerController takePicture];
}


#pragma mark - UIImagePickerControllerDelegate

// This method is called when an image has been chosen from the library or taken from the camera.
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    self.imageView.image = image;
    [self.capturedImages addObject:image];
    
    if ([self.cameraTimer isValid])
    {
        return;
    }
    
    [self finishAndUpdate];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:NULL];
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
