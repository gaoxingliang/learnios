//
//  AreaTableViewController.swift
//  fansarea
//
//  Created by edward.gao on 27/11/2017.
//  Copyright © 2017 edward.gao. All rights reserved.
//

import UIKit

class AreaTableViewController: UITableViewController {

    // use static 来保证已经被初始化了
    static var areas = ["成都", "洪湖市", "仙桃市北区", "云阳县凤鸣镇", "云阳县盘石镇", "洪湖市沙口镇", "贺龙中学", "SanatabAraba", "成都武侯区", "A3", "A4", "B3", "b4", "6666", "777", "10001", "10086", "1008611"];
    var pics = ["baiyun", "chengxi", "furong", "jinping", "nangang", "qilihe", "shangjie", "wuhou", "xining", "xinzhuang", "yaodu", "youxi"]
    var provinces = ["四川", "湖北", "湖北", "重庆", "重庆", "重庆", "湖北", "海南"]
    
    var visited = [Bool](repeatElement(false, count: areas.count))
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view delegate
    // 当行被选中的时候调用的
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("you clicked section:", indexPath.section, " row:" , indexPath.row )
        
        // .alert 从中间弹出 适合于只有1-2个选项的时候
        // .actionsheet 从底部弹出 适合有多个选项(>=3)
//        let menu = UIAlertController(title: "交互菜单",
//                                     message: "你点击了\(indexPath.row)行", preferredStyle: .alert)
//        let option1 = UIAlertAction(title :"OK", style: .default, handler: nil)
//        menu.addAction(option1)
        // 不同的按钮style 呈现了不同的效果
        //let option2 = UIAlertAction(title :"CaNCel", style: .cancel, handler: nil)
        //let option3 = UIAlertAction(title :"delete", style: .destructive, handler: nil)
        //menu.addAction(option2)
        //menu.addAction(option3)
        
        
        // .actionSheet
        let menu = UIAlertController(title: "同学你好", message: "你点击了\(indexPath.row) 行", preferredStyle: .actionSheet)
        let option1 = UIAlertAction(title: "ok", style: .default, handler:nil);

        let option2 = UIAlertAction(title: "我去过了", style: .destructive) { (UIAlertAction) in
            let cell = tableView.cellForRow(at: indexPath)
            cell?.accessoryType = .checkmark
            self.visited[indexPath.row] = true;
            //cell?.accessoryType = .detailButton
        }
        menu.addAction(option1)
        menu.addAction(option2);
        
        self.present(menu, animated: true, completion: nil)
        // 清除对应行的选中状态
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1;
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return AreaTableViewController.areas.count;
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // as! -> 强制转换, 失败app崩溃
        // as? -> 非强制转换, 失败不崩溃
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdCell", for: indexPath) as! TableViewCell
        cell.thumbnail.image = UIImage(named: pics[indexPath.row%pics.count])
        cell.nameLabel.text = AreaTableViewController.areas[indexPath.row]
        cell.partLabel.text = pics[indexPath.row%pics.count]
        cell.provinceLable.text = provinces[indexPath.row%provinces.count]
        
        // 变成圆角
        cell.thumbnail.layer.cornerRadius = cell.thumbnail.frame.size.width/2
        // 使裁剪生效
        cell.thumbnail.clipsToBounds = true

        // 重新根据是否被选中了来设置cell的选中状态
//        if visited[indexPath.row] {
//            cell.accessoryType = .checkmark
//        }
//        else {
//            cell.accessoryType = .none
//        }
        cell.accessoryType = visited[indexPath.row] ? .checkmark : .none
        
        // Configure the cell...
        //cell.textLabel?.text = areas[indexPath.row]
        //cell.imageView?.image = UIImage(named: pics[indexPath.row%pics.count])
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
