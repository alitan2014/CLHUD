//
//  ViewController.m
//  CLHUD
//
//  Created by 谭春林 on 2019/3/3.
//  Copyright © 2019 alitan2014. All rights reserved.
//

#import "ViewController.h"
#import "CLLoadingHUD.h"
@interface ViewController ()
@property (nonatomic ,strong) CLLoadingHUD *loadingHud;
@property (nonatomic ,assign) CGFloat progress;
@property (nonatomic ,strong) NSTimer *timer;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _progress = 0;
    _loadingHud = [[CLLoadingHUD alloc]initWithFrame:CGRectMake(100, 50, 100, 200)];
    [_loadingHud setProgressColor:UIColor.yellowColor];
    [_loadingHud setProgressBackgroundColor:UIColor.grayColor];
    [_loadingHud setProgressTotalLength:200];
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.35 target:self selector:@selector(update) userInfo:nil repeats:YES];
    [_timer fire];
    [self.view addSubview:_loadingHud];
    
}

-(void)update{
    _progress ++;
    [_loadingHud updateProgeressWithProgress:_progress];
}
@end
