//
//  AMLoginViewController.m
//  LoginVideo
//
//  Created by AMarliac on 2014-04-02.
//  Copyright (c) 2014 AMarliac. All rights reserved.
//

#import "AMLoginViewController.h"
#import <Firebase/Firebase.h>


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
@property (weak, nonatomic) IBOutlet UIButton *facebookButton;
@property (weak, nonatomic) IBOutlet UILabel *loginLabel;

@end

@implementation AMLoginViewController



- (void) viewDidAppear:(BOOL)animated{
	[super viewDidAppear:animated];

}


- (void)viewDidLoad
{
    [super viewDidLoad];
	

	
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
    UIImageView * loginImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 270, 80)];
    [loginImage setImage:[UIImage imageNamed:@"RoastME_TitleLogo.png"]];
    loginImage.center = CGPointMake(self.view.frame.size.width/2, 135);
    [self.view addSubview:loginImage];
	//Logo End
	
	
	// add Login Label
	[self.view addSubview:self.loginLabel];
	//ACTUAL LOGIN BUTTON START
	UIImage *btnImage = [UIImage imageNamed:@"Facebook Button.png"];
	[self.facebookButton setImage:btnImage forState:UIControlStateNormal];
	self.facebookButton.center =CGPointMake(self.view.frame.size.width/2, 200);
//	self.facebookButton.frame = CGRectOffset(self.facebookButton.frame, (self.view.center.x - (self.facebookButton.frame.size.width / 2)), self.view.bounds.size.height-180);
	[self.view addSubview:self.facebookButton];
	//Login Button End
}
- (void)_loginWithFacebook {

	
	Firebase *ref = [[Firebase alloc] initWithUrl:@"https://roastme.firebaseio.com"];
	FBSDKLoginManager *facebookLogin = [[FBSDKLoginManager alloc] init];
	
	[facebookLogin logInWithReadPermissions:@[@"public_profile", @"email", @"user_friends"]
																	handler:^(FBSDKLoginManagerLoginResult *facebookResult, NSError *facebookError)
		{
																		
					if (facebookError) {
						NSLog(@"Facebook login failed. Error: %@", facebookError);
					}
					else if (facebookResult.isCancelled) {
						NSLog(@"Facebook login got cancelled.");
					}
					else {
							NSString *accessToken = [[FBSDKAccessToken currentAccessToken] tokenString];
							
							[ref authWithOAuthProvider:@"facebook" token:accessToken
										 withCompletionBlock:^(NSError *error, FAuthData *authData)
							{
											 
										 if (error) {
											 NSLog(@"Login failed. %@", error);
										 } else {
											 //Log in is Successful
											 NSLog(@"Logged in! %@", authData);
											 
											 NSLog(@"%@", authData.uid);
											 // Create a new user dictionary accessing the user's info
											 // provided by the authData parameter
                                              NSString *userImageURL = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large", [authData.uid substringFromIndex:9]];
											 NSDictionary *newUser = @{
                                                    @"provider": authData.provider,
                                                     @"displayName": authData.providerData[@"displayName"],
                                                    @"profilePicURL": userImageURL
                                                             };
											 // Create a child path with a key set to the uid underneath the "users" node
											 // This creates a URL path like the following:
											 //  - https://<YOUR-FIREBASE-APP>.firebaseio.com/users/<uid>
											 [[[ref childByAppendingPath:@"users"]
												 childByAppendingPath:[authData.uid substringFromIndex:9]] setValue:newUser];
											 
												[self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
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
