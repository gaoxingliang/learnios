//
//  ViewController.swift
//  UITableViewTest
//
//  Created by edward.gao on 22/11/2017.
//  Copyright © 2017 edward.gao. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @available(iOS 2.0, *)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return areas.count
    }


    var areas = ["成都", "洪湖市", "仙桃市北区", "云阳县凤鸣镇", "云阳县盘石镇", "洪湖市沙口镇", "贺龙中学", "SanatabAraba", "成都武侯区", "A3", "A4", "B3", "b4", "6666", "777", "10001", "10086", "1008611"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return areas.count
//    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // see the storybord for this cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = areas[indexPath.row]
        cell.imageView?.image = UIImage(named: "xining")
        //cell.imageView?.image = #imageLiteral(resourceName: "xining")
        return cell
        
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

