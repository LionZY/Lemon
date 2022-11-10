import SwiftUI

struct MatchedNoteView: View {
    let match: ScaleNote.Match
    @State var modifierPreference: ModifierPreference

    var body: some View {
        HStack {
            // 主调
            MainNoteView(note: note)
                .frame(maxHeight: Theme.largeButtonHeight)
                .matchFrontColor(isPerceptible: match.distance.isPerceptible)
            VStack {
                // #
                if let modifier = modifier {
                    Text(modifier)
                        .font(.system(size: 40.0))
                        .frame(maxHeight: 30)
                        .matchFrontColor(isPerceptible: match.distance.isPerceptible)
                }
                Spacer()
                // 数字
                Text(String(describing: match.octave))
                    .frame(maxHeight: 30)
                    .font(.system(size: 28.0))
                    .foregroundColor(Color(hex: 0x000000, alpha: 0.2))
            }
        }
        .frame(maxHeight: Theme.largeButtonHeight)
        .animation(.easeInOut, value: match.distance.isPerceptible)
        /*
        .onTapGesture {
            modifierPreference = modifierPreference.toggled
        }
        */
    }

    private var preferredName: String {
        switch modifierPreference {
        case .preferSharps:
            return match.note.names.first!
        case .preferFlats:
            return match.note.names.last!
        }
    }

    private var note: String {
        return String(preferredName.prefix(1))
    }

    private var modifier: String? {
        return preferredName.count > 1 ? String(preferredName.suffix(1)) : nil
    }
}

private extension View {
    @ViewBuilder
    func matchFrontColor(isPerceptible: Bool) -> some View {
        if #available(iOS 16, macOS 13, watchOS 9, *) {
            self.foregroundColor(
                isPerceptible ? .perceptibleMusicalDistance : .imperceptibleMusicalDistance
            )
        } else {
            self.animatingForegroundColor(
                from: .imperceptibleMusicalDistance,
                to: .perceptibleMusicalDistance,
                percentToColor: isPerceptible ? 1 : 0
            )
        }
    }
}

struct MatchedNoteView_Previews: PreviewProvider {
    static var previews: some View {
        MatchedNoteView(
            match: ScaleNote.Match(
                note: .ASharp_BFlat,
                octave: 4,
                distance: 0
            ),
            modifierPreference: .preferSharps
        )
        .previewLayout(.sizeThatFits)
    }
}
