import SwiftUI

struct WellnessDashboardView: View {
    enum Segment: String, CaseIterable, Identifiable {
        case overview = "Overview"
        case metrics = "Metrics"
        case trends = "Trends"
        var id: String { rawValue }
    }

    struct SummaryMetric: Identifiable {
        let id = UUID()
        let title: String
        let value: String
        let trendText: String
        let trendStyle: TrendStyle

        enum TrendStyle {
            case positive
            case neutral
            case negative

            var color: Color {
                switch self {
                case .positive: return Color.green
                case .neutral: return Color.orange
                case .negative: return Color.red
                }
            }
        }
    }

    struct TimelineEntry: Identifiable {
        let id = UUID()
        let icon: String
        let iconBackground: Color
        let title: String
        let subtitle: String
    }

    private let summaryMetrics: [SummaryMetric] = [
        .init(title: "Heart Rate", value: "64 bpm", trendText: "↑ 2 bpm", trendStyle: .positive),
        .init(title: "Mindful Minutes", value: "18 min", trendText: "• on track", trendStyle: .neutral),
        .init(title: "Sleep Quality", value: "92%", trendText: "↑ +5%", trendStyle: .positive),
        .init(title: "Stress Check-in", value: "Low", trendText: "↓ balanced", trendStyle: .positive)
    ]

    private let nextUpEntry = TimelineEntry(
        icon: "applelogo",
        iconBackground: Color.blue.opacity(0.18),
        title: "Guided Breath Reset",
        subtitle: "Starts in 15 min • 5 minute focus"
    )

    private let recentEntries: [TimelineEntry] = [
        .init(
            icon: "checkmark",
            iconBackground: Color.green.opacity(0.18),
            title: "Morning Routine",
            subtitle: "Stretch & reflect • Completed 07:30"
        ),
        .init(
            icon: "sun.max.fill",
            iconBackground: Color.orange.opacity(0.18),
            title: "Sunlight Break",
            subtitle: "Logged • 16 minute outdoor walk"
        )
    ]

    @State private var selectedSegment: Segment = .overview

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                background

                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 28) {
                        header
                        segmentControl
                        summarySection
                        overviewCard
                        timelineSection
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 32)
                    .padding(.bottom, 140)
                }

                tabBar
            }
            .navigationBarHidden(true)
        }
    }

    private var background: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                Color(red: 246/255, green: 247/255, blue: 255/255),
                Color(red: 236/255, green: 240/255, blue: 255/255),
                Color.white
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }

    private var header: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 6) {
                Text("Wellness")
                    .font(.system(size: 34, weight: .bold, design: .rounded))
                    .tracking(-0.5)
                Text("Track your day with mindful insights.")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(Color.secondary.opacity(0.75))
            }
            Spacer()
            Button(action: {}) {
                Text("JF")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(Color.blue)
                    .frame(width: 48, height: 48)
                    .background(Color.blue.opacity(0.12))
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            }
            .buttonStyle(.plain)
        }
    }

    private var segmentControl: some View {
        Picker("", selection: $selectedSegment) {
            ForEach(Segment.allCases) { segment in
                Text(segment.rawValue).tag(segment)
            }
        }
        .pickerStyle(.segmented)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Color.black.opacity(0.04))
        )
    }

    private var summarySection: some View {
        LazyVGrid(
            columns: [
                GridItem(.flexible(), spacing: 18),
                GridItem(.flexible(), spacing: 18)
            ],
            spacing: 18
        ) {
            ForEach(summaryMetrics) { metric in
                SummaryCard(metric: metric)
            }
        }
    }

    private var overviewCard: some View {
        ZStack(alignment: .leading) {
            LinearGradient(
                colors: [
                    Color.blue.opacity(0.92),
                    Color(red: 12/255, green: 75/255, blue: 187/255)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .clipShape(RoundedRectangle(cornerRadius: 26, style: .continuous))
            .overlay(
                Circle()
                    .fill(Color.white.opacity(0.15))
                    .frame(width: 240, height: 240)
                    .offset(x: 140, y: -112)
            )

            VStack(alignment: .leading, spacing: 12) {
                Text("Your day, in harmony")
                    .font(.system(size: 22, weight: .semibold))
                Text("Breathing exercises and gentle reminders keep you centred. Review guided sessions and adaptive focus routines tailored for the afternoon slump.")
                    .font(.system(size: 15, weight: .medium))
                    .lineSpacing(5)
                    .foregroundColor(Color.white.opacity(0.86))
            }
            .foregroundColor(.white)
            .padding(28)
        }
    }

    private var timelineSection: some View {
        VStack(alignment: .leading, spacing: 22) {
            VStack(alignment: .leading, spacing: 12) {
                SectionLabel("Next up")
                TimelineCard(entry: nextUpEntry)
            }

            VStack(alignment: .leading, spacing: 12) {
                SectionLabel("Recent activity")
                ForEach(recentEntries) { entry in
                    TimelineCard(entry: entry)
                }
            }
        }
    }

    private var tabBar: some View {
        ZStack {
            Rectangle()
                .fill(Color.clear)
                .frame(height: 120)
                .ignoresSafeArea(edges: .bottom)

            HStack(spacing: 18) {
                TabItem(icon: "house.fill", title: "Home", isActive: true)
                TabItem(icon: "chart.bar.xaxis", title: "Metrics")
                TabItem(icon: "star.fill", title: "Focus")
                TabItem(icon: "ellipsis", title: "More")
            }
            .padding(.horizontal, 22)
            .padding(.vertical, 16)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 28, style: .continuous)
                    .fill(Color.black.opacity(0.82))
                    .blur(radius: 0.1)
                    .shadow(color: Color.black.opacity(0.25), radius: 24, x: 0, y: 20)
            )
            .padding(.horizontal, 28)
            .padding(.bottom, 12)
        }
    }
}

// MARK: - Components

private struct SummaryCard: View {
    let metric: WellnessDashboardView.SummaryMetric

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(metric.title.uppercased())
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(Color.secondary.opacity(0.68))
                .tracking(0.8)
            Text(metric.value)
                .font(.system(size: 28, weight: .bold))
                .tracking(-0.5)

            Text(metric.trendText)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(metric.trendStyle.color)
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(Color.white)
                .shadow(
                    color: Color.black.opacity(0.07),
                    radius: 20,
                    x: 0,
                    y: 14
                )
        )
    }
}

private struct SectionLabel: View {
    let title: String

    init(_ title: String) {
        self.title = title
    }

    var body: some View {
        Text(title.uppercased())
            .font(.system(size: 13, weight: .semibold))
            .foregroundColor(Color.secondary.opacity(0.7))
            .tracking(1.2)
    }
}

private struct TimelineCard: View {
    let entry: WellnessDashboardView.TimelineEntry

    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(entry.iconBackground)
                    .frame(width: 52, height: 52)

                Image(systemName: entry.icon)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(iconColor)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(entry.title)
                    .font(.system(size: 16, weight: .semibold))
                Text(entry.subtitle)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(Color.secondary.opacity(0.7))
            }
            Spacer(minLength: 12)

            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(Color.secondary.opacity(0.4))
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 18)
        .background(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(Color.white)
                .shadow(
                    color: Color.black.opacity(0.06),
                    radius: 16,
                    x: 0,
                    y: 12
                )
        )
    }

    private var iconColor: Color {
        switch entry.icon {
        case "checkmark":
            return Color.green
        case "sun.max.fill":
            return Color.orange
        default:
            return Color.blue
        }
    }
}

private struct TabItem: View {
    let icon: String
    let title: String
    var isActive: Bool = false

    var body: some View {
        VStack(spacing: 6) {
            ZStack {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(isActive ? Color.white.opacity(0.18) : Color.clear)
                    .frame(width: 36, height: 36)

                Image(systemName: icon)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(isActive ? .white : Color.white.opacity(0.7))
            }
            Text(title.uppercased())
                .font(.system(size: 11, weight: .semibold))
                .foregroundColor(isActive ? .white : Color.white.opacity(0.6))
                .tracking(0.6)
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Preview

struct WellnessDashboardView_Previews: PreviewProvider {
    static var previews: some View {
        WellnessDashboardView()
            .preferredColorScheme(.light)
    }
}
