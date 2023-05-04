//
//  Mission Manifest Model.swift
//  onNasa
//
//  Created by Evangelos Spyromilios on 04.05.23.
//

import Foundation

struct MissionManifest: Decodable {

	let name: String
	let launchingDate: String
	let landingDate: String
	let status: String
	let totalSols: Int
	let maxDate: String
	let totalPhotos: Int

	enum CodingKeys: String, CodingKey {

		case name
		case status
		case launchingDate = "launch_date"
		case landingDate =  "landing_date"
		case totalSols = "max_sol"
		case maxDate = "max_date"
		case totalPhotos = "total_photos"
	}

	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)

		self.name = try container.decode(String.self, forKey: .name)
		self.launchingDate = try container.decode(String.self, forKey: .landingDate)
		self.landingDate = try container.decode(String.self, forKey: .landingDate)
		self.totalSols = try container.decode(Int.self, forKey: .totalSols)
		self.maxDate = try container.decode(String.self, forKey: .maxDate)
		self.totalPhotos = try container.decode(Int.self, forKey: .totalPhotos)
		self.status = try container.decode(String.self, forKey: .status)
	}
}
