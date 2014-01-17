//
//  UIStatusView.m
//  DrPalm
//
//  Created by fgx_lion on 12-4-11.
//  Copyright (c) 2012年 DrCOM. All rights reserved.
//

#import "UIStatusView.h"
#import "ResourceManager.h"
#import "UIColor+RGB.h"
#import "../ImageDefine.h"

#define FastTimeInterval    (1 * 60.0f)
#define FastInterval        10.0f
#define SlowInterval        10.0f //(1 * 60.0f)

@interface NSMutableArray(LeftLoop)
-(void)pushFront:(id)item;
-(void)frontToBack;
@end

@implementation NSMutableArray(LeftLoop)
-(void)pushFront:(id)item
{
    for (int i = 0; i < [self count]; i++) {
        if ([[self objectAtIndex:i] isEqual:item]){
            id temp = [[self objectAtIndex:i] retain];
            [self removeObjectAtIndex:i];
            [self addObject:temp];
            [temp release];
            break;
        }
    }
}

-(void)frontToBack
{
    if ([self count] > 1){
        id value = [[self objectAtIndex:0] retain];
        [self removeObjectAtIndex:0];
        [self addObject:value];
        [value release];
    }
}
@end

@interface MessageItem : NSObject {
@private
    NSString*   _key;
    NSString*   _message;
    NSInteger   _displeyCount;
}

@property (nonatomic, retain) NSString* key;
@property (nonatomic, retain) NSString* message;
@property (nonatomic, assign) NSInteger displeyCount;
@end

@implementation MessageItem
@synthesize key = _key;
@synthesize message = _message;
@synthesize displeyCount = _displeyCount;
- (void)dealloc
{
    self.key = nil;
    self.message = nil;
    [super dealloc];
}
@end

@interface UIStatusView()
@property (nonatomic, retain) UIImageView*  backgroundView;
@property (nonatomic, retain) UILabel*   textLabel;
@property (nonatomic, retain) NSMutableDictionary*  msgKeyDictionary;
@property (nonatomic, retain) NSMutableArray*   msgArray;
@property (nonatomic, retain) NSTimer*      timer;
@property (nonatomic, retain) NSTimer*      fastTimer;

-(void)changeMessage:(NSTimer*)theTimer;
-(void)animationDidStop:(NSString *)animationID;
-(BOOL)showCurrentMessage;
-(void)moveMessageIn;
-(void)moveMessageOut;
-(void)runFast;
-(void)stopFast;
-(BOOL)run:(NSTimeInterval)interval;
-(BOOL)stop;
-(void)changeToSlow;
@end

@implementation UIStatusView
@synthesize backgroundView = _backgroundView;
@synthesize textLabel = _textLabel;
@synthesize msgKeyDictionary = _msgKeyDictionary;
@synthesize msgArray = _msgArray;
@synthesize timer = _timer;
@synthesize fastTimer = _fastTimer;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIImage* imageStatusBackground = [UIImage imageWithContentsOfFile:[ResourceManager resourceFilePath:StatusViewBackground]];
        _height = imageStatusBackground.size.height;
        _backgroundView = [[UIImageView alloc ] initWithImage:imageStatusBackground];
        _backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _backgroundView.frame = self.bounds;
        [self addSubview:_backgroundView];
        
        _textLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _textLabel.textAlignment = UITextAlignmentCenter;
        _textLabel.textColor = [UIColor whiteColor];
        _textLabel.backgroundColor = [UIColor clearColor];
        _textLabel.lineBreakMode = UILineBreakModeTailTruncation;
        _textLabel.shadowColor = [UIColor colorWithIntRGB:0 green:0 blue:0 alpha:60];
        _textLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _textLabel.frame = _backgroundView.bounds;
        _textLabel.font = [UIFont boldSystemFontOfSize:13.0];
        [_backgroundView addSubview:_textLabel];
        
        self.msgArray = [NSMutableArray array];
        self.msgKeyDictionary = [NSMutableDictionary dictionary];
        self.timer = nil;
        self.fastTimer = nil;
    }
    return self;
}

-(void)dealloc
{
    [self stopFast];
    
    [self.backgroundView removeFromSuperview];
    self.backgroundView = nil;
    
    [self.textLabel removeFromSuperview];
    self.textLabel = nil;
    
    self.msgKeyDictionary = nil;
    self.msgArray = nil;
    
    self.timer = nil;
    self.fastTimer = nil;
    [super dealloc];
}

#pragma mark - Public Function
-(BOOL)addMessage:(NSString*)key message:(NSString*)message
{
    return [self addMessage:key message:message displayTimes:3];
}

-(BOOL)addMessage:(NSString*)key message:(NSString*)message displayTimes:(NSInteger)displayTimes
{
    @synchronized(self) {
        MessageItem* item = [[[MessageItem alloc] init] autorelease];
        item.key = key;
        item.message = message;
        item.displeyCount = displayTimes;
        
        id value = [self.msgKeyDictionary objectForKey:key];
        if ([message length] > 0){
            if (nil != value && ![value isKindOfClass:[NSNull class]]){
                [self.msgKeyDictionary removeObjectForKey:key];
//                [self.msgArray pushFront:key];
            }
            else{
//                [self.msgArray insertObject:key atIndex:0];
                [self.msgArray addObject:key];
            }
            
            
            [self.msgKeyDictionary setObject:item forKey:key];
        }
        else{
            // message为空时，删除
            if (nil != value && ![value isKindOfClass:[NSNull class]]){
                [self.msgKeyDictionary removeObjectForKey:key];
                for (NSString* msgKey in self.msgArray){
                    if ([msgKey isEqualToString:key]){
                        [self.msgArray removeObject:msgKey];
                        break;
                    }
                }
            }
            
            // 没有数据时stop
            if ([self.msgArray count] <= 1){
                [self stop];
            }
        }
        
        
        if ([self.msgArray count] == 0){
            _textLabel.text = @"";
        }
        else if ([self.msgArray count] == 1){
            // 只有一条数据时不显示动画
            [self stopFast];
            [self showCurrentMessage];
            [self moveMessageIn];
        }
        else if ([message length] > 0){
            [self runFast];
        }
    }
    
    return YES;
}

-(BOOL)run:(NSTimeInterval)interval
{
    [self stop];
    if (nil == self.timer){
        // 先显示第一条，再set timer
        [self showCurrentMessage];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(changeMessage:) userInfo:nil repeats:YES];
    }
    return (nil != self.timer);
}

-(BOOL)stop
{
    [self.timer invalidate];
    self.timer = nil;
    return YES;
}

-(NSInteger)height
{
    return _height;
}

#pragma mark - Fast Timer
-(void)runFast
{
//    [self stopFast];
    if (nil == self.fastTimer){
        self.fastTimer = [NSTimer scheduledTimerWithTimeInterval:FastTimeInterval target:self selector:@selector(changeToSlow) userInfo:nil repeats:NO];
        [self run:FastInterval];
    }
}

-(void)stopFast
{
    [self stop];
    
    [self.fastTimer invalidate];
    self.fastTimer = nil;
}

-(void)changeToSlow
{
    [self run:SlowInterval];
}

#pragma mark - Animation
#define MoveOut @"MoveOut"
#define MoveIn  @"MoveIn"
-(void)changeMessage:(NSTimer*)theTimer
{	
    [self moveMessageOut];
}

-(void)animationDidStop:(NSString *)animationID
{
    if ([animationID isEqualToString:MoveOut]){
        if ([self showCurrentMessage]){
            _textLabel.center = CGPointMake(_textLabel.center.x, _backgroundView.bounds.size.height * 1.5f);
            [self moveMessageIn];
        }
    }
}

-(void)moveMessageIn
{
    [UIView beginAnimations:MoveIn context:NULL];
    [UIView setAnimationDelegate:nil];
    [UIView setAnimationDidStopSelector:nil];
    [UIView setAnimationDelay:1.0f];
    [UIView setAnimationDuration:0.3f];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    _textLabel.frame = _backgroundView.bounds;
    _textLabel.alpha = 1.0f;
    [UIView commitAnimations];
}

-(void)moveMessageOut
{
    [UIView beginAnimations:MoveOut context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:)];
    [UIView setAnimationDuration:0.3f];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    _textLabel.center = CGPointMake(_textLabel.center.x, 0.0 - _textLabel.bounds.size.height/2.0f);
    _textLabel.alpha = 0.0f;
    [UIView commitAnimations];
}

-(BOOL)showCurrentMessage
{
    BOOL result = NO;
    @synchronized(self) {
        if ([self.msgArray count] > 0){
            NSString* key = [self.msgArray objectAtIndex:0];
            
            MessageItem* item = [self.msgKeyDictionary objectForKey:key];
            _textLabel.text = [NSString stringWithFormat:@"%@: %@", key, item.message];
            [self.msgArray frontToBack];
        
            result = YES;
        }
    }
    return result;
}

@end
