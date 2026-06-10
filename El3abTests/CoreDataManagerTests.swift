//
//  CoreDataManagerTests.swift
//  El3abTests
//
//  Created by Osama Khaled on 10/06/2026.
//


import XCTest
import CoreData
@testable import El3ab

class CoreDataManagerTests: XCTestCase {
    
    private let sut = CoreDataManager.shared
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        clearDatabase()
    }
    
    override func tearDownWithError() throws {
        clearDatabase()
        try super.tearDownWithError()
    }
    

    private func clearDatabase() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = FavoriteLeague.fetchRequest()
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try sut.context.execute(batchDeleteRequest)
            sut.saveContext()
        } catch {
            XCTFail("Failed to clear database: \(error)")
        }
    }
    
    func testAddFavoriteLeague_WhenNewLeague_ShouldReturnTrueAndIncreaseCount() throws {
        // Arrange
        let sampleLeague = Leagues.sampleLeagues.first ?? Leagues(leagueKey: 99, leagueName: "Test", countryName: "Test", leagueLogo: nil, countryLogo: nil, sportName: "football")
        
        // Act
        let isAdded = sut.addFavoriteLeague(league: sampleLeague, sportName: "football")
        let count = sut.getFavoritesCount()
        
        // Assert
        XCTAssertTrue(isAdded, "Adding a new league should return true")
        XCTAssertEqual(count, 1, "Favorites count should be 1 after adding")
    }
    
    func testAddFavoriteLeague_WhenAlreadyFavorited_ShouldReturnFalse() {
        // Arrange
        let sampleLeague = Leagues.sampleLeagues.first ?? Leagues(leagueKey: 99, leagueName: "Test", countryName: "Test", leagueLogo: nil, countryLogo: nil, sportName: "football")
        _ = sut.addFavoriteLeague(league: sampleLeague, sportName: "football")
        
        // Act
        let isAddedAgain = sut.addFavoriteLeague(league: sampleLeague, sportName: "football")
        
        // Assert
        XCTAssertFalse(isAddedAgain, "Adding an already favorited league should return false")
    }
    
    func testDeleteFavoriteLeague_WhenExists_ShouldReturnTrueAndDecreaseCount() {
        // Arrange
        let sampleLeague = Leagues(leagueKey: 100, leagueName: "To Delete", countryName: "Test", leagueLogo: nil, countryLogo: nil, sportName: "football")
        _ = sut.addFavoriteLeague(league: sampleLeague, sportName: "football")
        
        // Act
        let isDeleted = sut.deleteFavoriteLeague(leagueKey: 100)
        let count = sut.getFavoritesCount()
        
        // Assert
        XCTAssertTrue(isDeleted, "Deleting an existing league should return true")
        XCTAssertEqual(count, 0, "Count should be 0 after deletion")
    }
    
    func testGetAllFavoriteLeagues_ShouldReturnCorrectItems() {
        // Arrange
        let league1 = Leagues(leagueKey: 101, leagueName: "League A", countryName: "Country A", leagueLogo: nil, countryLogo: nil, sportName: "football")
        let league2 = Leagues(leagueKey: 102, leagueName: "League B", countryName: "Country B", leagueLogo: nil, countryLogo: nil, sportName: "football")
        
        _ = sut.addFavoriteLeague(league: league1, sportName: "football")
        _ = sut.addFavoriteLeague(league: league2, sportName: "football")
        
        // Act
        let favorites = sut.getAllFavoriteLeagues()
        
        // Assert
        XCTAssertEqual(favorites.count, 2, "Should fetch exactly 2 leagues")
        XCTAssertTrue(favorites.contains(where: { $0.leagueKey == 101 }), "Should contain League A")
    }
}
