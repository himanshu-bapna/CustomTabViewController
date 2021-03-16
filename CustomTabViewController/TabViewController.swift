//
//  TabViewController.swift
//  CustomTabViewController
//
//  Created by Himanshu Bapna on 16/03/21.
//

import UIKit

class TabViewController: UIViewController {

    var selectedIndex: Int = 0
    var previousIndex: Int = 0
    
    var viewControllers = [UIViewController]()
    
    @IBOutlet var tabButtons:[UIButton]!
    @IBOutlet var tabView:UIView!
    @IBOutlet weak var tabBarHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tabBarBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var tabBarWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var stackBottomConstraint: NSLayoutConstraint!
    
    private let floatTabBarIcons = ["tabicon_home.png", "tabicon_search.png", "tabicon_bookings.png", "tabicon_me.png"]
    private let whiteTabBarIcons = ["whitetabicon_home.png", "whitetabicon_search.png", "whitetabicon_bookings.png", "whitetabicon_me.png"]
    private let whiteSelectedTabBarIcons = ["", "whitetabicon_search_selected.png", "whitetabicon_bookings_selected.png", "whitetabicon_me_selected.png"]
    
    static let homeVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeViewController")
    static let searchVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SearchViewController")
    static let bookVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BookViewController")
    static let profileVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProfileViewController")

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewControllers.append(TabViewController.homeVC)
        viewControllers.append(TabViewController.searchVC)
        viewControllers.append(TabViewController.bookVC)
        viewControllers.append(TabViewController.profileVC)
        
        configureTabBar()
    }
    
    func configureTabBar() {
        tabButtons[selectedIndex].isSelected = true
        tabChanged(sender: tabButtons[selectedIndex])
    }
    
    func updateTabbar(index: Int) {
        if index == 0{
            //float tab bar
            let backgroundColor = UIColor(red: 1, green: 0.663, blue: 0.431, alpha: 0.96)
            setTabViewLayout(backgroundColor: backgroundColor, cornerRadius: 25, widthConstraint: 351, heightConstraint: 52, bottomConstraint: 28, stackBottomConstraint: 4)
            
            setInitialTabButtonImages(floatTabBarIcons, alpha: 0.7)
            
        } else {
            //white tab bar
            tabView.clipsToBounds = false
            tabView.layer.shadowPath = UIBezierPath(roundedRect: tabView.bounds, cornerRadius: 0).cgPath
            tabView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.24).cgColor
            tabView.layer.shadowOpacity = 1
            tabView.layer.shadowRadius = 30
            tabView.layer.shadowOffset = CGSize(width: 0, height: 12)
            tabView.layer.bounds = tabView.bounds
            tabView.layer.position = tabView.center
            
            let backgroundColor = UIColor(red: 1, green: 0.998, blue: 0.99, alpha: 0.9)
            setTabViewLayout(backgroundColor: backgroundColor, cornerRadius: 0, widthConstraint: view.frame.width, heightConstraint: 80, bottomConstraint: 0, stackBottomConstraint: 32)
            
            setInitialTabButtonImages(whiteTabBarIcons, alpha: 0.4)
            tabButtons[index].setImage(UIImage(named: whiteSelectedTabBarIcons[index]), for: .normal)
        }
        tabButtons[index].alpha = 1.0
    }
    
    func setInitialTabButtonImages(_ images: [String], alpha: CGFloat){
        //total tab bar items are 4
        for i in 0..<tabButtons.count {
            tabButtons[i].setImage(UIImage(named: images[i]), for: .normal)
            tabButtons[i].alpha = alpha
        }
    }
    
    func setTabViewLayout(backgroundColor color:UIColor, cornerRadius:CGFloat, widthConstraint: CGFloat, heightConstraint: CGFloat, bottomConstraint: CGFloat, stackBottomConstraint: CGFloat){
        tabView.backgroundColor = color
        tabView.layer.cornerRadius = cornerRadius
        
        tabBarWidthConstraint.constant = widthConstraint
        tabBarHeightConstraint.constant = heightConstraint
        tabBarBottomConstraint.constant = bottomConstraint
        self.stackBottomConstraint.constant = stackBottomConstraint
    }
    
    @IBAction func tabChanged(sender:UIButton) {
        previousIndex = selectedIndex
        selectedIndex = sender.tag
        
        updateTabbar(index: selectedIndex)
        
        tabButtons[previousIndex].isSelected = false
        let previousVC = self.viewControllers[previousIndex]
        
        previousVC.willMove(toParent: nil)
        previousVC.view.removeFromSuperview()
        previousVC.removeFromParent()
        
        sender.isSelected = true
        
        let vc = self.viewControllers[selectedIndex]
        vc.view.frame = self.view.frame //UIApplication.shared.windows[0].frame
        vc.didMove(toParent: self)
        self.addChild(vc)
        self.view.addSubview(vc.view)
        
        self.view.bringSubviewToFront(tabView)
    }
}

