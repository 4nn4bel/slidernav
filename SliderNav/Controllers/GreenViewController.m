#import "GreenViewController.h"

@interface GreenViewController ()

@end

@implementation GreenViewController

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

// navButton tag = 1 when created in Interface Builder
- (IBAction)navButtonClicked:(id)sender {
    UIButton *button = sender;
    switch (button.tag) {
        case 0: {
            self.navButton.tag = 1;
            [_delegate movePanelToOriginalPosition];
            break;
        }
            
        case 1: {
            self.navButton.tag = 0;
            [_delegate movePanelRight];
            break;
        }
            
        default:
            break;
    }
}

@end
