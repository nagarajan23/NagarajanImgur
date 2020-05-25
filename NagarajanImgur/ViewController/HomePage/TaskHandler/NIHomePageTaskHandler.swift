//
//  NIHomePageTaskHandler.swift
//  NagarajanImgur
//
//  Created by Nagarajan S D on 19/04/20.
//  Copyright © 2020 Nagarajan. All rights reserved.
//

import Foundation

class NIHomePageTaskHandler {
    //MARK:- Properties
    var fetching: Box<Bool?> = Box(nil)
    var memeModels: Box<[NIGallaryMemeModel]> = Box([NIGallaryMemeModel]())
    var accountData: Box<NIAccountData?> = Box(nil)
    var errorMessage: Box<String?> = Box(nil)
}

//MARK:- Fetch Data
extension NIHomePageTaskHandler {
    func fetchData() {
        self.fetchAccountInfo()
        self.fetchMostViralMemes()
    }
    
    func fetchDataOnPullDownRefresh() {
        if let fetching = self.fetching.value, fetching != true {
            self.fetchData()
        }
    }
}

//MARK:- Fetching Account Info
extension NIHomePageTaskHandler: NIKeyChainProtocol {
    func fetchAccountInfo() {
        let urlString = baseURL + "account/me"
        NIAccountNetworkService.fetchAccountInfo(usingUrlString: urlString) {[weak self] (responseString, errorMessage) in
            if (errorMessage.isEmpty) {
                self?.computeAccountInfo(responseString: responseString)
            } else {
                self?.errorMessage.value = errorMessage
            }
        }
    }
    
    private func computeAccountInfo(responseString: String) {
        if !responseString.isEmpty, let data = responseString.data(using: .utf8) {
            do {
                let accountInfo = try JSONDecoder().decode(NIAccountInfo.self, from: data)
                self.accountData.value = accountInfo.data
            } catch {
                self.errorMessage.value = "Something went wrong"
            }
        }
    }
}

//MARK:- Fetching Viral Memes
extension NIHomePageTaskHandler {
    func fetchMostViralMemes() {
        let params = self.getGallaryFetchParams()
        let urlString = baseURL + "gallery/hot/time/0"
        self.fetching.value = true
        NIGallaryNetworkService.fetchGallary(usingUrlString: urlString, parameters: params) {[weak self] (responseString, errorMessage) in
            self?.fetching.value = false
            if (errorMessage.isEmpty) {
                self?.computeMostViralMemes(responseString)
            } else {
                self?.errorMessage.value = errorMessage
            }
        }
    }
    
    private func getGallaryFetchParams() -> [String: Any] {
        let params = ["showViral": "true", "realtimeResults": "false"]
        return params
    }
    
    private func computeMostViralMemes(_ responseString: String) {
        if !responseString.isEmpty, let data = responseString.data(using: .utf8) {
            do {
                let gallary = try JSONDecoder().decode(NIGallaryModel.self, from: data)
                self.memeModels.value = gallary.data
            } catch {
                self.errorMessage.value = "Something went wrong"
            }
        }
    }
}
