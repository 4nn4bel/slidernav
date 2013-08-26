#import "PanelDelegate.h"

@interface NavigationViewController : UIViewController

@property (nonatomic, assign) id<PanelDelegate> delegate;

- (IBAction)redButtonClicked:(id)sender;
- (IBAction)greenButtonClicked:(id)sender;
- (IBAction)blueButtonClicked:(id)sender;

@end
