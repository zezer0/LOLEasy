//
//  DefaulutSummonerRepository.swift
//  LOLEasy
//
//  Created by 재영신 on 2022/01/26.
//

import Foundation
import RxSwift

final class DefaultSummonerRepository: SummonerRepository {
    private let riotAPIDataSource: RiotAPIDataSource
    
    init(riotAPIDataSource: RiotAPIDataSource) {
        self.riotAPIDataSource = riotAPIDataSource
    }
    func fetchSummoner(id: String) -> Single<Summoner> {
        self.riotAPIDataSource.fetchSummoner(id: id)
            .map{ $0.toDomain() }
    }
}