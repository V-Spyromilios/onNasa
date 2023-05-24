//
//  Mission Manifest Model.swift
//  onNasa
//
//  Created by Evangelos Spyromilios on 04.05.23.
//

import Foundation

struct MissionManifest: Decodable {
	
	let manifest: Manifest

	enum CodingKeys: String, CodingKey {

		case manifest = "photo_manifest"
	}

	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		self.manifest = try container.decode(Manifest.self, forKey: .manifest)
	}

}

struct Manifest: Decodable {

	let name: String
	let launchingDate: String?
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

		self.launchingDate = try container.decode(String.self, forKey: .launchingDate)
		self.totalPhotos = try container.decode(Int.self, forKey: .totalPhotos)
		self.landingDate = try container.decode(String.self, forKey: .landingDate)
		self.totalSols = try container.decode(Int.self, forKey: .totalSols)
		self.maxDate = try container.decode(String.self, forKey: .maxDate)
		self.status = try container.decode(String.self, forKey: .status)
		self.name = try container.decode(String.self, forKey: .name)
	}
}

// {
//	"photo_manifest": {
//		"name": "Perseverance",
//		"landing_date": "2021-02-18",
//		"launch_date": "2020-07-30",
//		"status": "active",
//		"max_sol": 786,
//		"max_date": "2023-05-06",
//		"total_photos": 154207,
//		"photos": [
//			{
//				"sol": 0,
//				"earth_date": "2021-02-18",
//				"total_photos": 54,
//				"cameras": [
//					"EDL_DDCAM",
//					"FRONT_HAZCAM_LEFT_A",
//					"FRONT_HAZCAM_RIGHT_A",
//					"REAR_HAZCAM_LEFT",
//					"REAR_HAZCAM_RIGHT"
//				]
//			},
//			....
