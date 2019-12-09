//
//  PokedexProjectTests.swift
//  PokedexProjectTests
//
//  Created by dirtbag on 12/6/19.
//  Copyright © 2019 dirtbag. All rights reserved.
//

import XCTest
@testable import PokedexProject

class PokedexProjectTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testPokemenParser() {
        // need this to keep testing alive until
        // the background process finishes
        let expectation = self.expectation(description: "Testing Pokemon Parser")
        
        let testBundle = Bundle(for: type(of: self))
        let filename = "pokemen"

        let path = testBundle.path(forResource: filename, ofType: "json")
        XCTAssertNotNil(path, "\(filename) file not found")

        guard let cleanPath = path else { return }

        // convert into URL
        let url = NSURL.fileURL(withPath: cleanPath)
        do {
            // load json into Data object
            let data = try Data(contentsOf: url)

            XCTAssertNotNil(data, "Data came back nil")

            let parser = PokemenParser()
            parser.parse(data: data) { (pokemenHeader) in
                
                print ("Count: \(pokemenHeader.count)")
                XCTAssertTrue(pokemenHeader.count == K.TestCase.expectedPokemenCount)

                expectation.fulfill()
            }
        } catch {
            assertionFailure("Error: " + error.localizedDescription)
        }
        // 15 second wait for timeout
        waitForExpectations(timeout: 15, handler: nil)
    }
    
    func testPokemenFormParser() {
        // need this to keep testing alive until
        // the background process finishes
        let expectation = self.expectation(description: "Testing Pokemon Form Data Parser")
        
        let testBundle = Bundle(for: type(of: self))
        let filename = "pokemon-form_1"

        let path = testBundle.path(forResource: filename, ofType: "json")
        XCTAssertNotNil(path, "\(filename) file not found")

        guard let cleanPath = path else { return }

        // convert into URL
        let url = NSURL.fileURL(withPath: cleanPath)
        do {
            // load json into Data object
            let data = try Data(contentsOf: url)

            XCTAssertNotNil(data, "Data came back nil")

            let parser = PokemonFormParser()
            parser.parse(data: data) { (pokemonFromData) in
                
                print ("id: \(pokemonFromData.id)")
                print ("name: \(pokemonFromData.pokemon?.name)")
                print ("url: \(pokemonFromData.pokemon?.url)")
                print ("name: \(pokemonFromData.sprites?.front_default)")

                XCTAssertTrue(pokemonFromData.pokemon?.name == "bulbasaur")

                expectation.fulfill()
            }
        } catch {
            assertionFailure("Error: " + error.localizedDescription)
        }
        // 15 second wait for timeout
        waitForExpectations(timeout: 15, handler: nil)
    }
}
