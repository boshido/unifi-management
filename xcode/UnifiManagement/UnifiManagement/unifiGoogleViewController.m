//
//  unifiGoogleViewController.m
//  UnifiManagement
//
//  Created by Watchrapong Agsonchu on 11/28/2556 BE.
//  Copyright (c) 2556 KMUTNB. All rights reserved.
//

#import "unifiGoogleViewController.h"
#import "unifiGoogleNavigationController.h"
#import "DejalActivityView.h"

NSString *clientId = @"422391959017-g7pjv4dcgfqrahuad57nftm3s7jkct40.apps.googleusercontent.com";
NSString *secret = @"NfkcgQKYWoczllzdZXr7VSSj";
NSString *callbakc =  @"http://localhost";
NSString *scope = @"https://www.googleapis.com/auth/userinfo.email+https://www.googleapis.com/auth/userinfo.profile+https://www.google.com/reader/api/0/subscription";
NSString *visibleactions = @"http://schemas.google.com/AddActivity";
NSString *accessType = @"offline";
NSString *approval = @"force";
NSString *hd = @"";

@interface unifiGoogleViewController ()

@end

@implementation unifiGoogleViewController

@synthesize webview;

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
    
    
    NSString *url = [NSString stringWithFormat:@"https://accounts.google.com/o/oauth2/auth?response_type=code&client_id=%@&redirect_uri=%@&scope=%@&data-requestvisibleactions=%@&access_type=%@&approval_prompt=%@&hd=%@",clientId,callbakc,scope,visibleactions,accessType,approval,hd];
    webview.delegate =self;
    [webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType {
    if ([[[request URL] host] isEqualToString:@"localhost"]) {
        
        // Extract oauth_verifier from URL query
        NSString* verifier = nil;
        NSArray* urlParams = [[[request URL] query] componentsSeparatedByString:@"&"];
        for (NSString* param in urlParams) {
            NSArray* keyValue = [param componentsSeparatedByString:@"="];
            NSString* key = [keyValue objectAtIndex:0];
            if ([key isEqualToString:@"code"]) {
                verifier = [keyValue objectAtIndex:1];
                break;
            }
        }
        
        if (verifier) {
            NSString *data = [NSString stringWithFormat:@"code=%@&client_id=%@&client_secret=%@&redirect_uri=%@&grant_type=authorization_code", verifier,clientId,secret,callbakc];
            NSString *url = [NSString stringWithFormat:@"https://accounts.google.com/o/oauth2/token"];
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
            [request setHTTPMethod:@"POST"];
            [request setHTTPBody:[data dataUsingEncoding:NSUTF8StringEncoding]];
            theConnection=[[NSURLConnection alloc] initWithRequest:request delegate:self];
            receivedData = [[NSMutableData alloc] init];
            
        } else {
            // ERROR!
        }
        
        [webView removeFromSuperview];
        
        return NO;
    }
    else{
        [DejalBezelActivityView currentActivityView].showNetworkActivityIndicator = YES;
        [DejalBezelActivityView activityViewForView:self.view withLabel:@"Loading."];
        return YES;
    }
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [DejalBezelActivityView removeViewAnimated:YES ];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
     [DejalBezelActivityView removeViewAnimated:YES ];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data

{
    [receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                    message:[NSString stringWithFormat:@"%@", error]
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    NSDictionary *tokenData = [NSJSONSerialization JSONObjectWithData:receivedData options:kNilOptions error:nil];
    
    //[unifiGlobalVariable sharedGlobalData].refreshToken = [tokenData objectForKey:@"refresh_token"];
    unifiGoogleNavigationController *googleNavigation =  (unifiGoogleNavigationController *)self.navigationController;
    
    if([googleNavigation.tokenDelegate respondsToSelector:@selector(unifiGoogleNavigation:finishWithRefreshToken:)]){
        [googleNavigation.tokenDelegate unifiGoogleNavigation:googleNavigation finishWithRefreshToken:[tokenData objectForKey:@"refresh_token"]];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)backButtonPressed:(id)sender {
    [webview goBack];
}
-(IBAction)cancelAuthenticaiton:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleBlackTranslucent;
}
@end
