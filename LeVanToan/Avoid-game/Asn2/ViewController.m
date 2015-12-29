//
//  ViewController.m
//  Asn2
//
//  Created by Z on 12/22/15.
//  Copyright (c) 2015 Z. All rights reserved.
//
#define maxShoot 4
#import "ViewController.h"
#import "GameOverViewController.h"
@interface ViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *player;
@property (strong, nonatomic) NSMutableArray *enemies;
@property (strong, nonatomic) NSMutableArray *bullets;
@property (strong, nonatomic) NSMutableArray *boomViews;
@property int score;
@property (weak, nonatomic) IBOutlet UILabel *scoreLb;
@property UInt8 *data1;
@property UInt8 *data2;
@property UInt8 *data3;
@property CGPoint panLoccation;
@property int checkShoot;
@property (strong, nonatomic) NSMutableArray *booms;
@property BOOL playerDied;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createDataPixel];
    [self customInit];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"space1.png"]];
    
    _player = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-32, self.view.frame.size.height-64, 64, 64)];
    _player.image = [UIImage imageNamed:@"ship.png"];
    
    [self.view addSubview:_player];
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(movePlayer:)];

    [self.view addGestureRecognizer:pan];
}
-(void)customInit{
    _score = 0;
    _checkShoot = 0;
    _playerDied = false;
    _booms = [[NSMutableArray alloc] init];
    UIImage *boom = [UIImage imageNamed:@"boom.png"];
    for (int j = 0; j < 6; j++) {
        for (int i = 0; i < 5; i++) {
            CGRect fromRect = CGRectMake(i*192, j*192, 192, 192);
            CGImageRef drawImage = CGImageCreateWithImageInRect(boom.CGImage, fromRect);
            UIImage *newImage = [UIImage imageWithCGImage:drawImage];
            [_booms addObject:newImage];
            CGImageRelease(drawImage);
        }
    }
    _enemies = [[NSMutableArray alloc] init];
    _bullets = [[NSMutableArray alloc] init];
    _boomViews = [[NSMutableArray alloc] init];
}
-(void)createDataPixel{
    CFDataRef pixelData1 = CGDataProviderCopyData(CGImageGetDataProvider([UIImage imageNamed:@"ship.png"].CGImage));
    _data1 = (UInt8 *)CFDataGetBytePtr(pixelData1);
    CFDataRef pixelData2 = CGDataProviderCopyData(CGImageGetDataProvider([UIImage imageNamed:@"monster.png"].CGImage));
    _data2 = (UInt8 *)CFDataGetBytePtr(pixelData2);
    CFDataRef pixelData3 = CGDataProviderCopyData(CGImageGetDataProvider([UIImage imageNamed:@"bullet.png"].CGImage));
    _data3 = (UInt8 *)CFDataGetBytePtr(pixelData3);

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (void)viewDidAppear:(BOOL)animated{
    [self start];
}
-(void)start{
    CADisplayLink *dl = [CADisplayLink displayLinkWithTarget:self selector:@selector(timerCallBack:)];
    dl.frameInterval = 0.04;
    [dl addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
}


-(void)timerCallBack:(CADisplayLink *)sender{
    [self moveEnemiesAndCheckCollision:sender];
    [self moveBulletAndCheckCollision];
    [self createEnemy];
    [self removeEnemyAndScore];
    [self removeBulletAndScore];
    [self removeBoom];
}
-(void)createBullet{
    UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bullet.png"]];
    CGRect new = iv.frame;
    new.origin.x = _player.frame.origin.x+ _player.frame.size.width/2;
    new.origin.y = self.view.frame.size.height-_player.frame.size.height;
    iv.frame= new;
    [self.bullets addObject:iv];
    [self.view addSubview:iv];
}
-(void)moveBulletAndCheckCollision{
    if (_bullets.count) {
        for (int i = 0; i<_bullets.count; i++) {
            UIImageView *bullet = (UIImageView *)[_bullets objectAtIndex:i];
            CGRect newFrame = bullet.frame;
            newFrame.origin.y-=5;
            bullet.frame = newFrame;
            for (int i = 0; i<_enemies.count; i++) {
                UIImageView *enemy = (UIImageView *)[_enemies objectAtIndex:i];
                if (aCollisionB(bullet, enemy)) {
                    int x1 = MAX(enemy.frame.origin.x, bullet.frame.origin.x);
                    int y1 = MAX(enemy.frame.origin.y, bullet.frame.origin.y);
                    int x2 = MIN(enemy.frame.origin.x+enemy.frame.size.width, bullet.frame.origin.x+bullet.frame.size.width);
                    int y2 = MIN(enemy.frame.origin.y+enemy.frame.size.height, bullet.frame.origin.y+bullet.frame.size.height);
                    BOOL check = false;
                    for (int i = x1; i <= x2; i++) {
                        for (int j = y1; j <= y2; j++) {
                            if ([self isCollision2:i y:j image1:enemy image2:bullet]) {
                                [bullet removeFromSuperview];
                                [_bullets removeObject:bullet];
                                [self removeEnemy:enemy];
                                _score+=15;
                                _scoreLb.text = @(_score).stringValue;
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
-(void)removeBoom{
    if(_boomViews.count){
        for (int i = 0; i < _boomViews.count; i++) {
            UIImageView *boomView = [_boomViews objectAtIndex:i];
            if (!boomView.isAnimating) {
                [boomView removeFromSuperview];
                [_boomViews removeObject:boomView];
            }
        }
    }
}
-(void)removeEnemy:(UIImageView *)enemyView{
    UIImageView *a = [[UIImageView alloc] initWithFrame:enemyView.frame];
    [enemyView removeFromSuperview];
    [_enemies removeObject:enemyView];
    [self.view addSubview:a];
    a.animationImages = _booms;
    a.animationDuration = 1.5;
    a.animationRepeatCount = 1;
    [a startAnimating];
}
-(void)removeBulletAndScore{
    if (_bullets.count) {
        for (int i = 0; i<_bullets.count; i++) {
            UIImageView *temp = (UIImageView *)[_bullets objectAtIndex:i];
            if (temp.frame.origin.y <= 0) {
                [temp removeFromSuperview];
                [_bullets removeObject:temp];
            }
        }
    }
}
-(void)createEnemy{
    
    int xRandom =  arc4random_uniform(self.view.frame.size.width-64);
    UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"monster.png"]];
    CGRect new = iv.frame;
    new.origin.x = xRandom;
    new.origin.y = -48;
    iv.frame= new;
    //iv.backgroundColor = [UIColor redColor];
    int check = rand() % 50;
    if ((check == 1)&&(_enemies.count < 100)) {
        [self.enemies addObject:iv];
        [self.view addSubview:iv];
        //[self removeEnemy:iv];
    }
}
-(void)killPlayer{
    _playerDied = true;
    CGRect frame = CGRectMake(_player.center.x - 96, _player.center.y - 96, 192, 192);
    _player.frame = frame;
    _player.animationImages = _booms;
    _player.animationDuration = 1.5;
    _player.animationRepeatCount = 1;
    [_player startAnimating];
}
-(void)gameOverIfdied:(CADisplayLink *)sender{
    if ((_playerDied)&&(![_player isAnimating])) {
        [sender removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
        [self performSegueWithIdentifier:@"GameOver" sender:nil];
    }
}
-(void)moveEnemiesAndCheckCollision:(CADisplayLink *)sender{
    if (_enemies.count) {
        for (int i = 0; i<_enemies.count; i++) {
            UIImageView *temp = (UIImageView *)[_enemies objectAtIndex:i];
            CGRect newFrame = temp.frame;
            newFrame.origin.y+=1;
            temp.frame = newFrame;
            if (aCollisionB(temp, _player)) {
                int x1 = MAX(_player.frame.origin.x, temp.frame.origin.x);
                int y1 = MAX(_player.frame.origin.y, temp.frame.origin.y);
                int x2 = MIN(_player.frame.origin.x+_player.frame.size.width, temp.frame.origin.x+temp.frame.size.width);
                int y2 = MIN(_player.frame.origin.y+_player.frame.size.height, temp.frame.origin.y+temp.frame.size.height);
                BOOL check = false;
                for (int i = x1; i <= x2; i++) {
                    for (int j = y1; j <= y2; j++) {
                        if ([self isCollision:i y:j image1:_player image2:temp]) {
                            [sender removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
                            CADisplayLink *dl = [CADisplayLink displayLinkWithTarget:self selector:@selector(gameOverIfdied:)];
                            dl.frameInterval = 0.04;
                            [dl addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
                            [self killPlayer];
                            check = true;
                            break;
                        }
                        
                    }
                    if (check) {
                        break;
                    }
                }
                NSLog(@"");
            }
        }
    }
    
}
-(void)removeEnemyAndScore{
    if (_enemies.count) {
        for (int i = 0; i<_enemies.count; i++) {
            UIImageView *temp = (UIImageView *)[_enemies objectAtIndex:i];
            if (temp.frame.origin.y >= self.view.frame.size.height) {
                [temp removeFromSuperview];
                [_enemies removeObject:temp];
                _score+=15;
                _scoreLb.text = @(_score).stringValue;
            }
        }
    }
}
- (IBAction)movePlayer:(id)sender {
    UIPanGestureRecognizer *pan = (UIPanGestureRecognizer *)sender;
    CGRect newFrame = self.player.frame;
    CGPoint point = [pan locationInView:self.player.superview];
    if (point.y<_panLoccation.y) {
        if (_checkShoot == maxShoot) {
            [self createBullet];
            _checkShoot = 0;
        }
        else{
            _checkShoot++;
        }
    }
    else{
        _checkShoot = 0;
    }
    newFrame.origin.x = point.x-self.player.frame.size.width/2;
    self.player.frame = newFrame;
    _panLoccation = point;
}
BOOL
aCollisionB(UIImageView* a,UIImageView* b){
    CGPoint A = a.frame.origin;
    CGPoint B = CGPointMake(a.frame.origin.x+a.frame.size.width, a.frame.origin.y);
    CGPoint C = CGPointMake(a.frame.origin.x+a.frame.size.width, a.frame.origin.y+a.frame.size.height);
    CGPoint D = CGPointMake(a.frame.origin.x, a.frame.origin.y+a.frame.size.height);
    if (pInsideB(A, b)||pInsideB(B, b)||pInsideB(C, b)||pInsideB(D, b)) {
        return true;
    }
    return false;
}
-(BOOL)inside:(CGPoint)p doiVoi:(UIImageView *)b{
    if ((p.x > b.frame.origin.x)&&(p.x < (b.frame.origin.x+b.frame.size.width))&&(p.y > b.frame.origin.y)&&(p.y < (b.frame.origin.y+b.frame.size.height))) {
        return true;
    }
    return false;
}
BOOL
pInsideB(CGPoint p, UIImageView* b)
{
    if ((p.x >= b.frame.origin.x)&&(p.x <= (b.frame.origin.x+b.frame.size.width))&&(p.y >= b.frame.origin.y)&&(p.y <= (b.frame.origin.y+b.frame.size.height))) {
        return true;
    }
    return false;
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    GameOverViewController *new = segue.destinationViewController;
    new.score = @(_score).stringValue;
}
- (BOOL)isWallPixel1:(UIImage *)image xCoordinate:(int)x yCoordinate:(int)y {
    
    
    
    int pixelInfo = ((image.size.width  * y) + x ) * 4; // The image is png
    
    //UInt8 red = data[pixelInfo];         // If you need this info, enable it
    //UInt8 green = data[(pixelInfo + 1)]; // If you need this info, enable it
    //UInt8 blue = data[pixelInfo + 2];    // If you need this info, enable it
    UInt8 alpha = _data1[pixelInfo + 3];     // I need only this info for my maze game
    
    //UIColor* color = [UIColor colorWithRed:red/255.0f green:green/255.0f blue:blue/255.0f alpha:alpha/255.0f]; // The pixel color info
    
    if (alpha == 255) return true;
    else return false;
    
}
- (BOOL)isWallPixel2:(UIImage *)image xCoordinate:(int)x yCoordinate:(int)y {
    
    
    
    int pixelInfo = ((image.size.width  * y) + x ) * 4; // The image is png
    
    //UInt8 red = data[pixelInfo];         // If you need this info, enable it
    //UInt8 green = data[(pixelInfo + 1)]; // If you need this info, enable it
    //UInt8 blue = data[pixelInfo + 2];    // If you need this info, enable it
    UInt8 alpha = _data2[pixelInfo + 3];     // I need only this info for my maze game
    
    //UIColor* color = [UIColor colorWithRed:red/255.0f green:green/255.0f blue:blue/255.0f alpha:alpha/255.0f]; // The pixel color info
    
    if (alpha == 255) return true;
    else return false;
    
}
- (BOOL)isWallPixel3:(UIImage *)image xCoordinate:(int)x yCoordinate:(int)y {
    
    
    
    int pixelInfo = ((image.size.width  * y) + x ) * 4; // The image is png
    
    //UInt8 red = data[pixelInfo];         // If you need this info, enable it
    //UInt8 green = data[(pixelInfo + 1)]; // If you need this info, enable it
    //UInt8 blue = data[pixelInfo + 2];    // If you need this info, enable it
    UInt8 alpha = _data3[pixelInfo + 3];     // I need only this info for my maze game
    
    //UIColor* color = [UIColor colorWithRed:red/255.0f green:green/255.0f blue:blue/255.0f alpha:alpha/255.0f]; // The pixel color info
    
    if (alpha == 255) return true;
    else return false;
    
}
-(BOOL)isCollision:(int) x y:(int)y image1:(UIImageView *)image1 image2:(UIImageView *)image2{
    if (([self isWallPixel1:image1.image xCoordinate:(x-image1.frame.origin.x) yCoordinate:(y-image1.frame.origin.y)])&&([self isWallPixel2:image2.image xCoordinate:(x-image2.frame.origin.x) yCoordinate:(y-image2.frame.origin.y)])) {
        return true;
    }
    return false;
}
-(BOOL)isCollision2:(int) x y:(int)y image1:(UIImageView *)image1 image2:(UIImageView *)image2{
    if (([self isWallPixel2:image1.image xCoordinate:(x-image1.frame.origin.x) yCoordinate:(y-image1.frame.origin.y)])&&([self isWallPixel3:image2.image xCoordinate:(x-image2.frame.origin.x) yCoordinate:(y-image2.frame.origin.y)])) {
        return true;
    }
    return false;
}
@end
