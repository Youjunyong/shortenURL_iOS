//
//  DataManager.swift
//  GetApiPractice
//
//  Created by 유준용 on 2021/06/17.
//


import Foundation
import CoreData


class DataManager {
    // Singleton 객체 shared
    static let shared = DataManager()
    private init() {
    }

    var mainContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    var bookMarkList = [BookMark]()
    
    func fetchBookMark() {
        let request : NSFetchRequest<BookMark> = BookMark.fetchRequest()
        let sortByDateDesc = NSSortDescriptor(key : "registerDate", ascending: false)
        request.sortDescriptors = [sortByDateDesc]
        do{
            bookMarkList = try mainContext.fetch(request)
        } catch {
            print(error)
        }
    }
    
    func addBookMark(_ orgUrl : String?, shortenUrl : String?) {
        let newBookMark = BookMark(context: mainContext)
        newBookMark.orgUrl = orgUrl
        newBookMark.shortenUrl = shortenUrl
        newBookMark.registerDate = Date()
        
        saveContext()
    }
    
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "GetApiPractice")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
