//
//  ContentView.swift
//  Shared
//
//  Created by Игорь Простов on 28.10.2021.
//

import SwiftUI

func sendDataToDevice(typeOfDevice : Int, frequency : String, hostname : String, ecdsaCert : String, ecdsaKey : String, caCert : String, bandwidth : String, sf : String, power : String, loraKey : String) {
	print("BODY AFTER SAVE BUTTON")
	//print(typeOfDevice, frequency)

	
	let body = "hostname '" + hostname + "'" +
	"\n!" +
 "\ntimestamp " + String(Int(ceil(Date().timeIntervalSince1970))) +
 "\n!" +
 "\ndev_type " + String(typeOfDevice) +
 "\n!" +
 "\necdsa_cert '" + ecdsaCert + "'" +
 "\n!" +
 "\necdsa_key '" + ecdsaKey + "'" +
 "\n!" +
 "\n!" +
 "\nroot_cert '" + caCert + "'" +
 "\n!" +
 "\n!" +
 "\nlora_frequency " + frequency.replacingOccurrences(of: " МГц", with: "", options: .literal, range: nil) +
 "\nlora_bandwidth " + bandwidth.replacingOccurrences(of: " Гц", with: "", options: .literal, range: nil) +
 "\nlora_sf " + String(sf) +
 "\nlora_tx_power " + String(power) +
 "\nlora_encryption_key '" + String(loraKey) + "'"
	//print(body)

	

	let url = URL(string: "http://192.168.4.1/set_config")!
	var request = URLRequest(url: url)
	//Change the URLRequest to a POST request
	request.httpMethod = "POST"
	request.httpBody = Data(bytes: body, count: body.count)
	let session = URLSession.shared
	let task = session.dataTask(with: request) { (data, response, error) in
		print("SENDING...")
		if let error = error {
			print("GOT ERROR")
			print(error)
		} else if let data = data {
			print("GOT DATA")
			print(data)
		} else {
			print("GOT unexpected error")
		}
		//print("RESPONSE:")
		//print(response)
	}

	task.resume()
	
}

func sendBlocksToDevice(signaturesListBytes : [UInt8]) {
	
	let url_set_blocks = URL(string: "http://192.168.4.1/set_blocks")!
	var request_set_blocks = URLRequest(url: url_set_blocks)
	//Change the URLRequest to a POST request
	request_set_blocks.httpMethod = "POST"
	request_set_blocks.httpBody = Data(bytes: signaturesListBytes, count: signaturesListBytes.count)
	let session_set_blocks = URLSession.shared
	let task_set_blocks = session_set_blocks.dataTask(with: request_set_blocks) { (data, response, error) in
		print("SENDING BLOCKS...")
		if let error = error {
			print("GOT ERROR")
			print(error)
		} else if let data = data {
			print("GOT DATA")
			print(data)
		} else {
			print("GOT unexpected error")
		}
		//print("RESPONSE:")
		//print(response)
	}
	task_set_blocks.resume()
	
}


func sendDevicesToDevice(devicesListBytes : [UInt8]) {
	
	
	
	let url_set_devices = URL(string: "http://192.168.4.1/set_devices")!
	var request_set_devices = URLRequest(url: url_set_devices)
	//Change the URLRequest to a POST request
	request_set_devices.httpMethod = "POST"
	request_set_devices.httpBody = Data(bytes: devicesListBytes, count: devicesListBytes.count)
	let session_set_devices = URLSession.shared
	let task_set_devices = session_set_devices.dataTask(with: request_set_devices) { (data, response, error) in
		print("SENDING DEVICES...")
		if let error = error {
			print("GOT ERROR")
			print(error)
		} else if let data = data {
			print("GOT DATA")
			print(data)
		} else {
			print("GOT unexpected error")
		}
		//print("RESPONSE:")
		//print(response)
	}
	task_set_devices.resume()
}
struct ContentView: View {
	
	@State var typeOfDeviceIndex = 0
	@State var frequencyIndex = "443 МГц"
	@State var bandwidthIndex = "125 Гц"
	@State var sfsIndex = "7"
	@State var txIndex = "1"
	@State var deviceName: String = ""
	
	@State private var openCAFile: Bool = false
	@State var caFileContents = ""

	@State private var openKeyFile: Bool = false
	@State var keyFileContents = ""
	
	@State private var openCertFile: Bool = false
	@State var certFileContents = ""
	
	@State var deviceListContents = [UInt8]()
	
	@State var blocksListContents = [UInt8]()
	
	
	@State var loraPassword = ""
	@State var selectingFile = ""
	@State var isOnToggle = false
	var typesOfDevices = ["Детектор газа", "Детектор шума", "Метеодатчик"]
	var frequencies = ["443 МГц", "444 МГц", "445 МГц"]
	var bandwidths = ["125 Гц", "250 Гц", "500 Гц"]
	var sfs = ["7", "8", "9", "10","11","12"]
	var TXs = ["1","2","3","4","5", "6","7", "8", "9", "10"]
	var body: some View {
		NavigationView {
			Form(content:{
				Section(header: Text("Data transmittion settings")) {
					TextField("Hostname", text: $deviceName)
					
					TextField("LoRa password", text: $loraPassword )
					
					Picker(selection: $typeOfDeviceIndex, label: Text("Device type")){
						ForEach(0..<typesOfDevices.count){
							Text(self.typesOfDevices[$0]).tag(self.typesOfDevices[$0])
						}
					}
					
					VStack {
						Text("Frequency")
						Picker(selection: $frequencyIndex, label: Text("")){
							ForEach(0..<frequencies.count){
								Text(self.frequencies[$0]).tag(self.frequencies[$0])
							}
						}.pickerStyle(SegmentedPickerStyle())
						
					}
					
					VStack {
						Text("Bandwidth")
						Picker(selection: $bandwidthIndex, label: Text("")){
							ForEach(bandwidths, id: \.self){bandwidth in
								Text(bandwidth).tag(bandwidth)
							}
						}.pickerStyle(SegmentedPickerStyle())
						
					}
					
					VStack {
						Text("Spreading Factor")
						Picker(selection: $sfsIndex, label: Text("")){
							ForEach(sfs, id: \.self){ sf in
								Text(sf).tag(sf)
							}
						}.pickerStyle(SegmentedPickerStyle())
						
					}
					
					VStack {
						Text("Signal power")
						Picker(selection: $txIndex, label: Text("")){
							ForEach(TXs, id: \.self){ TX in
								Text(TX).tag(TX)
							}
						}.pickerStyle(WheelPickerStyle())
						
					}
					
				}
				
				Section(header: Text("Digital signature settings")) {
					
					Button(action: {selectingFile = "key"; openCertFile.toggle()}, label: {
						Text("Open ECDSA key file")
					})
					
					
					Button(action: {selectingFile = "cert"; openCertFile.toggle()}, label: {
						Text("Open ECDSA certificate file")
					})
					
					Button(action: {selectingFile = "ca"; openCertFile.toggle()}, label: {
						Text("Open CA certificate file")
					})
					
				}
				
				Section(header: Text("Входные данные реестра")) {
					
					Button(action: {selectingFile = "blockslist"; openCertFile.toggle()}, label: {
						Text("Список подписей последних блоков")
					})
					
					
					Button(action: {selectingFile = "deviceslist"; openCertFile.toggle()}, label: {
						Text("Список устройств в сети")
					})
					
					
				}
				
				Button(action: {
					sendDataToDevice(typeOfDevice: typeOfDeviceIndex, frequency: frequencyIndex, hostname: deviceName, ecdsaCert: certFileContents, ecdsaKey: keyFileContents, caCert: caFileContents, bandwidth: bandwidthIndex, sf: sfsIndex, power: txIndex, loraKey: loraPassword);
					
					DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
						print("WAIT 3 seconds after cfg")
						sendBlocksToDevice(signaturesListBytes: blocksListContents)
					}
					
					
					DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
						
						print("WAIT 5 seconds after blocks")
						
						sendDevicesToDevice(devicesListBytes: deviceListContents);
					}
					
					}, label: {
					Text("Save")
				})
				
			}).navigationBarTitle("Settings")
			
		}.navigationViewStyle(StackNavigationViewStyle())
			.fileImporter(isPresented: $openCertFile, allowedContentTypes: [.item]){
				res in
				if case .success = res {
					do {
						openCertFile.toggle()
						let fileURL = try res.get()
						//print(fileURL)
						if fileURL.startAccessingSecurityScopedResource() {
							let docData  = try Data(contentsOf:fileURL)
							print("READING CERT",docData)
							switch selectingFile{
							case "ca":
								caFileContents = String(data: docData, encoding: .utf8) ?? ""
							case "cert":
								certFileContents = String(data: docData, encoding: .utf8) ?? ""
							case "key":
								keyFileContents = String(data: docData, encoding: .utf8) ?? ""
							case "deviceslist":
								deviceListContents = [UInt8](docData)
							case "blockslist":
								blocksListContents = [UInt8](docData)
							default:
								print("WHAT ARE YOU SELECTING")
							}
							
						}
						
					}
					catch{
						openCertFile.toggle()
						print("ERROR")
						print(error.localizedDescription)
						
					}}
				else{
					openCertFile.toggle()
					print("ERROR")
				}
				openCertFile.toggle()
			}
			/*.fileImporter(isPresented: $openCAFile, allowedContentTypes: [.item]){
				res in
				if case .success = res {
					do {
						openCAFile.toggle()
						let fileURL = try res.get()
						//print(fileURL)
						if fileURL.startAccessingSecurityScopedResource() {
							let docData  = try Data(contentsOf:fileURL)
							print("READING CA CERT", docData.self)
							caFileContents = String(data: docData, encoding: .utf8) ?? ""

						}
					}
					catch{
						openCAFile.toggle()
						print("ERROR")
						print(error.localizedDescription)
						
					}}
				else{
					openCAFile.toggle()
					print("ERROR")
				}
				openCAFile.toggle()
			}

			.fileImporter(isPresented: $openKeyFile, allowedContentTypes: [.item]){
				res in
				if case .success = res {
					do {
						openKeyFile.toggle()
						let fileURL = try res.get()
						//print(fileURL)
						if fileURL.startAccessingSecurityScopedResource() {
							let docData  = try Data(contentsOf:fileURL)
							print("READING CA CERT", docData.self)
							keyFileContents = String(data: docData, encoding: .utf8) ?? ""

						}
					}
					catch{
						openKeyFile.toggle()
						print("ERROR")
						print(error.localizedDescription)
						
					}}
				else{
					openKeyFile.toggle()
					print("ERROR")
				}
				openKeyFile.toggle()
			}*/

		
		
	}
}
struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
			.previewInterfaceOrientation(.portrait)
	}
}
