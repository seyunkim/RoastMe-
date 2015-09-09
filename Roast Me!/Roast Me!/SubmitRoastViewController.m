//
//  SubmitRoastViewController.m
//  Roast Me!
//
//  Created by Seyun Kim on 8/17/15.
//  Copyright (c) 2015 Zack S Kim. All rights reserved.
//

#import "SubmitRoastViewController.h"
#import "Firebase/Firebase.h"

@implementation SubmitRoastViewController

- (IBAction)submitiButton:(id)sender {
    Firebase* ref = [[Firebase alloc] initWithUrl: @"https://roastme.firebaseio.com/questions"];
    Firebase* userRef =[[Firebase alloc] initWithUrl: [NSString stringWithFormat:@"https://roastme.firebaseio.com/users/%@", [ref.authData.uid substringFromIndex:9]] ];
    Firebase* uQuestionRef= [ref childByAutoId];
    [userRef observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
      
   
        NSString* creditName = [NSString stringWithFormat:@"%@", self.giveMeCreditSwitch? snapshot.value[@"displayname"]:@"Anonymous"];
    NSDictionary* question = @{
        @"credit": [NSString stringWithFormat:@"%@", creditName],
        @"question" : [NSString stringWithFormat:@"Which of your friends is most likely to %@?" ,self.questionTF.text],
        @"roast_likes" : @"0", @"roast_dislikes": @"0"
        
    };
   // question
    [uQuestionRef setValue:question];
         }];
    [[self presentingViewController] dismissViewControllerAnimated:NO completion:nil];
}

@end
