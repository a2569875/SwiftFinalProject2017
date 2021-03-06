//
//  SelectMyCharactorChooseController.swift
//  FinalProject00357123
//
//  Created by 張宇帆 on 2018/1/15.
//  Copyright © 2018年 NTOU department of computer science. All rights reserved.
//

import UIKit

class SelectMyCharactorChooseController: UITableViewController {

    var myCharactors = [Charactor]()
    var loadded_setting : GobalSetting!
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        myCharactors.remove(at: indexPath.row)
        Charactor.saveToFile(lovers: myCharactors)
        tableView.reloadData()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.backgroundView?.backgroundColor = self.tableView.backgroundColor
        
        if let lmyCharactors = Charactor.readFromFile() {
            self.myCharactors = lmyCharactors
        }
        
        if let lmySetting = GobalSetting.readFromFile() {
            self.loadded_setting = lmySetting
        }else{
            self.loadded_setting = GobalSetting()
        }

        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(SelectMyCharactorChooseController.refreshData), for: UIControlEvents.valueChanged)
        self.refreshControl = refreshControl
    }

    
    @objc func refreshData() {
        if let lmyCharactors = Charactor.readFromFile() {
            self.myCharactors = lmyCharactors
        }
        
        if let lmySetting = GobalSetting.readFromFile() {
            self.loadded_setting = lmySetting
        }else{
            self.loadded_setting = GobalSetting()
        }
        
         tableView.reloadData()
        refreshControl?.endRefreshing()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return myCharactors.count
    }
//MyCharactorItem
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MyCharactorItem", for: indexPath) as? SelectMyCharactorCell else  {
            assert(false)
        }
        
        // Configure the cell...
        let myCharactor = myCharactors[indexPath.row]
        cell.CharName.text = myCharactor.name
        cell.ModelImage.image = ModelChooseCell.getImage(myCharactor.modelName ?? "")

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        loadded_setting.selectid = indexPath.row
        GobalSetting.saveToFile(settings: loadded_setting)
        if let lmyCharactors = Charactor.readFromFile() {
            self.myCharactors = lmyCharactors
            tableView.reloadData()
        }
        if indexPath.row < self.myCharactors.count { tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none) }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        if (tableView.indexPathForSelectedRow?.row) != nil {
            
            loadded_setting.selectid = tableView.indexPathForSelectedRow!.row
            GobalSetting.saveToFile(settings: loadded_setting)
            return true;
        }
        
        if(myCharactors.count <= 0){
            return true
        }
        
        ControllerUtil.showAlert(self, message: "請選擇角色")
        
        return false;
    }
    
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return false
    }
 

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
