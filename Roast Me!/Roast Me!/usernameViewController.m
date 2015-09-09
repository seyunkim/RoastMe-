//
//  usernameViewController.m
//  Roast Me!
//
//  Created by Seyun Kim on 8/24/15.
//  Copyright (c) 2015 Zack S Kim. All rights reserved.
//

#import "usernameViewController.h"
#import <Firebase/Firebase.h>

@interface usernameViewController()
@property (weak, nonatomic) IBOutlet UITextField *usernameTF;

@end
@implementation usernameViewController
- (IBAction)doneButton:(id)sender {
    bool isUsernameTaken= false;
    Firebase *ref = [[Firebase alloc] initWithUrl:@"https://roastme.firebaseio.com"];
    if (isUsernameTaken){
        //alert user that username is taken
    }
    else {
    NSString *userImageURL = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large", [ref.authData.uid substringFromIndex:9]];
    NSDictionary *newUser = @{
                              @"provider": ref.authData.provider,
                              @"displayName": self.usernameTF.text,
                              @"profilePicURL": userImageURL
                              };
    // Create a child path with a key set to the uid underneath the "users" node
    // This creates a URL path like the following:
    //  - https://<YOUR-FIREBASE-APP>.firebaseio.com/users/<uid>
    [[[ref childByAppendingPath:@"users"]
      childByAppendingPath:[ref.authData.uid substringFromIndex:9]] setValue:newUser];
    
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
}
-(void) viewDidLoad {
   
}

@end
