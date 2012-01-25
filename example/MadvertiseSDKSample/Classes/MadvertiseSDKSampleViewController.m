// Copyright 2011 madvertise Mobile Advertising GmbH
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#import "MadvertiseSDKSampleViewController.h"
#import "MadvertiseView.h"
#import "MadvertiseSDKSampleDelegate.h"
#import "MadvertiseTracker.h"
#import "MadvertiseUtilities.h"

@implementation MadvertiseSDKSampleViewController

MadvertiseView *ad;


- (void)dealloc {
  if(madvertiseDemoDelegate)
    [madvertiseDemoDelegate release];
  [super dealloc];
}


- (void)showAd:(id)sender event:(id)event
{
  if(ad)
    return;
  madvertiseDemoDelegate = [[MadvertiseSDKSampleDelegate alloc] init];
  ad = [MadvertiseView loadAdWithDelegate:madvertiseDemoDelegate withClass:MadvertiseAdClassMMA secondsToRefresh:2];
  //ad = [MadvertiseView loadRichMediaAdWithDelegate:madvertiseDemoDelegate];
  [ad place_at_x:0 y:60];
  [self.view addSubview:ad];
  [self.view bringSubviewToFront:ad];
}

- (void)removeAd:(id)sender event:(id)event
{
  if(ad)
    [ad removeFromSuperview];
  ad = nil; 
}

- (void)viewDidLoad {
  [super viewDidLoad];

  UIButton *btn= [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
  btn.frame = CGRectMake(100, 100, 100, 25);
  btn.backgroundColor = [UIColor clearColor];
  [btn addTarget:self action:@selector(showAd:event:) forControlEvents:UIControlEventTouchUpInside];
  [btn setTitle:@"Show ad" forState:UIControlStateNormal];
  [self.view addSubview:btn]; 
  [btn release];

  
  UIButton *btn2= [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
  btn2.frame = CGRectMake(100, 200, 100, 25);
  btn2.backgroundColor = [UIColor clearColor];
  [btn2 addTarget:self action:@selector(removeAd:event:) forControlEvents:UIControlEventTouchUpInside];
  [btn2 setTitle:@"Remove" forState:UIControlStateNormal];
  [self.view addSubview:btn2]; 
  [btn2 release];
  
//  MadvertiseView *ad2 = [MadvertiseView loadAdWithDelegate:madvertiseDemoDelegate withClass:MadvertiseAdClassLeaderboard secondsToRefresh:25];
//  [ad2 place_at_x:0 y:140];
//  [self.view addSubview:ad2];
//  [self.view bringSubviewToFront:ad2];
//  
//  
//  MadvertiseView *ad3 = [MadvertiseView loadAdWithDelegate:madvertiseDemoDelegate withClass:MadvertiseAdClassPortrait secondsToRefresh:25];
//  [ad3 place_at_x:0 y:320];
//  [self.view addSubview:ad3];
//  [self.view bringSubviewToFront:ad3];
//  
//  
//  ad3 = [MadvertiseView loadAdWithDelegate:madvertiseDemoDelegate withClass:MadvertiseAdClassFullscreen secondsToRefresh:25];
//  [ad3 place_at_x:0 y:420];
//  [self.view addSubview:ad3];
//  [self.view bringSubviewToFront:ad3];
}


- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}


#pragma mark - 
#pragma mark Notifications

- (void) onAdLoadedSuccessfully:(NSNotification*)notify{
  MadLog(@"successfully loaded with code: %@",[notify object]);
}

- (void) onAdLoadedFailed:(NSNotification*)notify{
  MadLog(@"ad load faild with code: %@",[notify object]);
}
- (void) onAdClose:(NSNotification*)notify{
  // can occure for rich media ads which do not refresh automatically
  MadLog(@"ad was closed");
  if(ad)
    [ad removeFromSuperview];
  ad = nil; 
}

- (void) viewWillAppear:(BOOL)animated{
  //observing adLoaded, adLoadFailed and adClose Events
  [MadvertiseView adLoadedHandlerWithObserver:self AndSelector:@selector(onAdLoadedSuccessfully:)];
  [MadvertiseView adLoadFailedHandlerWithObserver:self AndSelector:@selector(onAdLoadedFailed:)];
  [MadvertiseView adClosedHandlerWithObserver:self AndSelector:@selector(onAdClose:)];
  
}

- (void) viewWillDisappear:(BOOL)animated{
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
