import SwiftUI

struct CurrentNoteMarker: View {
    let frequency: Frequency
    let distance: Frequency.MusicalDistance
    var matchFrontColor: Color {
        distance.isPerceptible ? .perceptibleMusicalDistance : .imperceptibleMusicalDistance
    }
    
    var freqTitle: String {
        frequency.localizedString()
    }
    
    func offsetX(_ geometry: GeometryProxy) -> CGFloat {
        (geometry.size.width / 2) * CGFloat(distance.cents / 50)
    }
    
    let offsetY = (68.0 - 16.0) / 2.0
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Rectangle()
                    .frame(width: 16.0, height: 16.0)
                    .foregroundColor(matchFrontColor)
                    .cornerRadius(8.0)
                Text(freqTitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .frame(width: geometry.size.width)
            .offset(x: offsetX(geometry), y: offsetY)
            .animation(.easeInOut, value: distance.cents)
        }
    }
}

struct CurrentNoteMarker_Previews: PreviewProvider {
    static var previews: some View {
        CurrentNoteMarker(frequency: 440.0, distance: 0)
            .previewLayout(.fixed(width: 300, height: 200))
    }
}
