//
//  CoreDataManager.swift
//  El3ab
//

import Foundation
import CoreData
import UIKit

protocol LocalStorageProtocol{
    func addFavoriteLeague(league: Leagues, sportName: String) -> Bool
    func isLeagueFavorited(leagueKey: Int) -> Bool
    func deleteFavoriteLeague(leagueKey: Int) -> Bool
    func getAllFavoriteLeagues() -> [Leagues]
    func getFavoritesCount() -> Int
}
class CoreDataManager : LocalStorageProtocol {
    
    static let shared = CoreDataManager()
    
    private init() {
        seedSampleDataIfNeeded()

    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "El3ab")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    private func seedSampleDataIfNeeded() {
        let fetchRequest: NSFetchRequest<FavoriteLeague> = FavoriteLeague.fetchRequest()
        
        do {
            let count = try context.count(for: fetchRequest)
            if count == 0 {
                for league in Leagues.sampleLeagues {
                    _ = addFavoriteLeague(league: league, sportName: league.sportName ?? "football")
                }
                print("Seeded \(Leagues.sampleLeagues.count) sample leagues")
            }
        } catch {
            print("Error checking sample data: \(error)")
        }
    }
    func addFavoriteLeague(league: Leagues, sportName: String) -> Bool {
        if isLeagueFavorited(leagueKey: league.leagueKey) {
            return false
        }
        
        let favoriteLeague = FavoriteLeague(context: context)
        favoriteLeague.leagueKey = Int32(league.leagueKey)
        favoriteLeague.leagueName = league.leagueName
        favoriteLeague.countryName = league.countryName
        favoriteLeague.leagueLogo = league.leagueLogo
        favoriteLeague.countryLogo = league.countryLogo
        favoriteLeague.sportName = sportName
        
        saveContext()
        return true
    }
    
    func deleteFavoriteLeague(leagueKey: Int) -> Bool {
        let fetchRequest: NSFetchRequest<FavoriteLeague> = FavoriteLeague.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "leagueKey == %d", leagueKey)
        
        do {
            let results = try context.fetch(fetchRequest)
            if let leagueToDelete = results.first {
                context.delete(leagueToDelete)
                saveContext()
                return true
            }
        } catch {
            print("Error deleting favorite league: \(error)")
        }
        return false
    }
    
    func getAllFavoriteLeagues() -> [Leagues] {
        let fetchRequest: NSFetchRequest<FavoriteLeague> = FavoriteLeague.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "leagueName", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            let favoriteLeagues = try context.fetch(fetchRequest)
            return favoriteLeagues.map { $0.toLeagues() }
        } catch {
            print("Error fetching favorite leagues: \(error)")
            return []
        }
    }
    
    func isLeagueFavorited(leagueKey: Int) -> Bool {
        let fetchRequest: NSFetchRequest<FavoriteLeague> = FavoriteLeague.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "leagueKey == %d", leagueKey)
        fetchRequest.fetchLimit = 1
        
        do {
            let count = try context.count(for: fetchRequest)
            return count > 0
        } catch {
            print("Error checking favorite status: \(error)")
            return false
        }
    }
    
    func getFavoritesCount() -> Int {
        let fetchRequest: NSFetchRequest<FavoriteLeague> = FavoriteLeague.fetchRequest()
        
        do {
            let count = try context.count(for: fetchRequest)
            return count
        } catch {
            print("Error getting favorites count: \(error)")
            return 0
        }
    }
}

extension FavoriteLeague {
    func toLeagues() -> Leagues {
        return Leagues(
            leagueKey: Int(self.leagueKey),
            leagueName: self.leagueName ?? "",
            countryName: self.countryName ?? "",
            leagueLogo: self.leagueLogo,
            countryLogo: self.countryLogo,
            sportName: self.sportName 
        )
    }
}
