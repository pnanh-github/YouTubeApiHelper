//
//  ViewController.m
//  Demo05
//
//  Created by Pham Nhat Anh on 1/16/17.
//  Copyright © 2017 Pham Nhat Anh. All rights reserved.
//

#import "ViewController.h"
#import <GTMSessionFetcher/GTMSessionFetcher.h>
#import "GTLRFramework.h"
#import "GTLRYouTube.h"
#import <MobileCoreServices/MobileCoreServices.h> 
#import "YouTubeVideoHelper.h"

#define API_KEY @"Your API KEY"

@interface ViewController (){
    GTLRYouTubeService *youtubeServive;
}
@property (weak, nonatomic) IBOutlet YTPlayerView *playerView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [GIDSignIn sharedInstance].uiDelegate = self;
    NSString *driveScope = @"https://www.googleapis.com/auth/youtube.upload";
    NSArray *currentScopes = [GIDSignIn sharedInstance].scopes;
    [GIDSignIn sharedInstance].scopes = [currentScopes arrayByAddingObject:driveScope];
    // Uncomment to automatically sign in the user.
    [[GIDSignIn sharedInstance] signInSilently];
    GIDSignInButton* button = [[GIDSignInButton alloc] init];
    [self.view addSubview:button];
    button.center = self.view.center;    
    
    YouTubeVideoHelper *helper = [YouTubeVideoHelper sharedInstance];
    //Change API_KEY to your YouTube API KEY   
    //helper.apiKey = API_KEY;
    
    [helper search:@"iOS" withType:@"video" pageToken:nil andCompletion:^(id data, BOOL status) {
        if(status){
            NSLog(@"%@",data);
        }
    }];
    [self.playerView loadWithVideoId:@"oLj9q_PoOas"];
}

- (IBAction)getList:(id)sender {
    
}


- (IBAction)uploadAction:(id)sender {
    YouTubeVideoHelper *helper = [YouTubeVideoHelper sharedInstance];
    helper.apiKey = API_KEY;
    helper.authorizer = [GIDSignIn sharedInstance].currentUser.authentication.fetcherAuthorizer;
    NSURL *fileToUploadURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"demo2" ofType:@"mov"]];
    
    //Simple upload method
    
//    [helper uploadVideoSimple:fileToUploadURL withName:@"My Video" description:@"My First Video" andCompletion:^(BOOL staus) {
//        if(staus){
//            NSLog(@"OK");
//        }else{
//            NSLog(@"FAIL");
//        }
//    }];
    
    //Advanced upload method
    [helper uploadVideo:fileToUploadURL withName:@"My video Adv 2" description:@"Advanced Video 2" progress:^(GTLRServiceTicket *ticket, unsigned long long numberOfBytesRead, unsigned long long dataLength) {
        NSLog(@"\r\nProgress: %llul / %llul",numberOfBytesRead,dataLength);
    } andCompletion:^(GTLRServiceTicket *callbackTicket, GTLRYouTube_Video *uploadedVideo, NSError *callbackError) {
        if(callbackError == nil){
            NSLog(@"File %@ uploaded.",uploadedVideo.identifier);
        }else{
            NSLog(@"FAIL: %@",[callbackError localizedDescription]);
        }
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)signInWillDispatch:(GIDSignIn *)signIn error:(NSError *)error {
   // indicator
}

// Present a view that prompts the user to sign in with Google
- (void)signIn:(GIDSignIn *)signIn
presentViewController:(UIViewController *)viewController {
    [self presentViewController:viewController animated:YES completion:nil];
}

// Dismiss the "Sign in with Google" view
- (void)signIn:(GIDSignIn *)signIn
dismissViewController:(UIViewController *)viewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
