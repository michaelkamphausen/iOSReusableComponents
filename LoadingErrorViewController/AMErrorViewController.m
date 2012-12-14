//
//  AMErrorViewController.m
//  appic
//
//  Created by Michael Kamphausen on 24.10.12.
//  Copyright (c) 2012 Digital Pioneers N.V. All rights reserved.
//

#import "AMErrorViewController.h"

@interface AMErrorViewController ()

@end

@implementation AMErrorViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [_reloadButton setupDefault];
    defaultDescription = _descriptionLabel.text;
}

- (IBAction)reload:(id)sender
{
    [self.delegate reloadAfterError:sender];
}

- (void)setDefaultDescription
{
    _descriptionLabel.text = defaultDescription;
}

@end
