//
//  ViewController.swift
//  JMPageMenu
//
//  Created by Junyi1227 on 09/05/2019.
//  Copyright (c) 2019 Junyi1227. All rights reserved.
//

import UIKit
import JMPageMenu

class ViewController: UIViewController {
    @IBOutlet weak var topView: JMTopMenuView!
    @IBOutlet weak var scrollView: UIScrollView!
    private lazy var pageMenuControl = JMPageMenuControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let vc1 = UIViewController()
        vc1.title = "aaa"
        let vc2 = UIViewController()
        vc2.view.backgroundColor = .yellow
        vc2.title = "bbb"
        let vc3 = UIViewController()
        vc3.title = "ccc"
        let vc4 = UIViewController()
        vc4.view.backgroundColor = .yellow
        vc4.title = "ddd"
        let childVCs:[UIViewController] = [vc1,vc2,vc3,vc4]
        
        let configuration = JMMenuConfiguration()
        configuration.menuItemWidthType = .autoWidth
        pageMenuControl.setupPageViewWith(topView: topView, scrollView: scrollView, childVCs: childVCs,pageMenuConfiguration: configuration, baseVC: self, delegate: self)
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


extension ViewController: JMPageMenuControlDelegate {
    func didSelectetPageAt(_ pageIndex: Int) {
        //
    }
}
