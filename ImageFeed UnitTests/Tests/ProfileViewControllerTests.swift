//
//  ProfileViewControllerTests.swift
//  Image FeedTests
//
//  Created by Kaider on 02.02.2025.
//

import XCTest
@testable import Image_Feed

final class ProfileViewControllerSpy_Tests: XCTestCase {
    var viewControllerSpy: ProfileViewControllerSpy!
    
    override func setUp() {
        super.setUp()
        viewControllerSpy = ProfileViewControllerSpy()
    }
    
    override func tearDown() {
        viewControllerSpy = nil
        super.tearDown()
    }
    
    func testUpdateProfileDetailsCalled() {
        let profile = ProfileModels.Profile(
            username: "test",
            name: "Test Name",
            loginName: "test_login",
            bio: "test bio"
        )
        viewControllerSpy.updateProfileDetails(profile: profile)
        XCTAssertTrue(viewControllerSpy.updateProfileDetailsCalled)
    }
    
    func testUpdateAvatarCalled() {
        let url = URL(string: "https://example.com")
        viewControllerSpy.updateAvatar(url: url)
        XCTAssertTrue(viewControllerSpy.updateAvatarCalled)
    }
    
    func testShowLogoutAlertCalled() {
        viewControllerSpy.showLogoutAlert()
        XCTAssertTrue(viewControllerSpy.showLogoutAlertCalled)
    }
}
