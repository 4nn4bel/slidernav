#import "MainViewController.h"
#import "GreenViewController.h"
#import "BlueViewController.h"
#import "RedViewController.h"
#import "NavigationViewController.h"
#import "PanelDelegate.h"
#import <QuartzCore/QuartzCore.h>

#define CORNER_RADIUS 4
#define SLIDE_TIMING .25
#define PANEL_WIDTH 60

@interface MainViewController () <PanelDelegate, UIGestureRecognizerDelegate> {
    // This view controller doesn't have a UI.
    // activeViewController.view is what the user sees
    UIViewController *activeViewController;
}

@property (nonatomic, strong) GreenViewController *greenViewController;
@property (nonatomic, strong) BlueViewController *blueViewController;
@property (nonatomic, strong) RedViewController *redViewController;
@property (nonatomic, strong) NavigationViewController *navigationViewController;
@property (nonatomic, assign) BOOL showPanel;
@property (nonatomic, assign) BOOL panelMovedRight;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
}

#pragma mark -
#pragma mark Custom view methods

- (void)setupView {
    // When the app is launched we'll start by showing the red view
    _redViewController = [[RedViewController alloc] initWithNibName:@"RedView" bundle:nil];
    _redViewController.delegate = self;
    [self.view addSubview:_redViewController.view];
    [self addChildViewController:_redViewController];
    [_redViewController didMoveToParentViewController:self];
    activeViewController = _redViewController;
    
    // Get ready for swipes
    [self setupGestures];
}

- (void)resetMainView {
    if (_navigationViewController != nil) {
        [_navigationViewController.view removeFromSuperview];
        _navigationViewController = nil;
    }
    
    [self showActiveViewWithShadow:NO withOffset:0];
}

// This is where the NavigationViewController eventually ends up via its delegate
- (void)showActiveViewWithName:(NSString *)viewName {
    if ([viewName isEqualToString:@"GreenView"]) {
        _greenViewController = [[GreenViewController alloc] initWithNibName:viewName bundle:nil];
        _greenViewController.delegate = self;
        activeViewController = _greenViewController;
    }
    else if ([viewName isEqualToString:@"BlueView"]) {
        _blueViewController = [[BlueViewController alloc] initWithNibName:viewName bundle:nil];
        _blueViewController.delegate = self;
        activeViewController = _blueViewController;
    }
    else if ([viewName isEqualToString:@"RedView"]) {
        _redViewController = [[RedViewController alloc] initWithNibName:viewName bundle:nil];
        _redViewController.delegate = self;
        activeViewController = _redViewController;
    }
    
    activeViewController.view.frame = CGRectMake(self.view.frame.size.width - PANEL_WIDTH, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    [self.view addSubview:activeViewController.view];
    [self addChildViewController:activeViewController];
    
    [activeViewController didMoveToParentViewController:self];
    
    [self showActiveViewWithShadow:YES withOffset:-2];
}

- (void)showActiveViewWithShadow:(BOOL)value withOffset:(double)offset {
    if (value) {
        [activeViewController.view.layer setCornerRadius:CORNER_RADIUS];
        [activeViewController.view.layer setShadowColor:[UIColor blackColor].CGColor];
        [activeViewController.view.layer setShadowOpacity:0.8];
        [activeViewController.view.layer setShadowOffset:CGSizeMake(offset, offset)];
    }
    else {
        [activeViewController.view.layer setCornerRadius:0.0f];
        [activeViewController.view.layer setShadowOffset:CGSizeMake(offset, offset)];
    }
}

- (UIView *)getNavigationView {
    if (_navigationViewController == nil) {
        _navigationViewController = [[NavigationViewController alloc] initWithNibName:@"NavigationView" bundle:nil];
        _navigationViewController.delegate = self;
        [self.view addSubview:_navigationViewController.view];
        [self addChildViewController:_navigationViewController];
        [_navigationViewController didMoveToParentViewController:self];
        _navigationViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    }
    
    [self showActiveViewWithShadow:YES withOffset:-2];
    
    return _navigationViewController.view;
}

-(void)setupGestures {
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(movePanel:)];
    [panRecognizer setMinimumNumberOfTouches:1];
    [panRecognizer setMaximumNumberOfTouches:1];
    [panRecognizer setDelegate:self];
    
    [self.view addGestureRecognizer:panRecognizer];
}

#pragma mark -
#pragma mark PanelDelegate methods

// Called by a view when its navButton is clicked and the panel is occupying the entire screen
- (void)movePanelRight {
    UIView *childView = [self getNavigationView];
    [self.view sendSubviewToBack:childView];
    
    [UIView animateWithDuration:SLIDE_TIMING delay:0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         activeViewController.view.frame = CGRectMake(self.view.frame.size.width - PANEL_WIDTH, 0, self.view.frame.size.width, self.view.frame.size.height);
                     }
                     completion:^(BOOL finished) {
                         if (finished) {
                         }
                     }];
}

// Called by a view when its navButton is clicked and the panel has already been moved to the right
- (void)movePanelToOriginalPosition {
    [UIView animateWithDuration:SLIDE_TIMING delay:0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         activeViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
                     }
                     completion:^(BOOL finished) {
                         if (finished) {
                             [self resetMainView];
                         }
                     }];
}

// Called by NavigationViewController when one of the coloured buttons is tapped
- (void)didSelectViewWithName:(NSString *)viewName {
    if (activeViewController != nil) {
        [activeViewController.view removeFromSuperview];
        activeViewController = nil;
    }
    [self showActiveViewWithName:viewName];
    [self movePanelToOriginalPosition];
}

#pragma mark -
#pragma mark UIGestureRecognizerDelegate methods

// This is where we can slide the active panel from left to right and back again,
// endlessly, for great fun!
-(void)movePanel:(id)sender {
    [[[(UITapGestureRecognizer*)sender view] layer] removeAllAnimations];
    
    CGPoint translatedPoint = [(UIPanGestureRecognizer*)sender translationInView:self.view];
    CGPoint velocity = [(UIPanGestureRecognizer*)sender velocityInView:[sender view]];
    
    // Stop the main panel from being dragged to the left if it's not already dragged to the right
    if ((velocity.x < 0) && (activeViewController.view.frame.origin.x == 0)) {
        return;
    }
    
    if ([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan) {
        if(velocity.x > 0) {
            _showPanel = YES;
        }
        else {
            _showPanel = NO;
        }
        
        UIView *childView = [self getNavigationView];
        [self.view sendSubviewToBack:childView];
    }
    
    if ([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateEnded) {
        // If we stopped dragging the panel somewhere between the left and right
        // edges of the screen, these will animate it to its final position.
        if (!_showPanel) {
            [self movePanelToOriginalPosition];
            _panelMovedRight = NO;
        } else {
            [self movePanelRight];
            _panelMovedRight = YES;
        }
    }
    
    if ([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateChanged) {
        if(velocity.x > 0) {
            _showPanel = YES;
        }
        else {
            _showPanel = NO;
        }
        
        // Set the new x coord of the active panel...
        activeViewController.view.center = CGPointMake(activeViewController.view.center.x + translatedPoint.x, activeViewController.view.center.y);
        
        // ...and move it there
        [(UIPanGestureRecognizer*)sender setTranslation:CGPointMake(0, 0) inView:self.view];
    }
}

@end
