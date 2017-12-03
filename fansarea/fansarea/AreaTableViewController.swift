//
//  AreaTableViewController.swift
//  fansarea
//
/**
 转场类型: show 最常见的, 提供顶部有一个返回到上一级的按钮
 show detail: 与show类似 替换原视图 而且没有返回按钮了
 present modally: 从底部往上弹出, 用于连贯性不强的视图
 present as poper: 弹出菜单的效果
 */


//  Created by edward.gao on 27/11/2017.
//  Copyright © 2017 edward.gao. All rights reserved.
//

import UIKit

class AreaTableViewController: UITableViewController {
    
    var areasObjArr = [
        Area(name:"萃庄镇", province: "上海",part:"华东M", isVistied: false, image: "xinzhuang"),
        Area(name:"兰州七里河区",province: "甘肃",part:"西北",isVistied: false, image: "qilihe"),
        Area(name:"三明市尤溪县",province:"福建",part: "东南", isVistied: false, image: "youxi"),
        Area(name:"西宁城西区",province:"青海",part:"西北",isVistied: false, image: "chengxi"),
        Area(name:"广州白云区",province: "T1古",part: "华南",isVistied: false, image: "baiyun"),
        Area(name:"闽if吴县上街镇",province:"上海", part: "_东由M",isVistied: false, image: "shangjie"),
        Area(name:"哈尔滨市南岗区",province:"黑龙江",part:"东北",isVistied: false, image: "nangang"),
        Area(name:"临汾市壳都区",province:"山西M", part:"华北",isVistied: false, image: "yaodu"),
        Area(name:"成都武i吴区",province:"四川",part:"西南",isVistied: false, image: "wuhou"),
        Area(name:"汕头市釜平区", province:"广余",part:"华由",isVistied: false, image: "jinping"),
        Area(name:"长沙市芙蓉区",province:"湖南",part:"华中",isVistied: false, image: "furong")
    ];
    
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
    // 当有了场景后, 注释掉这里来避免在子场景中弹出 Presenting view controllers on detached view controllers is discouraged
    //    // 当行被选中的时候调用的
    //    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //        print("you clicked section:", indexPath.section, " row:" , indexPath.row )
    //
    //        // .alert 从中间弹出 适合于只有1-2个选项的时候
    //        // .actionsheet 从底部弹出 适合有多个选项(>=3)
    ////        let menu = UIAlertController(title: "交互菜单",
    ////                                     message: "你点击了\(indexPath.row)行", preferredStyle: .alert)
    ////        let option1 = UIAlertAction(title :"OK", style: .default, handler: nil)
    ////        menu.addAction(option1)
    //        // 不同的按钮style 呈现了不同的效果
    //        //let option2 = UIAlertAction(title :"CaNCel", style: .cancel, handler: nil)
    //        //let option3 = UIAlertAction(title :"delete", style: .destructive, handler: nil)
    //        //menu.addAction(option2)
    //        //menu.addAction(option3)
    //
    //
    //        // .actionSheet
    //        let menu = UIAlertController(title: "同学你好", message: "你点击了\(indexPath.row) 行", preferredStyle: .actionSheet)
    //        let option1 = UIAlertAction(title: "ok", style: .default, handler:nil);
    //
    //        let option2 = UIAlertAction(title: "我去过了", style: .destructive) { (UIAlertAction) in
    //            let cell = tableView.cellForRow(at: indexPath) as! TableViewCell
    //            //cell?.accessoryType = .checkmark
    //            cell.favImg.isHidden = false
    //            self.visited[indexPath.row] = true;
    //            //cell?.accessoryType = .detailButton
    //        }
    //        menu.addAction(option1)
    //        menu.addAction(option2);
    //
    //        self.present(menu, animated: true, completion: nil)
    //        // 清除对应行的选中状态
    //        tableView.deselectRow(at: indexPath, animated: true)
    //    }
    
    // MARK: - Table view data source
    
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1;
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return areasObjArr.count;
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // as! -> 强制转换, 失败app崩溃
        // as? -> 非强制转换, 失败不崩溃
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdCell", for: indexPath) as! TableViewCell
        cell.thumbnail.image = UIImage(named: areasObjArr[indexPath.row].image)
        cell.nameLabel.text = areasObjArr[indexPath.row].name
        cell.partLabel.text = areasObjArr[indexPath.row].part
        cell.provinceLable.text = areasObjArr[indexPath.row].province
        
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
        
        
        //cell.accessoryType = visited[indexPath.row] ? .checkmark : .none
        if areasObjArr[indexPath.row].isVistied {
            cell.favImg.isHidden = false;
        }
        else {
            cell.favImg.isHidden = true;
        }
        
        // 注册对应的点击事件
        cell.favImg.isUserInteractionEnabled = true
        cell.favImg.tag = indexPath.row
        let tapped:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action:  #selector(AreaTableViewController.TappedOnImage(sender:)))
        tapped.numberOfTapsRequired = 1
        cell.favImg.addGestureRecognizer(tapped)
        
        
        // Configure the cell...
        //cell.textLabel?.text = areas[indexPath.row]
        //cell.imageView?.image = UIImage(named: pics[indexPath.row%pics.count])
        return cell
    }
    
    // 当fav 图片被点击后调用
    @objc func TappedOnImage(sender:UITapGestureRecognizer){
        let index = sender.view!.tag
        areasObjArr[index].isVistied = false;
        let image = sender.view as! UIImageView
        image.isHidden = true
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    // 自定义的右滑菜单
    // 一旦覆盖该方法,系统自带的delete就没有了
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let actionShare = UITableViewRowAction(style: .normal, title: "分享") { (rowAction, indexPath) in
            let actionSheet = UIAlertController(title: "分享到", message: nil, preferredStyle: .actionSheet)
            let qq = UIAlertAction(title: "qq", style: .default, handler: nil)
            let wechat = UIAlertAction(title: "wechat", style: .default, handler: nil)
            let cancel = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
            actionSheet.addAction(qq)
            actionSheet.addAction(wechat)
            actionSheet.addAction(cancel)
            
            self.present(actionSheet, animated: true, completion: nil)
        }
        // 设置按钮颜色
        //actionShare.backgroundColor = UIColor.orange
        actionShare.backgroundColor = UIColor(red: 9/255, green: 113/255, blue: 178/255, alpha: 0.8)
        let actionDel = UITableViewRowAction(style: .destructive, title: "删除") { (rowAction, indexP) in
            // 删除对应行的数据
            // 先删除数据 再删除视图
            self.areasObjArr.remove(at: indexP.row)
          
            //其他数组是随便写的 就先不管了
            
            // debug日志
            print(String(format: "删除一行后还剩多少个区域-%d", self.areasObjArr.count))
            for area in self.areasObjArr {
                // 字符串的格式化是这样的 不是 %s
                print(String(format: "area=%@", area.name))
            }
            
            
            // Delete the row from the data source
            tableView.deleteRows(at: [indexP], with: .fade)
        }
        
        return [actionShare, actionDel]
    }
    
    // 右滑菜单
    // 这个是默认的
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // 删除对应行的数据
            // 先删除数据 再删除视图
            areasObjArr.remove(at: indexPath.row)
            //其他数组是随便写的 就先不管了
            
            // debug日志
            print(String(format: "删除一行后还剩多少个区域-%d", areasObjArr.count))
            for area in areasObjArr {
                // 字符串的格式化是这样的 不是 %s
                print(String(format: "area=%@", area.name))
            }
            
            
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    
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
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        // 判断转场ID
        if segue.identifier == "showAreaDetailSegue" {
            let dest = segue.destination as! AreaDetailViewController
            dest.area = areasObjArr[tableView.indexPathForSelectedRow!.row]
        }
    }
    
}
