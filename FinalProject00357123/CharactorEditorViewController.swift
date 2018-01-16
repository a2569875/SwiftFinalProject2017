//
//  CharactorEditorViewController.swift
//  FinalProject00357123
//
//  Created by 張宇帆 on 2018/1/12.
//  Copyright © 2018年 NTOU department of computer science. All rights reserved.
//

import UIKit

class CharactorEditorViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    
    var charactor_data : Charactor!
    
    @IBOutlet weak var UserDefineImage: UIButton!
    var ModelName : String?
    @IBOutlet weak var ModelImage: UIButton!
    @IBOutlet weak var UserDefineName: UITextField!
    @IBOutlet weak var preview_btm: UIButton!
    var setindex = -1
    var isChangeImage = false
    var shouldAdd = true
    @IBOutlet weak var headButton: UIButton!
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        isChangeImage = true
        
        UserDefineImage.setBackgroundImage(image, for: .normal)
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func changePhotoBtm(_ sender: Any) {
        
        let controller = UIImagePickerController()
        controller.sourceType = .photoLibrary
        controller.delegate = self
        present(controller, animated: true, completion: nil)
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let controller = segue.destination as? ViewController {

            if let m_name = ModelName {
                controller.modelFile = m_name
                controller.use_setting = false
            }
        }
        

    }
    
    
    @IBAction func completeModelChooese(segue: UIStoryboardSegue) {
        if let controller = segue.source as? ModelChooseController {
            ModelName = controller.chooseData
            ModelImage.setBackgroundImage(controller.showed_image, for: .normal)
        }
        
    }
    @IBOutlet weak var page_title: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if shouldAdd != true {
            UserDefineImage.setBackgroundImage(charactor_data.image, for: .normal)
            ModelImage.setBackgroundImage(ModelChooseCell.getImage(charactor_data.modelName ?? ""), for: .normal)
            ModelName = charactor_data.modelName
            UserDefineName.text = charactor_data.name
            page_title.title = "編輯角色"
        }else{
            page_title.title = "新增角色"
        }
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

    /*override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }*/

    /*override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }*/

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
    
    @IBAction func viewTapped(_ sender: Any) {
        view.endEditing(true)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    func showAlert(message: String) {
        let controller = UIAlertController(title: "錯誤", message: message, preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        controller.addAction(action)
        present(controller, animated: true, completion: nil)
        
    }
    
    
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        if ModelImage == sender as? UIButton {
            return true
        }
        
        if preview_btm == sender as? UIButton  {
            if ModelName != nil {
                guard ModelName! != "none" else{
                    return false
                }
                return true
            }else{
                return false
            }
        }
        
        guard let name = UserDefineName.text, name.count > 0 else {
            
            showAlert(message: "請輸入名字")
            return false
        }
        
        var imageName: String?
        if isChangeImage {
            imageName = "\(Date().timeIntervalSinceReferenceDate)"
            if let imageName = imageName {
                let url = Charactor.documentsDirectory.appendingPathComponent(imageName)
                if let image = UserDefineImage.backgroundImage(for: .normal) {
                    let data = UIImageJPEGRepresentation(image, 0.9)
                    try? data?.write(to: url)
                }
            }
        }
        charactor_data = Charactor(name: name, orgName: "", innerBeauty: true, imageName: imageName, modelName: ModelName ?? "")
        
        return true
    }
}
