#import "PanelDelegate.h"

@interface BlueViewController : UIViewController

@property (nonatomic, assign) id<PanelDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *navButton;

- (IBAction)navButtonClicked:(id)sender;

@end
