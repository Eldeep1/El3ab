//
//  NetworkServiceTests.swift
//  El3abTests
//
//  Created by depo on 10/06/2026.
//

import Testing



import XCTest
@testable import El3ab

final class MockNetworkService: NetworkServiceProtocol {
    var shouldSucceed: Bool = true

    var mockTeam: Team = Team(
        teamID: 0,
        name: "",
        logoImageName: "",
        players: [],
        coaches: []
    )
    var mockTeams: [Team] = []
    var mockLeagues: [Leagues] = []
    var mockEvents: [Event] = []

    var mockError: Error = NSError(
        domain: "MockErrorDomain",
        code: -1,
        userInfo: [NSLocalizedDescriptionKey: "Mock network error"]
    )

    private(set) var fetchLeaguesCallCount = 0
    private(set) var fetchTeamDetailsCallCount = 0
    private(set) var fetchLeagueTeamsCallCount = 0
    private(set) var fetchEventDetailsCallCount = 0

    private(set) var lastSport: Sport?
    private(set) var lastTeamId: String?
    private(set) var lastLeagueId: String?
    private(set) var lastFromDate: String?
    private(set) var lastToDate: String?

    func fetchLeagues(sport: Sport,
                      completion: @escaping (Result<[Leagues], Error>) -> Void) {
        fetchLeaguesCallCount += 1
        lastSport = sport
        shouldSucceed ? completion(.success(mockLeagues)) : completion(.failure(mockError))
    }

    func fetchTeamDetails(sport: Sport,
                          teamId: String,
                          completion: @escaping (Result<Team, Error>) -> Void) {
        fetchTeamDetailsCallCount += 1
        lastSport = sport
        lastTeamId = teamId
        shouldSucceed ? completion(.success(mockTeam)) : completion(.failure(mockError))
    }

    func fetchLeagueTeams(sport: Sport,
                          leagueId: String,
                          completion: @escaping (Result<[Team], Error>) -> Void) {
        fetchLeagueTeamsCallCount += 1
        lastSport = sport
        lastLeagueId = leagueId
        shouldSucceed ? completion(.success(mockTeams)) : completion(.failure(mockError))
    }

    func fetchEventDetails(sport: Sport,
                           leagueId: String,
                           from: String,
                           to: String,
                           completion: @escaping (Result<[Event], Error>) -> Void) {
        fetchEventDetailsCallCount += 1
        lastSport = sport
        lastLeagueId = leagueId
        lastFromDate = from
        lastToDate = to
        shouldSucceed ? completion(.success(mockEvents)) : completion(.failure(mockError))
    }
}


final class NetworkServiceTests: XCTestCase {

    var sut: MockNetworkService!

    override func setUp() {
        super.setUp()
        sut = MockNetworkService()

        sut.mockLeagues = [
            Leagues(leagueKey: 39, leagueName: "Premier League",
                    countryName: "England", leagueLogo: "epl.png",
                    countryLogo: "gb.svg", sportName: "football"),
            Leagues(leagueKey: 140, leagueName: "La Liga",
                    countryName: "Spain", leagueLogo: "liga.png",
                    countryLogo: "es.svg", sportName: "football")
        ]

        sut.mockTeam = Team(
            teamID: 50,
            name: "Manchester City",
            logoImageName: "mancity.png",
            players: [
                Player(name: "Haaland", imageName: "haaland.jpg",
                       position: "Forward", number: 9)
            ],
            coaches: [
                Coach(name: "Guardiola", imageName: "", role: "Head Coach")
            ]
        )

        sut.mockTeams = [
            Team(teamID: 50, name: "Manchester City",
                 logoImageName: "mancity.png", players: [], coaches: []),
            Team(teamID: 42, name: "Arsenal",
                 logoImageName: "arsenal.png", players: [], coaches: [])
        ]

        sut.mockEvents = [
            Event(eventDate: "2024-10-12",
                  eventTime: "20:00",
                  homeTeamName: "Falcons",
                  enemyTeamName: "Eagles",
                  finalResult: "3-1",
                  homeTeamLogo: "falcons.png",
                  awayTeamLogo: "eagles.png")
        ]
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }


    func testFetchLeagues_Success_ResultNotNil() {
        // Given
        sut.shouldSucceed = true
        var result: [Leagues]?
        // When
        let exp = expectation(description: "fetchLeagues success")
        sut.fetchLeagues(sport: .football) { outcome in
            if case .success(let leagues) = outcome { result = leagues }
            exp.fulfill()
        }
        waitForExpectations(timeout: 3)
        // Then
        XCTAssertNotNil(result)
    }


    func testFetchLeagues_Success_CorrectCount() {
        var count = 0
        let exp = expectation(description: "leagues count")
        sut.fetchLeagues(sport: .football) { outcome in
            if case .success(let leagues) = outcome { count = leagues.count }
            exp.fulfill()
        }
        waitForExpectations(timeout: 3)
        XCTAssertEqual(count, 2)
    }

    func testFetchLeagues_Success_FirstLeagueNameIsCorrect() {
        var firstName: String?
        let exp = expectation(description: "leagues first name")
        sut.fetchLeagues(sport: .football) { outcome in
            if case .success(let leagues) = outcome { firstName = leagues.first?.leagueName }
            exp.fulfill()
        }
        waitForExpectations(timeout: 3)
        XCTAssertEqual(firstName, "Premier League")
    }

    func testFetchLeagues_Success_FirstLeagueKeyIsCorrect() {
        var key: Int?
        let exp = expectation(description: "leagues first key")
        sut.fetchLeagues(sport: .football) { outcome in
            if case .success(let leagues) = outcome { key = leagues.first?.leagueKey }
            exp.fulfill()
        }
        waitForExpectations(timeout: 3)
        XCTAssertEqual(key, 39)
    }

    func testFetchLeagues_RecordsCorrectSport() {
        let exp = expectation(description: "leagues sport recorded")
        sut.fetchLeagues(sport: .basketball) { _ in exp.fulfill() }
        waitForExpectations(timeout: 3)
        XCTAssertEqual(sut.lastSport, .basketball)
    }

    func testFetchLeagues_CallCountIsOne() {
        let exp = expectation(description: "leagues call count")
        sut.fetchLeagues(sport: .football) { _ in exp.fulfill() }
        waitForExpectations(timeout: 3)
        XCTAssertEqual(sut.fetchLeaguesCallCount, 1)
    }

    func testFetchLeagues_Success_EmptyList() {
        sut.mockLeagues = []
        var count: Int?
        let exp = expectation(description: "leagues empty")
        sut.fetchLeagues(sport: .tennis) { outcome in
            if case .success(let leagues) = outcome { count = leagues.count }
            exp.fulfill()
        }
        waitForExpectations(timeout: 3)
        XCTAssertEqual(count, 0)
    }

    func testFetchLeagues_Cricket_Succeeds() {
        var succeeded = false
        let exp = expectation(description: "cricket leagues")
        sut.fetchLeagues(sport: .cricket) { outcome in
            if case .success = outcome { succeeded = true }
            exp.fulfill()
        }
        waitForExpectations(timeout: 3)
        XCTAssertTrue(succeeded)
    }


    func testFetchLeagues_Failure_ReturnsError() {
        sut.shouldSucceed = false
        var receivedError: Error?
        let exp = expectation(description: "leagues failure")
        sut.fetchLeagues(sport: .football) { outcome in
            if case .failure(let error) = outcome { receivedError = error }
            exp.fulfill()
        }
        waitForExpectations(timeout: 3)
        XCTAssertNotNil(receivedError)
    }

    func testFetchLeagues_Failure_ErrorMessageNotEmpty() {
        sut.shouldSucceed = false
        var message: String?
        let exp = expectation(description: "error message")
        sut.fetchLeagues(sport: .football) { outcome in
            if case .failure(let error) = outcome { message = error.localizedDescription }
            exp.fulfill()
        }
        waitForExpectations(timeout: 3)
        XCTAssertFalse(message?.isEmpty ?? true)
    }


    func testFetchTeamDetails_Success_ResultNotNil() {
        var team: Team?
        let exp = expectation(description: "team details")
        sut.fetchTeamDetails(sport: .football, teamId: "50") { outcome in
            if case .success(let t) = outcome { team = t }
            exp.fulfill()
        }
        waitForExpectations(timeout: 3)
        XCTAssertNotNil(team)
    }

    func testFetchTeamDetails_Success_CorrectTeamName() {
        var name: String?
        let exp = expectation(description: "team name")
        sut.fetchTeamDetails(sport: .football, teamId: "50") { outcome in
            if case .success(let t) = outcome { name = t.name }
            exp.fulfill()
        }
        waitForExpectations(timeout: 3)
        XCTAssertEqual(name, "Manchester City")
    }

    func testFetchTeamDetails_Success_CorrectTeamID() {
        var teamID: Int?
        let exp = expectation(description: "team id")
        sut.fetchTeamDetails(sport: .football, teamId: "50") { outcome in
            if case .success(let t) = outcome { teamID = t.teamID }
            exp.fulfill()
        }
        waitForExpectations(timeout: 3)
        XCTAssertEqual(teamID, 50)
    }

    func testFetchTeamDetails_Success_CorrectPlayersCount() {
        var count: Int?
        let exp = expectation(description: "team players count")
        sut.fetchTeamDetails(sport: .football, teamId: "50") { outcome in
            if case .success(let t) = outcome { count = t.players.count }
            exp.fulfill()
        }
        waitForExpectations(timeout: 3)
        XCTAssertEqual(count, 1)
    }

    func testFetchTeamDetails_Success_CorrectCoachesCount() {
        var count: Int?
        let exp = expectation(description: "team coaches count")
        sut.fetchTeamDetails(sport: .football, teamId: "50") { outcome in
            if case .success(let t) = outcome { count = t.coaches.count }
            exp.fulfill()
        }
        waitForExpectations(timeout: 3)
        XCTAssertEqual(count, 1)
    }

    func testFetchTeamDetails_Success_FirstPlayerName() {
        var playerName: String?
        let exp = expectation(description: "first player name")
        sut.fetchTeamDetails(sport: .football, teamId: "50") { outcome in
            if case .success(let t) = outcome { playerName = t.players.first?.name }
            exp.fulfill()
        }
        waitForExpectations(timeout: 3)
        XCTAssertEqual(playerName, "Haaland")
    }

    func testFetchTeamDetails_RecordsTeamId() {
        let exp = expectation(description: "team id recorded")
        sut.fetchTeamDetails(sport: .football, teamId: "999") { _ in exp.fulfill() }
        waitForExpectations(timeout: 3)
        XCTAssertEqual(sut.lastTeamId, "999")
    }

    func testFetchTeamDetails_RecordsCorrectSport() {
        let exp = expectation(description: "team sport recorded")
        sut.fetchTeamDetails(sport: .basketball, teamId: "1") { _ in exp.fulfill() }
        waitForExpectations(timeout: 3)
        XCTAssertEqual(sut.lastSport, .basketball)
    }
}

