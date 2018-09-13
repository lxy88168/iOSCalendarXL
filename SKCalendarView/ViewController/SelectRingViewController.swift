//
//  SelectRingViewController.swift
//  SKCalendarView
//
//  Created by 李彪 on 2018/9/12.
//  Copyright © 2018年 shevchenko. All rights reserved.
//

import UIKit

class SelectRingViewController: UITableViewController, UIDocumentPickerDelegate, AudioRecorderViewControllerDelegate {
    var audioRecorderController: AudioRecorderViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 1
//    }

//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let picker = UIDocumentPickerViewController(documentTypes: ["public.mp3 (kUTTypeMP3)", "com.microsoft.waveform-​audio", "public.audio (kUTTypeAudio)", ], in: UIDocumentPickerMode.open)
            picker.delegate = self
            if #available(iOS 11.0, *) {
                picker.allowsMultipleSelection = true
            } else {
                // Fallback on earlier versions
            }
            self.present(picker, animated: true, completion: nil)
        } else if indexPath.row == 1 {
            audioRecorderController = AudioRecorderViewController()
            audioRecorderController?.audioRecorderDelegate = self
            self.present(audioRecorderController!, animated: true, completion: nil)
        }
    }

    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        urls.forEach({(url) in
            print(url)
        })
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        print(url)
        
    }
    
    func audioRecorderViewControllerDismissed(withFileURL fileURL: NSURL?) {
        if fileURL != nil {
            let filePath = RemindViewController.documentsDirectory().appendingFormat("/ring\(Date().timeIntervalSince1970).m4a")
            do {
                let data = try NSData(contentsOf: fileURL! as URL, options: NSData.ReadingOptions.mappedIfSafe)
                FileManager.default.createFile(atPath: filePath, contents: data as Data, attributes: nil)
            } catch let error as NSError {
                print("save audio occurred error. \(error)")
            }
        }
        audioRecorderController?.dismiss(animated: true, completion: nil)
    }
}
