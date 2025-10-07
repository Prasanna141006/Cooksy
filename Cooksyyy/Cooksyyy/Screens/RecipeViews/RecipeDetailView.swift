import SwiftUI
import Combine

struct RecipeDetailView: View {

    let recipe: Recipe
    @State private var badgeView = BadgeView(iconName: "", text: "")
    @State private var selectedSegment: Int = 0
    @State private var checkedIngredients: [Bool]
    @State private var stepTimers: [Int: Int] = [:]
    @State private var stepRunning: [Int: Bool] = [:]
    @State private var timerSubscriptions: [Int: AnyCancellable] = [:]
    
    init(recipe: Recipe) {
        self.recipe = recipe
        _checkedIngredients = State(initialValue: Array(repeating: false, count: recipe.ingredients.count))
    }
    
    var body: some View {
        ZStack {
            LinearGradient(
                       gradient: Gradient(colors: [
                           Color.orange.opacity(0.2),  // very light orange
                           Color.orange.opacity(0.05) // even lighter towards the end
                       ]),
                       startPoint: .topLeading,
                       endPoint: .bottomTrailing
                   )
                .edgesIgnoringSafeArea(.all)

            ScrollView {
                VStack(spacing: 0) {
                    Spacer().frame(height: 100)
                    
                    ZStack(alignment: .top) {

                        // Main Card
                        VStack(spacing: 16) {
                            Spacer().frame(height: 80)
                            
                            VStack(alignment: .leading, spacing: 12) {
                                // Recipe Name and Author
                                Text(recipe.name)
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.black)
                                    .lineLimit(2)
                                    .fixedSize(horizontal: false, vertical: true)
                                

                                
                                // Badges
                                HStack(spacing: 12) {
                                    BadgeView(iconName: "person.2.fill", text: "\(recipe.servings) ")
                                    BadgeView(iconName: "clock.fill", text: "\(recipe.prepTimeMinutes + recipe.cookTimeMinutes) mins")
                                    BadgeView(iconName: "flame.fill", text: "\(recipe.caloriesPerServing) cal")
                                    BadgeView(iconName: "star.fill", text: String(format: "%.1f", recipe.rating))
                                }
                            }
                            .padding(.horizontal, 24)
                            
                            // Picker
                            Picker("", selection: $selectedSegment) {
                                Text("Ingredients").tag(0)
                                Text("Directions").tag(1)
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            .padding(.horizontal, 24)
                            .padding(.top, 8)
                            .padding(.bottom, 4)
                            
                            // Content
                            if selectedSegment == 0 {
                                VStack(spacing: 12) {
                                    ForEach(Array(recipe.ingredients.enumerated()), id: \.offset) { idx, ingredient in
                                        IngredientRow(ingredient: ingredient, isChecked: checkedIngredients[idx]) {
                                            checkedIngredients[idx].toggle()
                                        }
                                    }
                                }
                                .padding(.horizontal, 24)
                                .padding(.bottom, 24)
                            } else {
                                VStack(spacing: 20) {
                                    ForEach(Array(recipe.instructions.enumerated()), id: \.offset) { idx, step in
                                        DirectionStepRow(
                                            stepNumber: idx + 1,
                                            description: step,
                                            elapsedSeconds: stepTimers[idx] ?? 0,
                                            isRunning: stepRunning[idx] ?? false,
                                            toggleTimer: {
                                                toggleTimer(for: idx)
                                            }
                                        )
                                    }
                                }
                                .padding(.horizontal, 24)
                                .padding(.bottom, 24)
                            }
                        }
                        .background(Color.white)
                        .cornerRadius(24)
                        .shadow(color: Color.black.opacity(0.12), radius: 16, x: 0, y: 8)
                        
                        // Recipe Image
                        AsyncImage(url: URL(string: recipe.image)) { image in
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: 160, height: 160)
                                .clipShape(Circle())
                                .shadow(color: Color.black.opacity(0.18), radius: 18, x: 0, y: 12)
                                .overlay(Circle().stroke(Color.white, lineWidth: 6))
                        } placeholder: {
                            Circle()
                                .fill(Color.gray.opacity(0.13))
                                .frame(width: 160, height: 160)
                                .overlay(
                                    Image(systemName: "photo")
                                        .imageScale(.large)
                                        .foregroundStyle(.gray.opacity(0.7))
                                )
                        }
                        .offset(y: -80)
                        .animation(.easeOut(duration: 0.6), value: recipe.image)
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 0)
                    
                    Spacer()
                }
            }
        }
        .onDisappear {
            // Cancel all timers
            for cancellable in timerSubscriptions.values {
                cancellable.cancel()
            }
            timerSubscriptions.removeAll()
            stepRunning.removeAll()
            stepTimers.removeAll()
        }
    }
    
    private func toggleTimer(for step: Int) {
        if stepRunning[step] == true {
            // Stop timer
            timerSubscriptions[step]?.cancel()
            timerSubscriptions.removeValue(forKey: step)
            stepRunning[step] = false
        } else {
            // Start timer
            stepRunning[step] = true
            if stepTimers[step] == nil {
                stepTimers[step] = 0
            }
            let publisher = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
            timerSubscriptions[step] = publisher.sink { _ in
                stepTimers[step, default: 0] += 1
            }
        }
    }
}



