//
//  DataModel.swift
//  GimpoPayMarket
//
//  Created by rae on 2021/04/20.
//

struct DataModel: Codable {
    let regionMnyFacltStus: [RegionMnyFacltStus]
    
    enum CodingKeys: String, CodingKey {
        case regionMnyFacltStus = "RegionMnyFacltStus"
    }
}

struct RegionMnyFacltStus: Codable {
    let head: [Head]?
    let row: [Row]?
}

struct Head: Codable {
    let listTotalCount: Int?
    let result: Result?
    let apiVersion: String?
    
    enum CodingKeys: String, CodingKey {
        case listTotalCount = "list_total_count"
        case result = "RESULT"
        case apiVersion = "api_version"
    }
}

struct Result: Codable {
    let code: String?
    let message: String?
    
    enum CodingKeys: String, CodingKey {
        case code = "CODE"
        case message = "MESSAGE"
    }
}

struct Row: Codable {
    let sigunCD: String?
    let sigunNM: String?
    let cmpnmNM: String?
    let indutypeNM: String?
    let refineRoadnmAddr: String?
    let refineLotnoAddr: String?
    let refineZipCd: String?
    let refineWgs84Lat: String?
    let refineWgs84Logt: String?
    let dataStdDe: String?
    
    enum CodingKeys: String, CodingKey {
        case sigunCD = "SIGUN_CD"
        case sigunNM = "SIGUN_NM"
        case cmpnmNM = "CMPNM_NM"
        case indutypeNM = "INDUTYPE_NM"
        case refineRoadnmAddr = "REFINE_ROADNM_ADDR"
        case refineLotnoAddr = "REFINE_LOTNO_ADDR"
        case refineZipCd = "REFINE_ZIP_CD"
        case refineWgs84Lat = "REFINE_WGS84_LAT"
        case refineWgs84Logt = "REFINE_WGS84_LOGT"
        case dataStdDe = "DATA_STD_DE"
    }
}
