//
//  AMLoginViewController.m
//  LoginVideo
//
//  Created by AMarliac on 2014-04-02.
//  Copyright (c) 2014 AMarliac. All rights reserved.
//

#import "AMLoginViewController.h"
#import <ParseFacebookUtilsV4/PFFacebookUtils.h>
#import <Parse/Parse.h>


@interface AMLoginViewController () 

{
    AVPlayer * avPlayer;
    AVPlayerLayer *avPlayerLayer;
    CMTime time;
    
    //blur
    GPUImageiOSBlurFilter *_blurFilter;
    GPUImageBuffer *_videoBuffer;
    GPUImageMovie *_liveVideo;
	
 
}

@end

@implementation AMLoginViewController


- (void) viewDidAppear:(BOOL)animated{
	[super viewDidAppear:animated];

}


- (void)viewDidLoad
{
    [super viewDidLoad];
	

	
		self.facebookButton = [[UIButton alloc] initWithFrame:CGRectMake(35, 245, 250, 50)];
	
	
	[self.facebookButton addTarget:self action:@selector(_loginWithFacebook) forControlEvents:UIControlEventTouchUpInside];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];



    // ---------------------------AVPLAYER STUFF -------------------------------
	
	NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
	[[UIDevice currentDevice] setValue:value forKey:@"orientation"];

	
    
    NSString * ressource = [[NSBundle mainBundle] pathForResource:@"demoVideo" ofType:@".mp4"];
	

    NSURL * urlPathOfVideo = [NSURL fileURLWithPath:ressource];
    avPlayer = [AVPlayer playerWithURL:urlPathOfVideo];
    avPlayer.actionAtItemEnd = AVPlayerActionAtItemEndNone;

    avPlayerLayer = [AVPlayerLayer playerLayerWithPlayer:avPlayer];
    avPlayerLayer.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    [self.view.layer addSublayer: avPlayerLayer];
    
    [avPlayer play];
    time = kCMTimeZero;
    
    //prevent music coming from other app to be stopped
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient error:nil];

    
    // -------------------------------------------------------------------------

    
    //AVPlayer Notifications

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerItemDidReachEnd:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:[avPlayer currentItem]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(pauseVideo)
                                                 name:@"PauseBgVideo"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(resumeVideo)
                                                 name:@"ResumeBgVideo"
                                               object:nil];
    
    
    
    
    // ---------------------------BLUR STUFF -------------------------------
    
    
    _blurFilter = [[GPUImageiOSBlurFilter alloc] init];
    //change the float value in order to change the blur effect
    _blurFilter.blurRadiusInPixels = 12.0f;
    _blurFilter.downsampling = 1.0f;
    _videoBuffer = [[GPUImageBuffer alloc] init];
    [_videoBuffer setBufferSize:1];
    
    // ---------------------------------------------------------------------

    
    [self setViewItems];



}



- (BOOL)shouldAutorotate {
	return NO;
}

-(NSUInteger)supportedInterfaceOrientations {
	return UIInterfaceOrientationMaskPortrait;
}
#pragma mark - AVPlayer methods


- (void)pauseVideo
{
    [avPlayer pause];
    time = avPlayer.currentTime;
}


- (void)resumeVideo
{
    [avPlayer seekToTime:time toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
    [avPlayer play];
}


- (void)playerItemDidReachEnd:(NSNotification *)notification
{
    AVPlayerItem *p = [notification object];
    [p seekToTime:kCMTimeZero];
}


- (void) procesBlurWithBackgroundVideoOnView:(BlurView*)view
{

        _liveVideo = [[GPUImageMovie alloc] initWithPlayerItem:avPlayer.currentItem];
        
        [_liveVideo addTarget:_videoBuffer];
        [_videoBuffer addTarget:_blurFilter];
        [_blurFilter addTarget:view];
        [_liveVideo startProcessing];
}




- (void) setViewItems
{
	// Blur Effect!
	if (!UIAccessibilityIsReduceTransparencyEnabled()) {
		self.view.backgroundColor = [UIColor clearColor];
		UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
		UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
		blurEffectView.frame = self.view.frame;
		[self.view addSubview:blurEffectView];
		
		[blurEffectView setTranslatesAutoresizingMaskIntoConstraints:NO];
		[self.view addConstraint:[NSLayoutConstraint constraintWithItem:blurEffectView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
		[self.view addConstraint:[NSLayoutConstraint constraintWithItem:blurEffectView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
		[self.view addConstraint:[NSLayoutConstraint constraintWithItem:blurEffectView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:0]];
		[self.view addConstraint:[NSLayoutConstraint constraintWithItem:blurEffectView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]];
	}  else {
		self.view.backgroundColor = [UIColor blackColor];
	}
	// Blur Effect End
	
	//Logo
    UIImageView * loginImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 110, 110)];
    [loginImage setImage:[UIImage imageNamed:@"logoclubby.png"]];
    loginImage.center = CGPointMake(self.view.frame.size.width/2, 120);
    [self.view addSubview:loginImage];
	//Logo End
	
	//FB SDK LOGIN **USED FOR PICTURE ONLY**
	FBSDKLoginButton* sdkButton = [[FBSDKLoginButton alloc] initWithFrame:CGRectMake(35, 245, 250, 50)];
	sdkButton.userInteractionEnabled = NO;
	sdkButton.center = self.view.center;
	[self.view addSubview:sdkButton];
	//End for Picture
	
	//ACTUAL LOGIN BUTTON START
	self.facebookButton.center = self.view.center;
	[self.view addSubview:self.facebookButton];
	//Login Button End
//
//    _usernameView = [[BlurView alloc] initWithFrame:CGRectMake(35, 245, 250, 50)];
//    _passwordView = [[BlurView alloc] initWithFrame:CGRectMake(35, 300, 250, 50)];
//    
	
//    _sendButtonView = [[UIView alloc] initWithFrame:CGRectMake(35, 370, 250, 50)];
//    _sendButtonView.backgroundColor = [UIColor colorWithRed:0.925 green:0.941 blue:0.945 alpha:0.7];
//    
//    //BUTTON
//    UIButton * sendButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, _sendButtonView.frame.size.width, _sendButtonView.frame.size.height)];
//    [sendButton setTitle:@"LOGIN" forState:UIControlStateNormal];
//    [sendButton setTitleColor:[UIColor colorWithRed:0.173 green:0.243 blue:0.314 alpha:1] forState:UIControlStateNormal];
//    
//    [_sendButtonView addSubview:sendButton];


	
//    
//    [self.view addSubview:_usernameView];
//    [self.view addSubview:_passwordView];
//    [self.view addSubview:_sendButtonView];

}
- (void)_loginWithFacebook {
	// Set permissions required from the facebook user account
	NSArray *permissionsArray = @[@"public_profile", @"email", @"user_friends"];
	// Login PFUser using Facebook
	[PFFacebookUtils logInInBackgroundWithReadPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
		if (!user) {
			NSLog(@"Uh oh. The user cancelled the Facebook login.");
		} else if (user.isNew) {
			NSLog(@"User signed up and logged in through Facebook!");
			
			[[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil]
			 startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
				 if (!error) {
					 NSLog(result);
//					 user.username= result[@"name"];
//					 user[@"id"]= result[@"id"];
//					 user[@"email"]= result[@"email"];
				 }
			 }];
		


		
		} else {
			NSLog(@"User logged in through Facebook!");
		//	[self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
			
			[[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil]
			 startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
				 
				 if (!error) {
					 NSLog(@"hi");
					 NSLog(@"fetched user: %@", result);
					
				 }
			 }];
			
			

		}
	}];
}


#pragma mark - Miscellaneous




#pragma mark - Life cycle methods


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
