#import "NavigationViewController.h"

@interface NavigationViewController ()

@end

@implementation NavigationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)redButtonClicked:(id)sender {
    [self.delegate didSelectViewWithName:@"RedView"];
}

- (IBAction)greenButtonClicked:(id)sender {
    [self.delegate didSelectViewWithName:@"GreenView"];
}

- (IBAction)blueButtonClicked:(id)sender {
    [self.delegate didSelectViewWithName:@"BlueView"];
}
@end
