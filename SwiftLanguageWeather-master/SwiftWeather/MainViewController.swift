//
//  MainViewController.swift
//  SwiftWeather
//
//  Created by edward.gao on 11/12/2017.
//  Copyright © 2017 Jake Lin. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var weatherImgView: UIImageView!
    
    @IBOutlet weak var musicPlayerImgView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        // Do any additional setup after loading the view.
        let tapGesture=UITapGestureRecognizer(target: self, action: #selector(MainViewController.weatherTapped(_:)))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        self.weatherImgView.addGestureRecognizer(tapGesture)
        self.weatherImgView.isUserInteractionEnabled = true
        
        
        
        let tapGestureForMusic=UITapGestureRecognizer(target: self, action: #selector(MainViewController.musicTapped(_:)))
        tapGestureForMusic.numberOfTapsRequired = 1
        tapGestureForMusic.numberOfTouchesRequired = 1
        self.musicPlayerImgView.addGestureRecognizer(tapGestureForMusic)
        self.musicPlayerImgView.isUserInteractionEnabled = true
        
    }
    
    
    @objc func musicTapped(_ sender: UITapGestureRecognizer) {
        self.performSegue(withIdentifier: "main2Music", sender: sender)
    }
    
    @objc func weatherTapped(_ sender: UITapGestureRecognizer) {
        self.performSegue(withIdentifier: "main2Weather", sender: sender)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
