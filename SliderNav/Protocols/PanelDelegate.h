@protocol PanelDelegate <NSObject>

@required
// A child panel calls these methods in its delegate when the nav button is clicked
// Which one is called depends on the tag of the navButton, which toggles each time
// it's tapped.
- (void)movePanelRight;
- (void)movePanelToOriginalPosition;

// NavigationViewController calls this method in its delegate when one of the
// coloured buttons is tapped.
- (void)didSelectViewWithName:(NSString *)viewName;

@end
