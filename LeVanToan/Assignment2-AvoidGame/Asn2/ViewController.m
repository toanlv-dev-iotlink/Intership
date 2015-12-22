//
//  ViewController.m
//  Asn2
//
//  Created by Z on 12/22/15.
//  Copyright (c) 2015 Z. All rights reserved.
//

#import "ViewController.h"
#import "GameOverViewController.h"

@interface ViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *player;
@property (strong, nonatomic) NSMutableArray *enemies;
@property CADisplayLink *displayLink;
@property int score;
@property (weak, nonatomic) IBOutlet UILabel *scoreLb;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _score = 0;
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"space1.png"]];
    _enemies = [[NSMutableArray alloc] init];
    _player = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-25, self.view.frame.size.height-80, 50, 80)];
    _player.image = [UIImage imageNamed:@"player.png"];
    [self.view addSubview:_player];
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(movePlayer:)];

    [self.view addGestureRecognizer:pan];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (void)viewDidAppear:(BOOL)animated{
    [self start];
}
- (IBAction)movePlayer:(id)sender {
    UIPanGestureRecognizer *pan = (UIPanGestureRecognizer *)sender;
        CGRect newFrame = self.player.frame;
        CGPoint point = [pan locationInView:self.player.superview];
        newFrame.origin.x = point.x-self.player.frame.size.width/2;
        self.player.frame = newFrame;
    for (int i = 0; i < _enemies.count; i++) {
        UIImageView *temp = (UIImageView *)[_enemies objectAtIndex:i];
//        if (aCollisionB(self.player, temp)) {
//            [self stop];
//            GameOverViewController *new = [[GameOverViewController alloc] init];
//            [self.navigationController pushViewController:new animated:true];
//            break;
//        }
    }
}
-(void)start{
    CADisplayLink *dl = [CADisplayLink displayLinkWithTarget:self selector:@selector(timerCallBack:)];
    dl.frameInterval = 0.04;
    [dl addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    self.displayLink = dl;
}
-(void)timerCallBack:(CADisplayLink *)sender{
    [self move];
    [self create];
    [self removeAndScore];
}
-(void)create{
    int xRandom =  arc4random_uniform(self.view.frame.size.width-64);
    UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(xRandom, 0, 40, 40)];
    int check = rand() % 50;
    if ((check == 1)&&(_enemies.count < 20)) {
        [self.enemies addObject:iv];
        iv.image = [UIImage imageNamed:@"smiley2.png"];
        [self.view addSubview:iv];
    }
}
-(void)move{
    if (_enemies.count) {
        for (int i = 0; i<_enemies.count; i++) {
            UIImageView *temp = (UIImageView *)[_enemies objectAtIndex:i];
            CGRect newFrame = temp.frame;
            newFrame.origin.y+=5;
            temp.frame = newFrame;
            if (aCollisionB(self.player, temp)) {
                [self stop];
                GameOverViewController *new = [[GameOverViewController alloc] init];
                [self.navigationController pushViewController:new animated:true];
                break;
            }
        }
    }
}
-(void)removeAndScore{
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
    if ((p.x > b.frame.origin.x)&&(p.x < (b.frame.origin.x+b.frame.size.width))&&(p.y > b.frame.origin.y)&&(p.y < (b.frame.origin.y+b.frame.size.height))) {
        return true;
    }
    return false;
}
-(void)stop{
    [self.displayLink removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
}
@end
