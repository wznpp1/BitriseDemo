//
//  UserServiceTests.swift
//  BitriseDemo
//
//  Created by Kazutoshi Baba on 3/3/16.
//  Copyright © 2016 Kazutoshi Baba. All rights reserved.
//

import XCTest
import BitriseDemo
import CoreData

class UserServiceTests: XCTestCase {
    
    var userService: UserService!
    var coreDataStack: CoreDataStack!
    
    override func setUp() {
        super.setUp()
        
        coreDataStack = TestCoreDataStack()
        userService = UserService(managedObjectContext: coreDataStack.mainContext, coreDataStack: coreDataStack)
    }
    
    override func tearDown() {
        super.tearDown()
        
        coreDataStack = nil
        userService = nil
    }
    
    func testRootContextIsSavedAfterAddingUser() {
        
        expectation(forNotification: Notification.Name.NSManagedObjectContextDidSave.rawValue, object: coreDataStack.rootContext) { notification in
            return true
        }
        
        userService.addUser("Joel Armstrong", phoneNumber: "123-456-7890")
        
        waitForExpectations(timeout: 2.0){ error in
            XCTAssertNil(error, "Save did not occur")
        }
        
    }
    
    func testAddUser() {
        
        let user = userService.addUser("Joel Armstrong", phoneNumber: "123-456-7890")
        
        XCTAssertNotNil(user, "User should not be nil")
        XCTAssertTrue(user?.fullName == "Joel Armstrong")
        XCTAssertTrue(user?.phoneNumber == "123-456-7890")
    }
    
    func testGetNoUser() {
        
        let user = userService.getUser("Joel Armstrong")
        
        XCTAssertNil(user, "No user should be returned")
    }
    
    func testGetUser() {
        
        userService.addUser("Joel Armstrong", phoneNumber: "123-456-7890")
        
        let user = userService.getUser("Joel Armstrong")
        
        XCTAssertNotNil(user, "A user should be returned")
    }
    
    func testDeleteUser() {
        
        userService.addUser("Joel Armstrong", phoneNumber: "123-456-7890")
        
        var fetchedUser = userService.getUser("Joel Armstrong")
        
        XCTAssertNotNil(fetchedUser, "User should exist")
        
        userService.deleteUser("Joel Armstrong")
        
        fetchedUser = userService.getUser("Joel Armstrong")
        
        XCTAssertNil(fetchedUser, "User shouldn't exist")
    }
    
}
