//
//  ImageFeedUiTests.swift
//  ImageFeedUiTests
//
//  Created by Islam Tagirov on 04.02.2025.
//

import XCTest

class Image_FeedUITests: XCTestCase {
    private let app = XCUIApplication()
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }
    
    func testAuth() throws {
       sleep(2)
       
       let authButton = app.buttons["Authenticate"]
       XCTAssertTrue(authButton.exists, "Кнопка входа не найдена")
       authButton.tap()
       let webViewContainer = app.otherElements["WebViewViewController"]
       XCTAssertTrue(webViewContainer.waitForExistence(timeout: 8), "WebView контейнер не загрузился")
       sleep(7)
       
       let emailTextField = webViewContainer.textFields["Email address"]
       XCTAssertTrue(emailTextField.waitForExistence(timeout: 5), "Поле email не найдено")
       emailTextField.tap()
        emailTextField.typeText("itagirov2003@gmail.com") // TO-DO: Вписать свой логин
       webViewContainer.swipeUp()
       sleep(3)
       
       let passwordTextField = webViewContainer.secureTextFields["Password"]
       XCTAssertTrue(passwordTextField.waitForExistence(timeout: 5), "Поле пароля не найдено")
       passwordTextField.tap()
       passwordTextField.typeText("Islam001") // TO-DO: Вписать свой пароль
       webViewContainer.swipeUp()
       sleep(2)
    
       let loginButton = webViewContainer.buttons["Login"]
       XCTAssertTrue(loginButton.waitForExistence(timeout: 3), "Кнопка Login не найдена")
       loginButton.tap()
       
       let cell = app.tables.firstMatch.cells.firstMatch
       XCTAssertTrue(cell.waitForExistence(timeout: 8), "Не загрузился основной экран")
    }
    
    func testFeed() throws {
        sleep(7)
        
        let table = app.tables.firstMatch
        let cell = table.cells.firstMatch
        
        table.swipeUp()
        sleep(2)
        
        table.swipeDown()
        sleep(2)
        
        let likeButton = cell.buttons["LikeButton"]
        XCTAssertTrue(likeButton.exists, "Кнопка лайка не найдена")
        
        let initialState = likeButton.value as? String
        sleep(2)
        likeButton.tap()
        sleep(5)
        
        let stateAfterFirstTap = likeButton.value as? String
        sleep(2)
        XCTAssertNotEqual(initialState, stateAfterFirstTap, "Состояние кнопки не изменилось после первого нажатия")
        
        likeButton.tap()
        sleep(2)
        
        let finalState = likeButton.value as? String
        XCTAssertNotEqual(stateAfterFirstTap, finalState, "Состояние кнопки не изменилось после второго нажатия")
        
        cell.tap()
        sleep(2)
        
        let image = app.scrollViews.images.firstMatch
        XCTAssertTrue(image.exists, "Изображение не найдено в детальном просмотре")
        
        image.pinch(withScale: 3, velocity: 1) // zoom in
        sleep(1)
        image.pinch(withScale: 0.5, velocity: -1) // zoom out
        sleep(1)
        
        app.buttons["BackButton"].tap()
        sleep(1)
        
        XCTAssertTrue(table.exists, "Не вернулись к списку изображений")
    }
    
    func testProfile() throws {
        sleep(3)
        
        let tabBar = app.tabBars["Tab Bar"]
        let tabBarButtons = tabBar.buttons
        let profileButton = tabBarButtons.element(boundBy: 1)
        
        XCTAssertTrue(profileButton.exists, "Кнопка профиля не найдена")
        profileButton.tap()
        sleep(2)
        
        let nameLabel = app.staticTexts["Islam Tagirov"]
        let usernameLabel = app.staticTexts["enccrypt"]
        
        XCTAssertTrue(nameLabel.exists, "Имя пользователя не найдено")
        XCTAssertTrue(usernameLabel.exists, "Логин пользователя не найден")
        
        let logoutButton = app.buttons["log out button"]
        XCTAssertTrue(logoutButton.exists, "Кнопка выхода не найдена")
        logoutButton.tap()
        sleep(1)
        
        let alert = app.alerts["Пока, пока!"]
        XCTAssertTrue(alert.exists, "Алерт не появился")
        
        let yesButton = alert.buttons["Да"]
        XCTAssertTrue(yesButton.exists, "Кнопка 'Да' не найдена")
        yesButton.tap()
    }
}
