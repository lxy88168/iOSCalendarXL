//
//  ThemeViewController.swift
//  SKCalendarView
//
//  Created by 李彪 on 2018/9/11.
//  Copyright © 2018年 shevchenko. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"
private let userDefaults = UserDefaults.standard
private let themes : [ThemeObject] = [
    ThemeObject(name: "果橙", color: UIColor(red: 1, green: 0.47, blue: 0, alpha: 1)),
    ThemeObject(name: "胭脂", color: UIColor(red: 0.8, green: 0.2, blue: 0.2, alpha: 1)),
    ThemeObject(name: "朱砂", color: UIColor(red: 0.9, green: 0.3, blue: 0.2, alpha: 1)),
    ThemeObject(name: "茜红", color: UIColor(red: 1, green: 0.4, blue: 0.5, alpha: 1)),
    ThemeObject(name: "它粉", color: UIColor(red: 1, green: 0.6, blue: 0.8, alpha: 1)),
    ThemeObject(name: "天蓝", color: UIColor(red: 0.4, green: 0.7, blue: 1, alpha: 1)),
    ThemeObject(name: "碧蓝", color: UIColor(red: 0.3, green: 0.8, blue: 0.8, alpha: 1)),
    ThemeObject(name: "太蓝", color: UIColor(red: 0.3, green: 0.4, blue: 0.8, alpha: 1)),
    ThemeObject(name: "莓紫", color: UIColor(red: 0.5, green: 0.4, blue: 0.8, alpha: 1)),
    ThemeObject(name: "竹青", color: UIColor(red: 0.1, green: 0.7, blue: 0.4, alpha: 1)),
    ThemeObject(name: "柳青", color: UIColor(red: 0.5, green: 0.8, blue: 0.1, alpha: 1)),
    ThemeObject(name: "墨青", color: UIColor(red: 0.3, green: 0.3, blue: 0.4, alpha: 1))
]

class ThemeViewController: UICollectionViewController {
    
    var currentTheme = themes[0]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
//        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        let nib = UINib(nibName: "ThemeCollectionViewCell", bundle: nil)
        self.collectionView!.register(nib, forCellWithReuseIdentifier: reuseIdentifier)
        
        let themeName = userDefaults.string(forKey: "theme") ?? "果橙"
        themes.forEach({(theme) in
            if themeName == theme.name {
                currentTheme = theme
                return
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return themes.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let theme = themes[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ThemeCollectionViewCell
    
        cell.backgroundColor = theme.color
        cell.labelThemeName.text = theme.name
        
        if (currentTheme == theme) {
            cell.isSelected = true
        } else {
            cell.isSelected = false
        }
    
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        currentTheme = themes[indexPath.row]
        //change theme
        userDefaults.set(currentTheme.name, forKey: "theme")
        collectionView.reloadData()
        
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
