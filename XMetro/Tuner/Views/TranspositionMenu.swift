import SwiftUI

struct TranspositionMenu: View {
    private let transpositions = ScaleNote.allCases
    @Binding var selectedTransposition: Int
    var body: some View {
        Menu(
            content: {
                ForEach(transpositions) { transposition in
                    Button(
                        action: { selectedTransposition = transposition.rawValue },
                        label: { Text(transposition.transpositionName) }
                    )
                }
            },
            label: {
                Text("Tone: \(transpositions[selectedTransposition].transpositionName)")
                    .frame(minWidth: 64, alignment: .leading)
            }
        )
        .transaction { transaction in
            transaction.disablesAnimations = true
            transaction.animation = nil
        }
    }
}

private extension ScaleNote {
    var transpositionName: String {
        return names.joined(separator: " / ")
    }
}

struct TranspositionMenu_Previews: PreviewProvider {
    static var previews: some View {
        TranspositionMenu(selectedTransposition: .constant(0))
            .previewLayout(.sizeThatFits)
    }
}
