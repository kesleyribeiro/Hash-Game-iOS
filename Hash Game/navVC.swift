//
//  navVC.swift
//  List of tasks
//
//  Created by Kesley Ribeiro on 30/Mar/17.
//  Copyright © 2017 Kesley Ribeiro. All rights reserved.
//

import UIKit

class navVC: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Title color of Nav. Bar
        self.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]

        // Button color of Nav. Bar
        self.navigationBar.tintColor = .white

        // Background color of Nav. Bar
        self.navigationBar.barTintColor = color

        // Nav. Bar isn't translucent
        self.navigationBar.isTranslucent = false
    }
    
    // Status bar white color
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
}
