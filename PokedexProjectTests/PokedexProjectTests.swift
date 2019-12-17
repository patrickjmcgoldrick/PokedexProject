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

    func testPokemenListParser() {
        // need this to keep testing alive until
        // the background process finishes
        let expectation = self.expectation(description: "Testing Pokemon List Parser")

        let testBundle = Bundle(for: type(of: self))
        let filename = "pokemenList"

        let path = testBundle.path(forResource: filename, ofType: "json")
        XCTAssertNotNil(path, "\(filename) file not found")

        guard let cleanPath = path else { return }

        // convert into URL
        let url = NSURL.fileURL(withPath: cleanPath)
        do {
            // load json into Data object
            let data = try Data(contentsOf: url)

            XCTAssertNotNil(data, "Data came back nil")

            let parser = PokemenListParser()
            parser.parse(data: data) { (pokemenHeader) in

                XCTAssertTrue(pokemenHeader.count == K.TestCase.expectedPokemenCount)

                expectation.fulfill()
            }
        } catch {
            assertionFailure("Error: " + error.localizedDescription)
        }
        // 15 second wait for timeout
        waitForExpectations(timeout: 15, handler: nil)
    }

    func testPokemonParser() {
        // need this to keep testing alive until
        // the background process finishes
        let expectation = self.expectation(description: "Testing Pokemon Parser")

        let testBundle = Bundle(for: type(of: self))
        let filename = "pokemon_1"

        let path = testBundle.path(forResource: filename, ofType: "json")
        XCTAssertNotNil(path, "\(filename) file not found")

        guard let cleanPath = path else { return }

        // convert into URL
        let url = NSURL.fileURL(withPath: cleanPath)
        do {
            // load json into Data object
            let data = try Data(contentsOf: url)

            XCTAssertNotNil(data, "Data came back nil")

            let parser = PokemonParser()
            parser.parse(data: data) { (pokemonData) in
                XCTAssertTrue(pokemonData.abilities[0].ability.name == "chlorophyll")

                print(pokemonData.species.url)
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

                XCTAssertTrue(pokemonFromData.pokemon?.name == "bulbasaur")

                expectation.fulfill()
            }
        } catch {
            assertionFailure("Error: " + error.localizedDescription)
        }

        // 15 second wait for timeout
        waitForExpectations(timeout: 15, handler: nil)
    }

    func testEvolutionChainParser() {
        // need this to keep testing alive until
        // the background process finishes
        let expectation = self.expectation(description: "Testing Evolution Chain Parser")

        let testBundle = Bundle(for: type(of: self))
        let filename = "evolution-chain_2"

        let path = testBundle.path(forResource: filename, ofType: "json")
        XCTAssertNotNil(path, "\(filename) file not found")

        guard let cleanPath = path else { return }

        // convert into URL
        let url = NSURL.fileURL(withPath: cleanPath)
        do {
            // load json into Data object
            let data = try Data(contentsOf: url)

            XCTAssertNotNil(data, "Data came back nil")

            let parser = EvolutionParser()
            parser.parse(data: data) { (evolutionChain) in

//                print(evolutionChain.chain.species)
//                XCTAssertTrue(evolutionChain.chain.species.name == "charmander")

                var step = evolutionChain.chain.evolves_to
                
                while step.count > 0 {
                    //print(step[0].species)
                    step = step[0].evolves_to
                }
                
                expectation.fulfill()
            }
        } catch {
            assertionFailure("Error: " + error.localizedDescription)
        }

        // 15 second wait for timeout
        waitForExpectations(timeout: 15, handler: nil)
    }

    func testSpeciesParser() {
        // need this to keep testing alive until
        // the background process finishes
        let expectation = self.expectation(description: "Testing Species Parser")

        let testBundle = Bundle(for: type(of: self))
        let filename = "pokemon-species_413"

        let path = testBundle.path(forResource: filename, ofType: "json")
        XCTAssertNotNil(path, "\(filename) file not found")

        guard let cleanPath = path else { return }

        // convert into URL
        let url = NSURL.fileURL(withPath: cleanPath)
        do {
            // load json into Data object
            let data = try Data(contentsOf: url)

            XCTAssertNotNil(data, "Data came back nil")

            let parser = SpeciesParser()
            parser.parse(data: data) { (speciesData) in

                print(speciesData.evolution_chain?.url as Any)
                expectation.fulfill()
            }
        } catch {
            assertionFailure("Error: " + error.localizedDescription)
        }

        // 15 second wait for timeout
        waitForExpectations(timeout: 15, handler: nil)
    }
}
