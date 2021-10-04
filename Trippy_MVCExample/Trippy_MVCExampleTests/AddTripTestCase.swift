//
//  AddTripTestCase.swift
//  Trippy_MVCExampleTests
//
//  Created by Chintan Maisuriya on 03/06/21.
//  Copyright © 2021 Chintan. All rights reserved.
//

import XCTest
@testable import Trippy_MVCExample

class AddTripTestCase: XCTestCase
{
    var sut: AddTripVC!
    
    override func setUpWithError() throws {
        // Step 1. Create an instance of UIStoryboard
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        // Step 2. Instantiate UIViewController with Storyboard ID
        sut = storyboard.instantiateViewController(withIdentifier: "AddTripVC") as? AddTripVC
        
        // Step 3. Make the viewDidLoad() execute.
        sut.loadViewIfNeeded()
    }
    
    override func tearDownWithError() throws {
        sut = nil
    }
    
    
    func test_navigationTitle_onAdd()
    {
        XCTAssertEqual(sut.getNavigationTitle(), "Add Trip", "Wrong Title On Add Trip")
    }
    
    
    func test_navigationTitle_onEdit()
    {
        sut.editTripConfiguration(tripInfo: Trip())
        XCTAssertEqual(sut.getNavigationTitle(), "Edit Trip", "Wrong Title On Edit Trip")
    }
    
    
    func test_buttonTitle_onAdd()
    {
        XCTAssertEqual(sut.getButtonTitle(), "SAVE", "Wrong Button Title On Add Trip")
    }
    
    
    func test_buttonTitle_onEdit()
    {
        sut.editTripConfiguration(tripInfo: Trip())
        XCTAssertEqual(sut.getButtonTitle(), "EDIT", "Wrong Button Title On Edit Trip")
    }
    
    
    func test_is_invalidTripRequest()
    {
        //
        let request = TripRequest()
        
        //
        let result = sut.tripValidation.validateRequest(request: request)
        
        //
        XCTAssertFalse(result.isValid)
        XCTAssertNotNil(result.message)
        
        switch result.error {
        case .invalidValue: XCTAssertEqual(result.message, Constant.enterInvalidValue)
        case .tripTitleEmpty: XCTAssertEqual(result.message, Constant.enterTitle)
        case .tripDateEmpty: XCTAssertEqual(result.message, Constant.selectDate)
        case .tripImagesEmpty: XCTAssertEqual(result.message, Constant.selectPhoto)
        case .none: break
        }
    }
    
    
    func test_is_validTripRequest()
    {
        //
        let request = TripRequest(title: "Saputara Trip", date: "01/01/2021", address: "Surat", latitude: 21.7000000, longitude: 72.00000, images: ["https://www.abc123.jpeg"])
        
        //
        let result = sut.tripValidation.validateRequest(request: request)
        
        //
        XCTAssertTrue(result.isValid)
        XCTAssertNil(result.message)
    }
    
    
    func test_tripTitle_isNil()
    {
        //
        let expectedError = ValidationError.invalidValue
        var error: ValidationError?

        //
        XCTAssertThrowsError(try sut.tripValidation.validateTitle(nil)){ tError in
            error = tError as? ValidationError
        }

         XCTAssertEqual(expectedError, error)
    }
    
    
    func test_tripTitle_isEmpty()
    {
        //
        let expectedError = ValidationError.tripTitleEmpty
        var error: ValidationError?
        let request = TripRequest()

        //
        XCTAssertThrowsError(try sut.tripValidation.validateTitle(request.title)){ tError in
            error = tError as? ValidationError
        }

         XCTAssertEqual(expectedError, error)
    }
    
    
    func test_tripDate_isNil()
    {
        //
        let expectedError = ValidationError.invalidValue
        var error: ValidationError?

        //
        XCTAssertThrowsError(try sut.tripValidation.validateDate(nil)){ tError in
            error = tError as? ValidationError
        }

        XCTAssertEqual(expectedError, error)
    }
    
    
    func test_tripDate_isEmpty()
    {
        //
        let expectedError = ValidationError.tripDateEmpty
        var error: ValidationError?
        let request = TripRequest()

        //
        XCTAssertThrowsError(try sut.tripValidation.validateDate(request.date)){ tError in
            error = tError as? ValidationError
        }

        XCTAssertEqual(expectedError, error)
    }
    
    
    func test_tripImages_isNil()
    {
        //
        let expectedError = ValidationError.invalidValue
        var error: ValidationError?

        //
        XCTAssertThrowsError(try sut.tripValidation.validateImageSelection(nil)){ tError in
            error = tError as? ValidationError
        }

        XCTAssertEqual(expectedError, error)
    }
    
    
    func test_tripImages_isEmpty()
    {
        //
        let expectedError = ValidationError.tripImagesEmpty
        var error: ValidationError?
        let request = TripRequest()

        //
        XCTAssertThrowsError(try sut.tripValidation.validateImageSelection(request.images)){ tError in
            error = tError as? ValidationError
        }

        XCTAssertEqual(expectedError, error)
    }
}
