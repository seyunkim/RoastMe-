//
//  RoastGameViewController.m
//  Roast Me!
//
//  Created by Seyun Kim on 8/16/15.
//  Copyright (c) 2015 Zack S Kim. All rights reserved.
//

#import "RoastGameViewController.h"
#import <Firebase/Firebase.h>
#import "XHAmazingLoadingView.h"

@interface RoastGameViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *player1_picture;
@property (weak, nonatomic) IBOutlet UILabel *questionLabel;

@end
@implementation RoastGameViewController

- (void)viewDidLoad
{
   
Firebase *ref = [[Firebase alloc] initWithUrl: @"https://roastme.firebaseio.com/users/883117308373977"];
    
    //pull imageURL from firebase and load it into view Controller
    [ref observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        NSLog(@"hello the loaded data is: %@", snapshot.value[@"profilePicURL"]);
        NSURL* url = [NSURL URLWithString: snapshot.value[@"profilePicURL"] ];
        NSData *imageData = [NSData dataWithContentsOfURL: url];
        [self.player1_picture setImage:[[UIImage alloc] initWithData:imageData] ];
        
    }];
    
    
    //Set question label
    self.questionLabel.font = [UIFont fontWithName:@"Titillium-Regular" size:20];
    [self.questionLabel sizeToFit];
    self.questionLabel.textAlignment = NSTextAlignmentCenter;
    self.questionLabel.text = @"Which of your friends is most likely indecisive?";
    self.questionLabel.lineBreakMode = UILineBreakModeClip;
    
    
}
- (void) viewDidLayoutSubviews
{
    [self picturesetup];
 
}

- (void) picturesetup //change the picture's properties
{
    
    self.player1_picture.layer.cornerRadius = self.player1_picture.frame.size.width/2;
    self.player1_picture.layer.masksToBounds = YES;
    self.player1_picture.layer.borderColor = [[UIColor redColor]CGColor];
    self.player1_picture.layer.borderWidth = 3;
}
@end
