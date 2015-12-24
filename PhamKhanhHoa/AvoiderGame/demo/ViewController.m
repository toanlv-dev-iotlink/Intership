//
//  ViewController.m
//  demo
//
//  Created by HTK-Hoa on 12/21/15.
//  Copyright (c) 2015 HTK-Hoa. All rights reserved.
//

#import "ViewController.h"
#import "DeFeatViewController.h"
#import <QuartzCore/QuartzCore.h>


@interface ViewController ()
{
    int score;
    __weak IBOutlet UILabel *lbScore;
    int count;
    int x_pointFront;
    int y_pointFront;
    int x_pointBehind;
    int y_pointBehind;
    int x_pointFront1;
    int y_pointFront1;
    int x_pointBehind1;
    int y_pointBehind1;
    CFDataRef pxDataMonster;
    const UInt8* dataMonster;
    CFDataRef pxDataPlane;
    const UInt8* dataPlane;
    CFDataRef pxDataBullet;
    const UInt8* dataBullet;
    UIImage *monsterR;
    NSArray *changeMonster;
}
@property (nonatomic) IBOutlet UIImageView *plane;
@property (nonatomic) IBOutlet UIImageView *boom;
@property CADisplayLink *displayLink;
@property CADisplayLink *displayLink1;
@property (strong,nonatomic) NSMutableArray *monster;
@property (strong,nonatomic) NSMutableArray *bullet;
@property (strong,nonatomic) NSMutableArray *arrboom;
@property (strong,nonatomic) NSMutableArray *dataChangeMonster;
@property (strong,nonatomic) NSMutableArray *idMonster;

@end

@implementation ViewController

- (void)viewDidAppear:(BOOL)animated{
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"AvoiderGame";
    _monster = [[NSMutableArray alloc] init];
    _bullet = [[NSMutableArray alloc] init];
    _arrboom = [[NSMutableArray alloc] init];
    _dataChangeMonster = [[NSMutableArray alloc] init];
    _idMonster = [[NSMutableArray alloc] init];
    //background
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"background.jpg"] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    _plane = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-47/2, self.view.frame.size.height-63, 47, 63)];
    _plane.image = [UIImage imageNamed:@"plane.png"];
    //plane
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panPlane:)];
    [self.view addGestureRecognizer:pan];
    [self.view addSubview:_plane];
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
    //data to get alpha color
    UIImage *im = [UIImage imageNamed:@"monster1.png"];
    pxDataMonster = CGDataProviderCopyData(CGImageGetDataProvider(im.CGImage));
    dataMonster = CFDataGetBytePtr(pxDataMonster);
    UIImage *imPlane = [UIImage imageNamed:@"plane.png"];
    pxDataPlane = CGDataProviderCopyData(CGImageGetDataProvider(imPlane.CGImage));
    dataPlane = CFDataGetBytePtr(pxDataPlane);
    UIImage *imBullet = [UIImage imageNamed:@"bullet.png"];
    pxDataBullet = CGDataProviderCopyData(CGImageGetDataProvider(imBullet.CGImage));
    dataBullet = CFDataGetBytePtr(pxDataBullet);
    //add im to boom array
    UIImage *imageBoom = [UIImage imageNamed:@"boom.png"];
    for (int i=0; i<1152; i+=192) {
        for (int j=0; j<960; j+=192) {
            CGRect fromRect = CGRectMake(j, i, 192, 192);
            CGImageRef drawImage = CGImageCreateWithImageInRect(imageBoom.CGImage, fromRect);
            UIImage *newImage = [UIImage imageWithCGImage:drawImage];
            [_arrboom addObject:newImage];
            CGImageRelease(drawImage);
        }
    }
    //rand image.
    changeMonster = [[NSArray alloc] initWithObjects:[UIImage imageNamed:@"monster0.png"],[UIImage imageNamed:@"monster1.png"],[UIImage imageNamed:@"monster2.png"],[UIImage imageNamed:@"monster3.png"],[UIImage imageNamed:@"monster4.png"], nil];
    for (int i = 0; i<5; i++) {
        UIImage *imTemp = [changeMonster objectAtIndex:i];
        CFDataRef pxDataChangeMonster = CGDataProviderCopyData(CGImageGetDataProvider(imTemp.CGImage));
        const UInt8 *dataChangeMonster = CFDataGetBytePtr(pxDataChangeMonster);
        NSData *data = [NSData dataWithBytes:dataChangeMonster length:sizeof(dataChangeMonster)];
        [_dataChangeMonster addObject:data];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (IBAction)actionPlay:(id)sender {
    [self startMonster];
    [self startBullet];
}
- (IBAction)actionPause:(id)sender {
    if (count%2) {
        [self stop];
    }else{
        [self startMonster];
    }
    count++;
}
- (void)startMonster {
    CADisplayLink *dl = [CADisplayLink displayLinkWithTarget:self selector:@selector(timerCallBackMonster:)];
    dl.frameInterval = 1;
    [dl addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    self.displayLink = dl;
    
}

- (void)startBullet {
    CADisplayLink *dl = [CADisplayLink displayLinkWithTarget:self selector:@selector(timerCallBackBullet:)];
    dl.frameInterval = 1;
    [dl addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    self.displayLink1 = dl;
    
}

- (void)stop {
    [self.displayLink removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    [self.displayLink1 removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    [self performSegueWithIdentifier:@"endGameSegue" sender:nil];
}

- (IBAction)panPlane:(id)sender {
    if ([sender isKindOfClass:[UIPanGestureRecognizer class]]) {
        UIPanGestureRecognizer *pan = (UIPanGestureRecognizer *)sender;
        CGRect newPlane = _plane.frame;
        CGPoint point = [pan locationInView:_plane.superview];
        newPlane.origin.x = point.x-_plane.frame.size.width/2;
        _plane.frame = newPlane;
    }
}

- (void)timerCallBackMonster:(CADisplayLink*)sender {
    if (_monster.count) {
        for (int i=0; i<_monster.count; i++) {
            UIImageView *temp = [_monster objectAtIndex:i];
            int tempid = [[_idMonster objectAtIndex:i] intValue];
            CGRect theMonter = temp.frame;
            UInt8* data = (UInt8*) [[_dataChangeMonster objectAtIndex:tempid] bytes];
            if (theMonter.origin.y >= self.view.frame.size.height) {
                [_monster removeObjectAtIndex:i];
                [_idMonster removeObjectAtIndex:i];
                score +=10;
                lbScore.text = @(score).stringValue;
            }else{
                theMonter.origin.y+=1;
                temp.frame= theMonter;
                if ([self checkCollision:temp and:_plane]||[self checkCollision:_plane and:temp]) {
                    x_pointBehind = 0;
                    x_pointFront = 0;
                    y_pointBehind = 0;
                    y_pointFront = 0;
                    [self checkPoint:temp plane:_plane];
                    for (int i = x_pointFront; i<=x_pointBehind; i++) {
                        for (int j = y_pointFront; j<=y_pointBehind; j++) {
                            if ([self checkAlphaColor:temp.image xOfInmage:i-temp.frame.origin.x yOfImage:j-temp.frame.origin.y data:data]&&
                                [self checkAlphaColor:_plane.image xOfInmage:i-_plane.frame.origin.x yOfImage:j-_plane.frame.origin.y data:(UInt8*)dataPlane]) {
                                [self createBoom:_plane.frame.origin.x y:_plane.frame.origin.y];
                                if (![_plane isAnimating]) {
                                    [_plane removeFromSuperview];
                                    [self stop];
                                    return;
                                }
                                
                            }
                        }
                    }
                    
                    
                }
            }
            
        }
    }
    int randNum = rand() % 345;
    int randXS = rand() % 100;
    int randMT = rand()% 5;
    if (randXS==10&&_monster.count<10) {
        UIImageView *newMonter = [[UIImageView alloc] initWithFrame:CGRectMake(randNum, 0, 40, 40)];
        newMonter.image = [changeMonster objectAtIndex:randMT];
        [_monster addObject:newMonter];
        [_idMonster addObject:@(randMT).stringValue];
        [self.view addSubview:newMonter];
    }

}

- (void)timerCallBackBullet:(CADisplayLink*)sender {
    if (_bullet.count) {
        for (int i=0; i<_bullet.count; i++) {
            UIImageView *tempBullet =[_bullet objectAtIndex:i];
            CGRect theBullet = tempBullet.frame;
            if (theBullet.origin.y <= 0) {
                [_bullet removeObjectAtIndex:i];
                [tempBullet removeFromSuperview];
            }else{
                theBullet.origin.y-=3;
                tempBullet.frame = theBullet;
                for (int j=0; j<_monster.count; j++) {
                    UIImageView *tempMonster = [_monster objectAtIndex:j];
                    if ([self checkCollision:tempMonster and:tempBullet]||[self checkCollision:tempBullet and:tempMonster]) {
                        x_pointBehind1 = 0;
                        x_pointFront1 = 0;
                        y_pointBehind1 = 0;
                        y_pointFront1 = 0;
                        BOOL check = false;
                        [self checkPointBullet:tempMonster bullet:tempBullet];
                        for (int i = x_pointFront1; i<=x_pointBehind1; i++) {
                            for (int j = y_pointFront1; j<=y_pointBehind1; j++) {
                                if ([self checkAlphaColor:tempMonster.image xOfInmage:i-tempMonster.frame.origin.x yOfImage:j-tempMonster.frame.origin.y data:(UInt8*)dataMonster]&&
                                    [self checkAlphaColor:tempBullet.image xOfInmage:i-tempBullet.frame.origin.x yOfImage:j-tempBullet.frame.origin.y data:(UInt8*)dataBullet]) {
                                    [tempMonster removeFromSuperview];
                                    [tempBullet removeFromSuperview];
                                    [_bullet removeObject:tempBullet];
                                    [_monster removeObject:tempMonster];
                                    
                                    [self createBoom:tempMonster.frame.origin.x y:tempMonster.frame.origin.y];
                                    score+=10;
                                    lbScore.text = @(score).stringValue;
                                    check = true;
                                    break;
                                }
                            }
                            if (check) {
                                break;
                            }
                        }
                        
                        
                    }
                }
                
            }
        }
    }
    int randXSB = rand() % 100;
    if (randXSB==10&&_bullet.count<20) {
        UIImageView *newBullet = [[UIImageView alloc] initWithFrame:CGRectMake(_plane.frame.origin.x+_plane.frame.size.width/2-8, _plane.frame.origin.y, 16, 16)];
        newBullet.image = [UIImage imageNamed:@"bullet.png"];
        [_bullet addObject:newBullet];
        [self.view addSubview:newBullet];
    }
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"endGameSegue"]) {
        DeFeatViewController *vc = [segue destinationViewController];
        vc.score = score;
    }
}

- (BOOL)checkCollision:(UIImageView *)monster and:(UIImageView *)plane{
    int x_plane = plane.frame.origin.x;
    int y_plane = plane.frame.origin.y;
    int x_monster = monster.frame.origin.x;
    int y_monster = monster.frame.origin.y;
    int w_plane = plane.frame.size.width;
    int h_monster = monster.frame.size.height;
    int w_monster = monster.frame.size.width;
    if ((x_monster<=x_plane<=(x_monster+w_monster)&&y_monster<=y_plane<=(y_monster+h_monster))||
        (x_monster<=(x_plane+w_plane)<=(x_monster+w_monster)&&y_monster<=y_plane<=(y_monster+h_monster))||
        (x_monster<=(x_plane+w_plane/2)<=(x_monster+w_monster)&&y_monster<=y_plane<=(y_monster+h_monster))){
        return true;
    }else{
        return false;
    }
}

- (void)checkPoint:(UIImageView *)monster plane:(UIImageView *)plane{
    int x_plane = plane.frame.origin.x;
    int y_plane = plane.frame.origin.y;
    int x_monster = monster.frame.origin.x;
    int y_monster = monster.frame.origin.y;
    int h_plane = plane.frame.size.height;
    int w_plane = plane.frame.size.width;
    int h_monster = monster.frame.size.height;
    int w_monster = monster.frame.size.width;
    x_pointFront = MAX(x_monster, x_plane);
    y_pointFront = MAX(y_monster, y_plane);
    x_pointBehind = MIN(x_monster+w_monster, x_plane+w_plane);
    y_pointBehind = MIN(y_monster+h_monster, y_plane+h_plane);
}

- (void)checkPointBullet:(UIImageView *)monster bullet:(UIImageView *)bullet{
    int x_plane = bullet.frame.origin.x;
    int y_plane = bullet.frame.origin.y;
    int x_monster = monster.frame.origin.x;
    int y_monster = monster.frame.origin.y;
    int h_plane = bullet.frame.size.height;
    int w_plane = bullet.frame.size.width;
    int h_monster = monster.frame.size.height;
    int w_monster = monster.frame.size.width;
    x_pointFront1 = MAX(x_monster, x_plane);
    y_pointFront1 = MAX(y_monster, y_plane);
    x_pointBehind1 = MIN(x_monster+w_monster, x_plane+w_plane);
    y_pointBehind1 = MIN(y_monster+h_monster, y_plane+h_plane);
}

- (BOOL)checkAlphaColor:(UIImage *)image xOfInmage:(int)x yOfImage:(int)y data:(UInt8 *) data{
    int pixelInfo = ((image.size.width  * y) + x ) * 4;
    UInt8 alpha = data[pixelInfo + 3];
    if (alpha==255) return YES;
    else return NO;
    
}

- (void)createBoom:(int)x y:(int)y{
    _boom = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, 64, 64)];
    [self.view addSubview:_boom];
    _boom.animationImages = _arrboom;
    _boom.animationDuration = 1.5;
    _boom.animationRepeatCount = 1;
    _boom.contentMode = UIViewContentModeScaleAspectFill;
    [_boom startAnimating];
}

@end
