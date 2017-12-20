//
//  ViewController.m
//  Stopwatch
//
//  Created by Mansi Barodia on 12/17/17.
//  Copyright © 2017 Mansi Barodia. All rights reserved.
//

#import "ViewController.h"

NSString *DEFAULT_TIMER = @"00:00:00";

@interface ViewController ()
@property (nonatomic) IBOutlet UIButton *startButton;
@property (nonatomic) IBOutlet UIButton *resetButton;
@property (nonatomic) IBOutlet UIImageView *hexagonImageView;
@property (nonatomic) IBOutlet UILabel *textField;
@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *pauseDate;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic) NSUInteger timeElapsed;
@property (nonatomic) NSTimeInterval pauseTime;
@property (nonatomic) BOOL isPaused;
@property (nonatomic) BOOL isRunning;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    [self createContainer];
    self.pauseTime = 0;
    self.timeElapsed = 0;
    
    self.startButton.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:24];
    [self.startButton setTitle:NSLocalizedString(@"startTimer", comment: @"Start button title") forState:UIControlStateNormal];
    [self.view addSubview:self.startButton];
    [self.startButton addTarget:self
                         action:@selector(stopWatchStart)
               forControlEvents:UIControlEventTouchUpInside];
    
    self.resetButton.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:24];
    [self.resetButton setTitle:NSLocalizedString(@"resetTimer", comment: @"Reset button title") forState:UIControlStateNormal];
    [self.view addSubview:self.resetButton];
    [self.resetButton addTarget:self
                         action:@selector(stopWatchReset)
               forControlEvents:UIControlEventTouchUpInside];
    self.resetButton.hidden = YES;
    
    self.textField.font = [UIFont fontWithName:@"Helvetica" size:48];
    self.textField.text = DEFAULT_TIMER;
    self.textField.textColor = [UIColor whiteColor];
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)stopWatchStart
{
    if(!self.isRunning)
    {
        self.isRunning = YES;
        self.startDate = [NSDate date];
        self.timer = [NSTimer timerWithTimeInterval:0.5 target:self selector:@selector(updateTimeLabel) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
        
        [self.startButton setTitle:NSLocalizedString(@"pauseTimer", comment: @"Pause button title") forState:UIControlStateNormal];
    }
    else if (self.isRunning && !self.isPaused)
    {
        [self.timer invalidate];
        self.isPaused = YES;
        self.pauseDate = [NSDate date];
        
        [self.startButton setTitle:NSLocalizedString(@"resumeTimer", comment: @"Resume button title") forState:UIControlStateNormal];
    }
    else if(self.isPaused)
    {
        self.isPaused = NO;
        self.pauseTime += [[NSDate date] timeIntervalSinceDate:self.pauseDate];
        
        self.timer = [NSTimer timerWithTimeInterval:0.5 target:self selector:@selector(updateTimeLabel) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
        
        [self.startButton setTitle:NSLocalizedString(@"pauseTimer", comment: @"Pause button title") forState:UIControlStateNormal];
    }
    
    self.resetButton.hidden = NO;
}

- (void)stopWatchReset
{
    if(self.isRunning)
    {
        self.isRunning = NO;
        self.isPaused = NO;
        self.pauseTime = 0;
        self.textField.text = DEFAULT_TIMER;
        self.resetButton.hidden = YES;
        [self.timer invalidate];
        [self.startButton setTitle:NSLocalizedString(@"startTimer", comment: @"Start button title") forState:UIControlStateNormal];
    }
}

- (void) updateTimeLabel
{
    NSTimeInterval elapsedTime = [[NSDate date] timeIntervalSinceDate:_startDate];
    self.timeElapsed= (NSUInteger) (elapsedTime - _pauseTime);
    NSUInteger hours = self.timeElapsed / (3600);
    NSUInteger minutes = (self.timeElapsed / 60) % 60;
    NSUInteger seconds = self.timeElapsed % 60;
    self.textField.text = [NSString stringWithFormat:@"%02lu:%02lu:%02lu", (unsigned long)hours, (unsigned long)minutes, (unsigned long)seconds];
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (void)createContainer
{
    _hexagonImageView.backgroundColor = [UIColor blackColor];
    _hexagonImageView.layer.cornerRadius = _hexagonImageView.frame.size.width / 4;
    _hexagonImageView.clipsToBounds = YES;
    _hexagonImageView.layer.borderWidth = 3.0f;
    _hexagonImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    
    CGRect frame = _hexagonImageView.frame;
    frame.origin.x = ([[UIScreen mainScreen] bounds].size.width - frame.size.width)/2;
    _hexagonImageView.frame = frame;
}

@end
