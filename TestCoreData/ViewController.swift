//
//  ViewController.swift
//  TestCoreData
//
//  Created by Christian Selig on 2021-05-30.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    var container: NSPersistentContainer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        container = NSPersistentContainer(name: "IceCream")
        
        container.loadPersistentStores { storeDescription, error in
            guard error == nil else { fatalError("Non-nil error") }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // ===========
        // ENTRY POINT
        // ===========
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3)) {
            // Start with inserts, then comment out and doRequest()
//            self.doBunchaInserts()
            self.doRequest()
        }
    }

    func doRequest() {
        let startTime = CFAbsoluteTimeGetCurrent()
        let request = IceCream.createFetchRequest()
        request.predicate = NSPredicate(format: "name BEGINSWITH 'ask'")
        let sort = NSSortDescriptor(key: "subscribers", ascending: true)
        request.sortDescriptors = [sort]
        request.fetchBatchSize = 5_000
        request.resultType = .managedObjectResultType
        
        do {
            let iceCreams = try container.viewContext.fetch(request)
            let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
            print("Time elapsed: \(timeElapsed) s.")
            print(iceCreams.count)
        } catch {
            print(error)
        }
    }
    
    private func itemsFromJSON() -> [String] {
        let json = try! JSONSerialization.jsonObject(with: try! Data(contentsOf: Bundle.main.url(forResource: "input", withExtension: "json")!), options: []) as! [String]
        return json
    }
    
    func doBunchaInserts() {
        let items = itemsFromJSON()
        
        // Insert the 5K items * 100 for a total of 500K items
        for item in items {
            for i in 0 ..< 100 {
                let iceCream = IceCream(context: container.viewContext)
                iceCream.name = "\(item)\(i)"
                iceCream.subscribers = 3466293
            }
        }
        
        saveContext()
    }
    
    func saveContext() {
        let startTime = CFAbsoluteTimeGetCurrent()
        if container.viewContext.hasChanges {
            do {
                try container.viewContext.save()
                print("saved!")
                let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
                print("Time elapsed 3: \(timeElapsed) s.")
            } catch {
                print("An error occurred while saving: \(error)")
            }
        }
    }
}

