//
//  ViewController.swift
//  TableViews
//
//  Created by Ricardo Rodriguez.
//  Copyright © 2023 RicardoDev. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
//    private let myCountries = ["España", "Mexico", "Perú", "Colombia", "Argentina", "EEUU", "Francia", "Italia"]
    private var myCountries: [Pais]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        
//        Recurar datos
        recuperarDatos()

    }

    @IBAction func add(_ sender: Any) {
//        print("Añadir Datos")
        
        //Create alert
        let alert = UIAlertController(title: "Add Country", message: "Agreda un nuevo país", preferredStyle: .alert)
        
        //add textField
        alert.addTextField()
        
        //create and setting button alert
        let buttonAlert = UIAlertAction(title: "Agregar", style: .default) { (action) in
                //Get textField alert
                let textField = alert.textFields![0]
                
                // Create object Country
                let newCountry = Pais(context: self.context)
                newCountry.nombre = textField.text
                
                //Save information
                
                try! self.context.save()
                
                //refresh information of tableView
                self.recuperarDatos()
        }
        
        //Add button to alert and show alert
        alert.addAction(buttonAlert)
        self.present(alert, animated: true, completion: nil)
    }
    
    func recuperarDatos() {
        do {
            self.myCountries = try context.fetch(Pais.fetchRequest())
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch {
            print("Error al recuperar datos")
        }
    }
    
}




// MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return myCountries!.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
            
            var cell = tableView.dequeueReusableCell(withIdentifier: "mycell")
            if cell == nil {
               
                cell = UITableViewCell(style: .default, reuseIdentifier: "mycell")
                cell?.textLabel?.font = UIFont.systemFont(ofSize: 20)
                
            }
        cell!.textLabel?.text = myCountries![indexPath.row].nombre
        
            return cell!
    }
    
}

// MARK: - UITableViewDelegate
extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        //what country edit?
        let editCountry = self.myCountries![indexPath.row]
        
        //create alert
        let alert = UIAlertController(title: "Edit Country", message: "Edita el nombre del país", preferredStyle: .alert)
        alert.addTextField()
        
        //get name country actualy of tableView and add to textField
        let textField = alert.textFields![0]
        textField.text = editCountry.nombre
        
        //create and setting button of alert
        let buttonAlert = UIAlertAction(title: "Edit", style: .default) { (action) in
            
            //get textField of alert
            let textField = alert.textFields![0]
            
            //edit actualy country, with context of textfield
            editCountry.nombre = textField.text
            
            //save information
            
            do {
                try self.context.save()
            } catch {
                print("Error al guardar edicion -> \(error)")
            }
            
            //refresh information of tableView
            self.recuperarDatos()
        }
        
        // addition button to alert and show alert
        alert.addAction(buttonAlert)
        self.present(alert, animated: true, completion: nil)
        
//        print(myCountries![indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        //create action delete
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action,view,completionHandler) in
            
            // What country delete?
            let deleteCountry = self.myCountries![indexPath.row]
            
            //delete country
            self.context.delete(deleteCountry)
            
            //save delete
//            try! self.context.save()
            do {
                try self.context.save()
            } catch {
                print("Error al añadir -> \(error)")
            }
            
            //refresh data tableView
            
            self.recuperarDatos()
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
        
    }
    
}

