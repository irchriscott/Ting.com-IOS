//
//  Constatnts.swift
//  ting
//
//  Created by Ir Christian Scott on 31/07/2019.
//  Copyright © 2019 Ir Christian Scott. All rights reserved.
//

import Foundation
import UIKit

struct Colors {
    static let colorPrimary                 = UIColor(red: 0.71, green: 0.44, blue: 0.91, alpha: 1.0)
    static let colorPrimaryDark             = UIColor(red: 0.56, green: 0.55, blue: 0.93, alpha: 1.0)
    static let colorAccent                  = UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1.0)
    static let colorVeryLightGray           = UIColor(red: 0.87, green: 0.87, blue: 0.87, alpha: 1.0)
    static let colorLightGray               = UIColor(red: 0.60, green: 0.60, blue: 0.60, alpha: 1.0)
    static let colorGray                    = UIColor(red: 0.40, green: 0.40, blue: 0.40, alpha: 1.0)
    static let colorDarkGray                = UIColor(red: 0.20, green: 0.20, blue: 0.20, alpha: 1.0)
    static let colorGoogleRedOne            = UIColor(red: 0.84, green: 0.25, blue: 0.19, alpha: 1.0)
    static let colorGoogleRedTwo            = UIColor(red: 0.71, green: 0.09, blue: 0.02, alpha: 1.0)
    static let colorTransparent             = UIColor(red: 0.70, green: 0.70, blue: 0.70, alpha: 0.7)
    static let colorClear                   = UIColor(red: 0.00, green: 0.00, blue: 0.00, alpha: 0.0)
    static let colorToastDefault            = UIColor(red: 0.62, green: 0.87, blue: 1.00, alpha: 1.0)
    static let colorToastSuccess            = UIColor(red: 0.65, green: 0.94, blue: 0.72, alpha: 1.0)
    static let colorToastWarning            = UIColor(red: 1.00, green: 0.81, blue: 0.65, alpha: 1.0)
    static let colorToastError              = UIColor(red: 1.00, green: 0.69, blue: 0.71, alpha: 1.0)
    static let colorDarkTransparent         = UIColor(red: 0.56, green: 0.55, blue: 0.93, alpha: 0.3)
    static let colorWhite                   = UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1.0)
    static let colorYellowRate              = UIColor(red: 1.00, green: 0.90, blue: 0.14, alpha: 1.0)
    static let colorStatusTimeOrange        = UIColor(red: 0.95, green: 0.44, blue: 0.11, alpha: 1.0)
    static let colorStatusTimeGreen         = UIColor(red: 0.13, green: 0.73, blue: 0.27, alpha: 1.0)
    static let colorStatusTimeRed           = UIColor(red: 0.86, green: 0.16, blue: 0.16, alpha: 1.0)
    static let colorPlacementMenuOne        = UIColor(red: 0.54, green: 0.17, blue: 0.89, alpha: 1.0)
    static let colorPlacementMenuTwo        = UIColor(red: 0.58, green: 0.00, blue: 0.83, alpha: 1.0)
    static let colorPlacementMenuThree      = UIColor(red: 0.44, green: 0.18, blue: 0.66, alpha: 1.0)
    static let colorPlacementMenuFour       = UIColor(red: 0.36, green: 0.23, blue: 0.55, alpha: 1.0)
    static let colorPlacementMenuFive       = UIColor(red: 0.47, green: 0.32, blue: 0.66, alpha: 1.0)
    static let colorPlacementMenuSix        = UIColor(red: 0.61, green: 0.32, blue: 0.71, alpha: 1.0)
}

struct Sizes {
    static let loginInputBorderRadius: CGFloat = 24.0
}

struct URLs {
    static let hostEndPoint                 = "http://192.168.1.5:8000" //ITSAppUsesNonExemptEncryption 192.168.91.1
    static let uploadEndPoint               = "http://192.168.1.5:8000/tinguploads/"
    static let endPoint                     = "http://192.168.1.5:8000/api/v1/"
    
    //SIGNUP & AUTH ROUTES
    
    static let checkEmail                   = "\(endPoint)usr/check/email-username/"
    static let emailSignup                  = "\(endPoint)usr/signup/email/"
    static let googleSignup                 = "\(endPoint)usr/signup/google/"
    static let authLoginUser                = "\(endPoint)usr/auth/login/"
    static let userResetPassword            = "\(endPoint)usr/auth/password/reset/"
    
    // UPDATE & USER DATA
    
    static let updateProfileImage           = "\(endPoint)usr/profile/image/update/"
    static let updateProfileEmail           = "\(endPoint)usr/profile/email/update/"
    static let updateProfilePassword        = "\(endPoint)usr/profile/password/update/"
    static let updateProfileIdentity        = "\(endPoint)usr/profile/identity/update/"
    static let addUserAddress               = "\(endPoint)usr/profile/address/add/"
    static let deleteUserAddress            = "\(endPoint)usr/profile/address/delete/"
    static let updateUserAddress            = "\(endPoint)usr/profile/address/update/"
    
    //RESTAURANT
    
    static let restaurantsGlobal            = "\(endPoint)usr/g/restaurants/all/"
    static let checkRestaurantReview        = "\(endPoint)usr/g/restaurants/reviews/check/"
    static let restaurantTopMenus           = "\(endPoint)usr/g/restaurants/get/%d/menus/top/"
    static let restaurantFilters            = "\(endPoint)usr/g/restaurants/filters/"
    static let restaurantSearchFiltered     = "\(endPoint)usr/g/restaurants/search/filter/"
    
    //MENU
    
    static let checkMenuReview              = "\(endPoint)usr/menu/reviews/check/"
    
    //CUISINE
    static let cuisineGlobal                = "\(endPoint)usr/g/cuisines/all/"
    static let cuisineRestaurants           = "\(endPoint)usr/g/cuisine/r/%d/?page=%d"
    static let cuisineMenus                 = "\(endPoint)usr/g/cuisine/m/%d/?page=%d"
    
    //DISCOVERY
    
    static let discoverRestaurants          = "\(endPoint)usr/d/restaurants/"
    static let discoverTopRestaurants       = "\(endPoint)usr/d/restaurants/top/"
    static let discoverTodayPromosRand      = "\(endPoint)usr/d/today/promotions/rand/"
    static let discoverTodayPromosAll       = "\(endPoint)usr/d/today/promotions/all/"
    static let discoverTopMenus             = "\(endPoint)usr/d/menus/top/"
    static let discoverMenus                = "\(endPoint)usr/d/menus/discover/"
    
    //PLACEMENT
    static let placementRequestTable        = "\(endPoint)usr/po/table/request/"
    static let getCurrentPlacement          = "\(endPoint)usr/po/placement/get/"
    static let updatePlacementPeople        = "\(endPoint)usr/po/placement/people/update/"
    static let restaurantMenusOrders        = "\(endPoint)usr/po/orders/branch/menus/?branch=%d&type=%d&page=%d&query=%@"
    static let placeOrderMenu               = "\(endPoint)usr/po/orders/menu/place/"
    static let placementOrdersMenu          = "\(endPoint)usr/po/placement/orders/all/?token=%@&page=%d&query=%@"
    static let rePlaceOrderPlacement        = "\(endPoint)usr/po/placement/order/%d/re/place/"
    static let cancelOrderPlacement         = "\(endPoint)usr/po/placement/order/%d/cancel/"
    static let placementGetBill             = "\(endPoint)usr/po/placement/bill/"
    static let placementUpdateBillTips      = "\(endPoint)usr/po/placement/bill/tips/update/"
    static let placementBillComplete        = "\(endPoint)usr/po/placement/bill/complete/"
    static let placementBillRequest         = "\(endPoint)usr/po/placement/bill/request/"
    static let placementRequestWaiter       = "\(endPoint)usr/po/placement/request/send/"
    static let placementTerminate           = "\(endPoint)usr/po/placement/terminate/"
    
    //MOMENT
    static let momentsSave                  = "\(endPoint)usr/m/moments/save/"

    //SEARCH
    static let liveSearchResults            = "\(endPoint)usr/g/search/live/"
    static let menusSearchResults           = "\(endPoint)usr/g/search/menus/"
    static let restaurantSearchResults      = "\(endPoint)usr/g/search/restaurants/"
    
}

struct StaticData {
    static let genders                      = ["Male", "Female"]
    static let addressTypes                 = ["Home", "Work", "School", "Other"]
    static let googleClientID               = "1033794072902-espnuj5ort5627uv0mun7ih2lndv17lc.apps.googleusercontent.com"
    static let googleMapsKey                = "AIzaSyD2mLGusTJZqu7zesBgobnoVIzN6hIayvk"
    
    static let PUBNUB_SUBSCRIBE_KEY         = "sub-c-6597d23e-1b1d-11ea-b79a-866798696d74"
    static let PUBNUB_PUBLISH_KEY           = "pub-c-62f722d6-c307-4dd9-89dc-e598a9164424"
    static let PUSH_NOTIFICATION_KEY        = "f47c28dd-63ae-49c0-9f30-88560b21e061"
}

struct Socket {
    static let SOCKET_REQUEST_RESTO_TABLE           = "request_resto_table"
    static let SOCKET_REQUEST_ASSIGN_WAITER         = "request_assign_waiter"
    static let SOCKET_REQUEST_NOTIFY_ORDER          = "request_notify_order"
    static let SOCKET_REQUEST_W_NOTIFY_ORDER        = "request_w_notify_order"

    static let SOCKET_RESPONSE_ERROR                = "response_error"
    static let SOCKET_RESPONSE_PLACEMENT_DONE       = "response_resto_placement_done"
    static let SOCKET_RESPONSE_TABLE_WAITER         = "response_resto_table_waiter"
    static let SOCKET_RESPONSE_RESTO_TABLE          = "response_resto_table"
    static let SOCKET_RESPONSE_RESTO_BILL_PAID      = "response_resto_bill_paid"
}

struct Base64ImageData {
    static let `default`                    = "iVBORw0KGgoAAAANSUhEUgAAAEAAAABACAMAAACdt4HsAAAAflBMVEUAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACCtoPsAAAAKXRSTlMA6PsIvDob+OapavVhWRYPrIry2MxGQ97czsOzpJaMcE0qJQOwVtKjfxCVFeIAAAI3SURBVFjDlJPZsoIwEETnCiGyb8q+qmjl/3/wFmGKwjBROS9QWbtnOqDDGPq4MdMkSc0m7gcDDhF4NRdv8NoL4EcMpzoJglPl/KTDz4WW3IdvXEvxkfIKn7BMZb1bFK4yZFqghZ03jk0nG8N5NBwzx9xU5cxAg8fXi20/hDdC316lcA8o7t16eRuQvW1XGd2d2P8QSHQDDbdIII/9CR3lUF+lbucfJy4WfMS64EJPORnrZxtfc2pjJdnbuags3l04TTtJMXrdTph4Pyg4XAjugAJqMDf5Rf+oXx2/qi4u6nipakIi7CsgiuMSEF9IGKg8heQJKkxIfFSUU/egWSwNrS1fPDtLfon8sZOcYUQml1Qv9a3kfwsEUyJEMgFBKzdV8o3Iw9yAjg1jdLQCV4qbd3no8yD2GugaC3oMbF0NYHCpJYSDhNI5N2DAWB4F4z9Aj/04Cna/x7eVAQ17vRjQZPh+G/kddYv0h49yY4NWNDWMMOMUIRYvlTECmrN8pUAjo5RCMn8KoPmbJ/+Appgnk//Sy90GYBCGgm7IAskQ7D9hFKW4ApB1ei3FSYD9PjGAKygAV+ARFYBH5BsVgG9kkBSAQWKUFYBRZpkUgGVinRWAdUZQDABBQdIcAElDVBUAUUXWHQBZx1gMAGMprM0AsLbVXHsA5trZe93/wp3svQ0YNb/jWV3AIOLsMtlznSNOH7JqjOpDVh7z8qCZR10ftvO4nxeOvPLkpSuvfXnxzKtvXr7j+v8C5ii0e71At7cAAAAASUVORK5CYII="
    static let success                      = "iVBORw0KGgoAAAANSUhEUgAAAEAAAABABAMAAABYR2ztAAAAIVBMVEUAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABt0UjBAAAACnRSTlMApAPhIFn82wgGv8mVtwAAAKVJREFUSMft0LEJAkEARNFFFEw1NFJb8CKjAy1AEOzAxNw+bEEEg6nyFjbY4LOzcBwX7S/gwUxoTdIn+Jbv4Lv8bx446+kB6VsBtK0B+wbMCKxrwL33wOrVeeChX28n7KTOTjgoEu6DRSYAgAAAAkAmAIAAAAIACQIkMkACAAgAIACAyECBKAOJuCagTJwSUCaUAEMAABEBRwAAEQFLbCJgO4bW+AZKGnktR+jAFAAAAABJRU5ErkJggg=="
    static let warning                      = "iVBORw0KGgoAAAANSUhEUgAAAEQAAABECAMAAAAPzWOAAAAAkFBMVEUAAAAAAAABAAIAAAABAAIAAAMAAAABAAIBAAIBAAIAAAIAAAABAAIAAAABAAICAAICAAIAAAIAAAAAAAAAAAABAAIBAAIAAAMAAAABAAIBAAMBAAECAAIAAAIAAAIAAAABAAIBAAIBAAMBAAIBAAEAAAIAAAMAAAAAAAABAAECAAICAAIAAAIAAAMAAAQAAAE05yNAAAAAL3RSTlMAB+kD7V8Q+PXicwv7I9iYhkAzJxnx01IV5cmnk2xmHfzexsK4eEw5L7Gei39aRw640awAAAHQSURBVFjD7ZfJdoJAEEWJgCiI4oDiPM8m7///LidErRO7sHrY5u7YXLr7vKqu9kTC0HPmo9n8cJbEQOzqqAdAUHeUZACQuTkGDQBoDJwkHZR0XBz9FkpafXuHP0SJ09mGeJLZ5wwlTmcbA0THPmdEK7XPGTG1zxmInn3OiJ19zkB0jSVTKExMHT0wjAwlWzC0fSPHF1gWRpIhWMYm7fYTFcQGlbemf4dFfdTGg0B/KXM8qBU/3wntbq7rSGqvJ9kla6IpueFJet8fxfem5yhykjyOgNaWF1qSGd5JMNNxpNF7SZQaVh5JzLrTCZIEJ1GyEyVyd+pClMjdaSJK5O40giSRu5PfFiVyd1pAksjdKRnrSsbVdbiHrgT7yss315fkVQPLFQrL+4FHeOXKO5YRFEKv5AiFaMlKLlBpJuVCJlC5sJfvCgztru/3NmBYccPgGTxRAzxn1XGEMUf58pXZvjoOsOCgjL08+b53mtfAM/SVsZcjKLtysQZPqIy9HPP3m/3zKItRwT0LyQo8sTr26tcO83DIUMWIJjierHLsJda/tbNBFY0BP/bKtcM8HNIWCK3aYR4OMzgxo5w5EFLOLKDExXAm9gI4E3iAO94/Ct/lKWuM2LMGbgAAAABJRU5ErkJggg=="
    static let error                        = "iVBORw0KGgoAAAANSUhEUgAAAEAAAABACAMAAACdt4HsAAAAeFBMVEUAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAVyEiIAAAAJ3RSTlMA3BsB98QV8uSyWVUFz7+kcWMM2LuZioBpTUVBNcq2qaibj4d1azLZZYABAAACZElEQVRYw7WX25KCMAyGAxUoFDkpiohnV97/DXeGBtoOUprZ2dyo1K82fxKbwJJVp+KQZ7so2mX5oThVQLKwjDe9YZu4DF3ptAn6rxY0qQPOEq9fNC9ha3y77a22ba24v+9Xbe8v8x03dPOC2/NdvB6xeSreLfGJpnx0TyotKqLm2s7Jd/WO6ivXNp0tCy02R/aFz5VQ5wUPlUL5fIfj5KIlVGU0nWHm/5QtoTVMWY8mzIVu1K9O7XH2JiU/xnOOT39gnUfj+lFHddx4tFjL3/H8jjzaFCy2Rf0c/fdQyQszI8BDR973IyMSKa4krjxAiW/lkRvMP+bKK9WbYS1ASQg8dKjaUGlYPwRe/WoIkz8tiQchH5QAEMv6T0k8MD4mUyWr4E7jAWqZ+xWcMIYkXvlwggJ3IvFK+wIOcpXAo8n8P0COAaXyKH4OsjBuZB4ew0IGu+H1SebhNazsQBbWm8yj+hFuUJB5eMsN0IUXmYendAFFfJB5uEkRMYwxmcd6zDGRtmQePEykAgubymMRFmMxCSIPCRbTuFNN5OGORTjmNGc0Po0m8Uv0gcCry6xUhR2QeLii9tofbEfhz/qvNti+OfPqNm2Mq6105FUMvdT4GPmufMiV8PqBMkc+DdT1bjYYbjzU/ew23VP4n3mLAz4n8Jtv/Ui3ceTT2mzz5o1mZt0gnBpmsdjqRqVlmplcPdqa7X23kL9brdm2t/uBYDPn2+tyu48mtIGD10JTuUrukVrbCFiwDzcHrPjxKt7PW+AZQyT/WESO+1WL7f3o+WLHL2dYMSZsg6dg/z360ofvP4//v1NPzgs28WlWAAAAAElFTkSuQmCC"
}
