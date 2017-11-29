//
//  AreaDetailViewController.swift
//  显示地区详情时的控制器
//  fansarea
//
//  Created by edward.gao on 29/11/2017.
//  Copyright © 2017 edward.gao. All rights reserved.
//

import UIKit

class AreaDetailViewController: UIViewController {

    // 当前详情页所展示的地区图片的名称
    var currentAreaImageName = ""
    
    // image view 的 几种常见的显示方式:
    // 在storyboard中设置: Scale to Fill 拉伸; Aspect to fit: 居中; Aspect Fill 平铺
    
    @IBOutlet weak var detailImgView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // 详情页面载入完毕 设置对应的图片路径
        detailImgView.image = UIImage(named: currentAreaImageName)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation


    

}
