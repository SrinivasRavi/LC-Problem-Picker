import SwiftUI

struct ContentView: View {
    @State private var randomNumber: Int?
    @State private var selectedDifficulty: Difficulty = .easy
    @State private var completedNumbers: Set<Int> = UserDefaults.standard.object(forKey: "completedNumbers") as? Set<Int> ?? []

    let easyNumbers = [88, 27, 26, 169, 121, 13, 58, 14, 28, 125, 392, 383, 205, 290, 242, 1, 202, 219, 228, 20, 141, 21, 104, 100, 226, 101, 112, 222, 637, 530, 108, 35, 67, 190, 191, 136, 9, 66, 69, 70]
    let mediumNumbers = [80, 189, 122, 55, 45, 274, 380, 238, 134, 12, 151, 6, 167, 11, 15, 209, 3, 36, 54, 48, 73, 289, 49, 128, 56, 57, 452, 71, 155, 150, 2, 138, 92, 19, 82, 61, 86, 146, 105, 106, 117, 114, 129, 173, 236, 199, 102, 103, 230, 98, 200, 130, 133, 399, 207, 210, 909, 433, 208, 211, 17, 77, 46, 39, 22, 79, 148, 427, 53, 918, 74, 162, 33, 34, 153, 215, 373, 137, 201, 172, 50, 198, 139, 322, 300, 120, 64, 63, 5, 97, 72, 221]
    let hardNumbers = [135, 42, 68, 30, 76, 224, 25, 124, 127, 212, 52, 23, 4, 502, 295, 149, 123, 188]
    
    enum Difficulty: String, CaseIterable, Identifiable {
        case easy = "🟢 Easy"
        case medium = "🟡 Medium"
        case hard = "🔴 Hard"
        case random = "🌈 Random"
        
        var id: String { self.rawValue }
    }
    
    var body: some View {
        VStack {
            Text("LC Problem Picker")
                .font(.largeTitle)
                .padding(.top)
            
            Spacer()
            
            VStack {
                Text("Leetcode problem mumber")
                    .font(.title2)
                
                Text(randomNumber.map(String.init) ?? "None")
                    .font(.system(size: 100))
                    .bold()
                    .padding()
            }
            .frame(maxHeight: .infinity)
            
            Spacer()
            
            Picker("Select Difficulty", selection: $selectedDifficulty) {
                ForEach(Difficulty.allCases) { difficulty in
                    Text(difficulty.rawValue).tag(difficulty)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            VStack {
                if let number = randomNumber {
                    Button(action: {
                        markNumberAsDone(number)
                    }) {
                        Text("Mark as Done")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                
                Button(action: generateRandomNumber) {
                    Text("Pick a problem")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                Button(action: resetCompletedNumbers) {
                    Text("Reset")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .padding([.leading, .trailing, .bottom])
        }
        .padding()
        .onAppear(perform: loadCompletedNumbers)
    }
    
    func generateRandomNumber() {
        var availableNumbers: [Int]
        switch selectedDifficulty {
        case .easy:
            availableNumbers = easyNumbers.filter { !completedNumbers.contains($0) }
        case .medium:
            availableNumbers = mediumNumbers.filter { !completedNumbers.contains($0) }
        case .hard:
            availableNumbers = hardNumbers.filter { !completedNumbers.contains($0) }
        case .random:
            let allNumbers = easyNumbers + mediumNumbers + hardNumbers
            availableNumbers = allNumbers.filter { !completedNumbers.contains($0) }
        }
        
        if availableNumbers.isEmpty {
            randomNumber = nil
        } else {
            randomNumber = availableNumbers.randomElement()
        }
    }
    
    func markNumberAsDone(_ number: Int) {
        completedNumbers.insert(number)
        saveCompletedNumbers()
        generateRandomNumber()
    }
    
    func resetCompletedNumbers() {
        completedNumbers.removeAll()
        saveCompletedNumbers()
    }
    
    func saveCompletedNumbers() {
        UserDefaults.standard.set(Array(completedNumbers), forKey: "completedNumbers")
    }
    
    func loadCompletedNumbers() {
        if let savedNumbers = UserDefaults.standard.array(forKey: "completedNumbers") as? [Int] {
            completedNumbers = Set(savedNumbers)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
