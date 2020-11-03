//
//  ItemViewController.swift
//  Todo List App
//
//  Created by Jorge Alejandro Chavez Nuñez on 01/11/20.
//

import UIKit
import CoreData

class ItemViewController: UIViewController {
    
    // Referencia al managed Object context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // Outlet
    @IBOutlet weak var itemInfoLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var doneNotDoneLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UITextField!
    
    
    // Variables
    public var item: List?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        descriptionLabel.text = item!.descript

        itemInfoLabel.text = item!.to_do
        
        if item!.done == false {
            doneNotDoneLabel.text = "Not Done"
        } else {
            doneNotDoneLabel.text = "Done"
        }
        
    }

    @IBAction func doneButtonAction(_ sender: Any) {
        
        item?.done = true
        doneNotDoneLabel.text = "Done"
        try! self.context.save()
        
    }
    
    @IBAction func saveActionButton(_ sender: Any) {
        
        item?.descript = descriptionLabel.text
        try! self.context.save()
        
    }
    
}
