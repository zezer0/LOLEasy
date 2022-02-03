//
//  RiotAPIDataSource.swift
//  LOLEasy
//
//  Created by 재영신 on 2022/01/26.
//

import Foundation
import RxSwift
import Alamofire



protocol RiotAPIDataSource {
    func fetchSummoner(id: String) -> Observable<Result<
        SummonerResponseDTO,URLError>>
    func fetchLeagueEntry(id: String) -> Observable<Result<
        [LeagueEntryResponseDTO],URLError>>
//    func fetchSummonerIcon(iconId: Int) -> Single<Data>
}

final class DefaultRiotAPIDataSource: RiotAPIDataSource {
    private let session: URLSession
    private let riotAPI: RiotAPI
    private let headers: HTTPHeaders = [
        "Content-Type":"application/json;charset=utf-8",
        "Accept-Language": "ko-KR,ko;q=0.9,en-US;q=0.8,en;q=0.7,zh-CN;q=0.6,zh;q=0.5",
        "Origin": "https://developer.riotgames.com"
    ]
    
    init(
        session: URLSession = .shared,
        riotAPI: RiotAPI = RiotAPI()
    ) {
        self.session = session
        self.riotAPI = riotAPI
    }
    func fetchSummoner(id: String) -> Observable<Result<
        SummonerResponseDTO,URLError>> {
            guard let url = self.riotAPI.getSummonerV4URL(id: id).url else {
                return .just(.failure(URLError(.badURL)))
            }
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            return self.session.rx.data(request: request)
                .map {
                    data in
                    print(data)
                    do {
                        let summonerResponseDTO = try JSONDecoder().decode(SummonerResponseDTO.self, from: data)
                        
                        return .success(summonerResponseDTO)
                    } catch {
                        return .failure(URLError(.cannotParseResponse))
                    }
                }
                .catch{ _ in .just(Result.failure(URLError(.cannotLoadFromNetwork)))}
            
    }
    
    func fetchLeagueEntry(id: String) -> Observable<Result<
        [LeagueEntryResponseDTO],URLError>> {
            guard let url = self.riotAPI.getLeagueV4URL(id: id).url else {
                return .just(.failure(URLError(.badURL)))
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            
            return self.session.rx.data(request: request)
                .map { data in
                    do {
                        let leagueEntryResponseDTOs = try JSONDecoder().decode([LeagueEntryResponseDTO].self, from: data)
                        return .success(leagueEntryResponseDTOs)
                    } catch {
                        return .failure(URLError(.cannotParseResponse))
                    }
                }.catch{ _ in .just(.failure(URLError(.cannotLoadFromNetwork)))}
    }
}