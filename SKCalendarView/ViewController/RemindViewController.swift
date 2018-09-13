//
//  RemindViewController.swift
//  SKCalendarView
//
//  Created by 李彪 on 2018/8/24.
//  Copyright © 2018年 武汉思古科技有限公司. All rights reserved.
//

import UIKit

class RemindViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var emptyDataView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    let mediaCellSize = 70
    
    var reminds = [Remind]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        automaticallyAdjustsScrollViewInsets = false
        
//        tableView.register(RemindCell.classForCoder(), forCellReuseIdentifier: "remindCell")
        
        let cellNib = UINib(nibName: "RemindCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "remindCell")

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewDidAppear(_ animated: Bool) {
        reminds.removeAll()
        reminds.append(contentsOf: RemindViewController.getRemindList())
        
        if reminds.count == 0 {
            emptyDataView.isHidden = false
            tableView.isHidden = true
        } else {
            emptyDataView.isHidden = true
            tableView.isHidden = false
        }
        
        tableView.reloadData()
    }
    
    static func getRemindList() -> [Remind] {
        var reminds = [Remind]()
        var filePaths = [String]()
        let dir = RemindViewController.documentsDirectory()
        do {
            let array = try FileManager.default.contentsOfDirectory(atPath: dir)
            
            for fileName in array {
                var isDir: ObjCBool = true
                
                if !fileName.contains(".plist") {
                    continue
                }
                let fullPath = "\(dir)/\(fileName)"
                
                if FileManager.default.fileExists(atPath: fullPath, isDirectory: &isDir) {
                    if !isDir.boolValue {
                        filePaths.append(fullPath)
                    }
                }
            }
        } catch let error as NSError {
            print("get file path error: \(error)")
        }
        
        filePaths.forEach({(path) in
            //声明文件管理器
            let defaultManager = FileManager()
            //通过文件地址判断数据文件是否存在
            if defaultManager.fileExists(atPath: path) {
                //读取文件数据
                let url = URL(fileURLWithPath: path)
                let data = try! Data(contentsOf: url)
                //解码器
                let unarchiver = NSKeyedUnarchiver(forReadingWith: data)
                //通过归档时设置的关键字Checklist还原lists
                let remind = unarchiver.decodeObject(forKey: "remind") as! Remind
                reminds.append(remind)
                //结束解码
                unarchiver.finishDecoding()
            }
        })
        return reminds
    }
    
    //获取沙盒文件夹路径
    static func documentsDirectory()->String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                        .userDomainMask, true)
        let documentsDirectory = paths.first!
        return documentsDirectory
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return reminds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "remindCell", for: indexPath) as! RemindCell
        cell.selectionStyle = .none
        
        let remind = reminds[indexPath.row]
        cell.medias = remind.medias
        cell.labelRemindContent.text = remind.content
        cell.labelLocation.text = remind.location
        let dateFormater = DateFormatter()
        dateFormater.locale = Locale.current
        dateFormater.dateFormat = "yyyy-MM-dd EEEE"
        cell.labelDate.text = dateFormater.string(from: remind.date)
        dateFormater.dateFormat = "hh:mm"
        cell.labelTime.text = dateFormater.string(from: remind.date)
        
        let calendar = Calendar(identifier: .chinese)
        let comp = calendar.dateComponents([.day], from: remind.date, to: Date())
        let days = comp.day!
        if days == 0 {
            cell.labelFriendlyTime.text = "今天"
        } else {
            cell.labelFriendlyTime.text = "距今\(abs(days))天"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        performSegue(withIdentifier: "showRemindDetail", sender: reminds[indexPath.row])
        return indexPath
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("didSelectRowAt: \(indexPath.row)")
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showRemindDetail" {
            let detailController = segue.destination as! RemindDetailViewControllerTableViewController
            detailController.remind = sender as? Remind
        }
    }

}
