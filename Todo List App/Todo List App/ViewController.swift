//
//  ViewController.swift
//  Todo List App
//
//  Created by Jorge Alejandro Chavez Nuñez on 24/10/20.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    // Referencia al managed Object context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // Outlets
    @IBOutlet weak var myAddTextField: UITextField!
    @IBOutlet weak var myTableView: UITableView!
    
    // Variables
    private var myToDo: [List]?
    private var toDoDone: [String]?
    private var item: List?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myTableView.dataSource = self
        myTableView.delegate = self
        
        myTableView.tableFooterView = UIView()
        
        recuperarDatos()

    }

    @IBAction func addButtonAction(_ sender: Any) {
        
        // Recuperar datos del TextField
        if let textField = myAddTextField.text{
            if textField != "" {
               
                // crear objeto pais
                let newToDo = List(context: self.context)
                newToDo.to_do = textField
                newToDo.done = false
                
            }
        }
        
        try! self.context.save()
        
        self.recuperarDatos()
        myAddTextField.text = ""
        
    }
    
    func recuperarDatos() {
        
        do {
            self.myToDo = try context.fetch(List.fetchRequest())
            
            DispatchQueue.main.async {
                self.myTableView.reloadData()
            }
        
        } catch  {
            print("Error al cargar datos")
        }
        
    }
    
}

// MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return myToDo?.count ?? 0
    
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        var cell = tableView.dequeueReusableCell(withIdentifier: "mycell")
        
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "mycell")
        }
            
        cell!.textLabel?.text = myToDo![indexPath.row].to_do
            
        return cell!
       
    }
    
    
}
 
// MARK: - UITableViewDelegate
extension ViewController: UITableViewDelegate {
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        myTableView.deselectRow(at: indexPath, animated: true)
        
        // Abrir pantalla con informacion sobre la ToDoList
        item = myToDo![indexPath.row]
       
        performSegue(withIdentifier: "info", sender: self)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destino = segue.destination as? ItemViewController {
            destino.item = item
        }
    }
    
    // Eliminar/Editar con swipe
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        // Crear accion de eliminar
        let accionEliminar = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
            
            // Cual pais se eliminara?
            let deleteToDo = self.myToDo![indexPath.row]
            
            // Eliminar pais
            self.context.delete(deleteToDo)
            
            // Guardar el cambio de informacion
            try! self.context.save()
            
            // Recuperar datos
            self.recuperarDatos()
            
        }
        
        // Crear accion de editar
        let accionEditar = UIContextualAction(style: .normal, title: "Edit") { (action, view, completionHandler) in
            
            // Cual ToDo se editara?
            let editToDo = self.myToDo![indexPath.row]
            
            // Crear alerta
            let alerta = UIAlertController(title: "Edit", message: "Edit the ToDo", preferredStyle: .alert)
            alerta.addTextField()
            
            // Recuperar el TextField de la alerta
            let textField = alerta.textFields![0]
            
            textField.text = editToDo.to_do
            
            // Crear y configurar boton de alerta
            let botonAlerta = UIAlertAction(title: "Done", style: .default){(action) in
                
                // Recuperar nombre del ToDo actual  de la alerta
                let textField = alerta.textFields![0]
                
                // Edita el ToDo actual
                editToDo.to_do = textField.text
                
                // Guardar Informacion
                try! self.context.save()
                
                // Refrescar datos
                self.recuperarDatos()
            }
            alerta.addAction(botonAlerta)
            self.present(alerta, animated: true, completion: nil)
            
        }
        
        accionEditar.backgroundColor = .systemIndigo
        
        return UISwipeActionsConfiguration(actions: [accionEliminar, accionEditar])
    }
}

