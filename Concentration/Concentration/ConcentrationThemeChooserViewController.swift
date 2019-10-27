//
//  ConcentrationThemeChooserViewController.swift
//  Concentration
//
//  Created by Seokhwan Moon on 27/10/2019.
//  Copyright © 2019 Parannarae. All rights reserved.
//

import UIKit

// make it UISplitViewControllerDelegate to make a delegate on the split view controller
class ConcentrationThemeChooserViewController: UIViewController, UISplitViewControllerDelegate {

    let themes = [
        "Sports": "⚽️🏀🏈⚾️🎾🏐🏉🎱🏓⛷🎳⛳️",
        "Animals": "🐶🐔🦊🐼🦀🐪🐓🐋🐙🦄🐵",
        "Faces": "😀😂😎😫😰😴🙄🤔😘😷",
    ]
    
    // create a delegate on the split view to make iPhone to show the theme chooser page at the beginning (it does not on default since iPhone cannot show the split view)
    override func awakeFromNib() {
        splitViewController?.delegate = self
    }
    
    // collapse the detail on the master view
    // watch out for the return value!!!
    func splitViewController(
        _ splitViewController: UISplitViewController,
        collapseSecondary secondaryViewController: UIViewController,
        onto primaryViewController: UIViewController
    ) -> Bool {
        if let cvc = secondaryViewController as? ConcentrationViewController {
            if cvc.theme == nil {
                // tell the system that it is already collapsed
                //  - since we don't want to show detail view yet (when the app initialized) thus do not make the system to collapse the detail view on top of the main view
                return true
            }
        }
        
        // tell the system to collapse since we want to show the detail view
        return false
    }
    
    // make a segue way from code
    // it can be used for a conditional segue way
    @IBAction func changeTheme(_ sender: Any) {
        // segue will create a new MVC, thus if we don't want to destroy previous MVC but communicate with it, we need to used a code style segue way
        if let cvc = splitViewDetailConcentrationViewController {
            // work with the split view (iPad)
            if let themeName = (sender as? UIButton)?.currentTitle, let theme = themes[themeName] {
                // do not create a new MVC
                cvc.theme = theme
            }
        } else if let cvc = lastSeguedToConcentrationViewController {
            // work with the naviagtion view (iPhone)
            if let themeName = (sender as? UIButton)?.currentTitle, let theme = themes[themeName] {
                // do not create a new MVC
                cvc.theme = theme
            }
            navigationController?.pushViewController(cvc, animated: true)
        } else {
            // create a new MVC
            performSegue(withIdentifier: "Choose Theme", sender: sender)
        }
    }
    
    private var splitViewDetailConcentrationViewController: ConcentrationViewController? {
        // last means the detail in the split view controller
        // it only works on ipad (since iPhone cannot have a split view)
        return splitViewController?.viewControllers.last as? ConcentrationViewController
    }
    
    // MARK: - Navigation
    // a variable to hold the last MVC (thus leave on the heap)
    private var lastSeguedToConcentrationViewController: ConcentrationViewController?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // a identifier name is set in the inspector
        if segue.identifier == "Choose Theme" {
            if let themeName = (sender as? UIButton)?.currentTitle, let theme = themes[themeName] {
                if let cvc = segue.destination as? ConcentrationViewController {
                    cvc.theme = theme
                    lastSeguedToConcentrationViewController = cvc // leave a strong pointer to retain previous MVC
                }
            }
        }
    }
    

}
