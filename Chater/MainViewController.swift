//
//  MainViewController.swift
//  Chater
//
//  Created by Kelvin Lui on 2/21/18.
//  Copyright © 2018 Kelvin Lui. All rights reserved.
//

import UIKit
import Parse

class MainViewController: UIViewController, UITableViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var chatMessageField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textField: UITextField!
    
    
    var chatMessages: [PFObject]!
    var query = PFQuery()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "Chat"
        
        // Auto size row height based on cell autolayout constraints
        tableView.rowHeight = UITableViewAutomaticDimension
        // Provide an estimated row height. Used for calculating scroll indicator
        tableView.estimatedRowHeight = 100
        
        onTimer()
        
        tableView.dataSource = self
        
        textField.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "chatCell") as! ChatCell
        
        if let chatMessageObjects = chatMessages {
            let messageObject = chatMessageObjects[indexPath.row]
            if let message = messageObject["text"] as? String {
                cell.messageLabel.text = message
            } else {
                cell.messageLabel.text = ""
            }
            
            let user = messageObject["user"] as? PFUser
            if user != nil {
                // User found! update username label with username
                if let username = user?.username {
                    cell.usernameLabel.text = username
                }
            } else {
                // No user found, set default username
                cell.usernameLabel.text = "🤖"
            }
        }
        
        return cell
    }
    
    @objc func onTimer() {
        // Add code to be run periodically
        Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(self.onTimer), userInfo: nil, repeats: true)
        let query = PFQuery(className: "Message")
        query.addDescendingOrder("createdAt")
        query.includeKey("user")
        
        query.findObjectsInBackground(block: { (messages: [PFObject]?, error: Error?) in
            let query = PFQuery(className: "Message")
            query.addDescendingOrder("createdAt")
            if let messages = messages {
                self.chatMessages = messages
                for msg in messages {
                    print(msg["text"])
                    self.tableView.reloadData()
                }
            } else if let error = error {
                print(error.localizedDescription)
            }
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let messages = chatMessages {
            return messages.count
        } else {
            return 10
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onSend(_ sender: UIButton) {
        let chatMessage = PFObject(className: "Message")
        chatMessage["text"] = chatMessageField.text ?? ""
        chatMessage["user"] = PFUser.current()
        chatMessage.saveInBackground { (success, error) in
            if success {
                print("The message was saved!")
                self.chatMessageField.text = ""
            } else if let error = error {
                print("Problem saving message: \(error.localizedDescription)")
            }
        }
        
        chatMessageField.text = ""
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
