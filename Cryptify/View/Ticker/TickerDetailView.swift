//
//  TickerDetailView.swift
//  Cryptify
//
//  Created by Jan Babák on 21.11.2022.
//

import SwiftUI

struct TickerDetailView: View {
    @Binding var navigationPath: [Symbol]
    
    @StateObject var tickerViewModel: TickerViewModel
    @StateObject var marketsViewModel: MarketsViewModel
    
    @State private var timer: Timer?
    
    init(symbol: String, navigationPath: Binding<[Symbol]>, marketsViewModel: MarketsViewModel) {
        self._tickerViewModel = StateObject(wrappedValue: TickerViewModel(symbolId: symbol))
        self._navigationPath = navigationPath
        self._marketsViewModel = StateObject(wrappedValue: marketsViewModel)
    }
    
    var body: some View {
        ScrollView {
            bodyContent
        }
        .task {
            await tickerViewModel.fetchData()
        }
        .refreshable {
            Task {
                await tickerViewModel.fetchData()
            }
        }
        .onAppear {
            timer = Timer.scheduledTimer(withTimeInterval: 7, repeats: true, block: refreshDisplayedView)
        }
        .onDisappear() {
            if let timer { timer.invalidate() }
        }
    }
    
    private var bodyContent: some View {
        VStack {
            if tickerViewModel.tickerState == .loading || tickerViewModel.symbolState == .loading {
                LoadingView()
                    .frame(height: (UIScreen.main.bounds.height / 2) + 36)
            } else if tickerViewModel.tickerState == .error(), case let .error(message) = tickerViewModel.tickerState {
                ErrorView(
                    paragraph: message,
                    showTryAgainButton: true,
                    tryAgainAction: tickerViewModel.fetchData
                )
            } else if tickerViewModel.symbolState == .error(), case let .error(message) = tickerViewModel.symbolState {
                ErrorView(
                    paragraph: message,
                    showTryAgainButton: true,
                    tryAgainAction: tickerViewModel.fetchData
                )
            } else {
                loadedContent
            }
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 16)
        .padding(.top, 8)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                HeaderLogoView()
            }
            ToolbarItem(placement: .principal) { //this replaces the inline navigation title
                Color.clear
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                ToolbarHeaderIconView(icon: "xmark") {
                    navigationPath.removeAll()
                }
            }
        }
    }
    
    private var loadedContent: some View {
        VStack(alignment: .leading) {
            priceAndDailyChange
                
            controls
            
            chart
                .padding(.bottom, 16)
            
            tickerDetails
                .padding(.bottom, 16)
            
            displayedViewPicker
                .padding(.bottom, 16)
            
            if tickerViewModel.displayedView == TickerViewModel.DisplayedView.trades {
                TradesView(tickerViewModel: tickerViewModel)
            } else if tickerViewModel.displayedView == TickerViewModel.DisplayedView.orderBook {
                OrderBookView(tickerViewModel: tickerViewModel)
            }
        }
        .navigationTitle(tickerViewModel.ticker?.displayName ?? "")
        .gesture(
            DragGesture(minimumDistance: 20, coordinateSpace: .local)
                .onEnded(onDragGesture)
        )
    }
    
    @ViewBuilder
    private var priceAndDailyChange: some View {
        if let symbol = tickerViewModel.symbol {
            PriceAndDailyChangeView(symbol: symbol)
        }
    }
    
    private var controls: some View {
        HStack(spacing: 16) {
            chartTypePicker
            
            intervalPicker
            
            Spacer()
            
            addAndRemoveFromListMenu
        }.padding(.horizontal, 0)
    }
    
    @ViewBuilder
    private var chart: some View {
        if tickerViewModel.candlesState == .loading {
            LoadingView()
                .frame(height: 290)
        } else if tickerViewModel.candlesState == .error(), case let .error(message) = tickerViewModel.candlesState {
            ErrorView(
                heading: NSLocalizedString("chartNotAvailable", comment: "Chart error heading."),
                paragraph: message,
                showTryAgainButton: true,
                tryAgainAction: tickerViewModel.fetchCandles,
                showImage: false
            )
        } else {
            ChartView(viewModel: tickerViewModel)
        }
    }
    
    @ViewBuilder
    private var tickerDetails: some View {
        if let ticker = tickerViewModel.ticker {
            DetailsView(ticker: ticker)
        } else {
            LoadingView()
        }
    }
    
    // MARK: - inputs

    private var chartTypePicker: some View {
        Picker(LocalizedStringKey("chartType"), selection: $tickerViewModel.selectedChart) {
            ForEach(TickerViewModel.ChartType.allCases) { chartType in
                Text(LocalizedStringKey(chartType.rawValue))
                    .tag(chartType)
            }
        }
        .onChange(of: tickerViewModel.selectedChart) { newValue in
            SoundManager.shared.playTab()
        }
        .padding(.horizontal, -11)
        .onTapGesture {
            SoundManager.shared.playTab()
        }
    }
    
    private var intervalPicker: some View {
        Picker(LocalizedStringKey("interval"), selection: $tickerViewModel.selectedInterval) {
            ForEach(TickerViewModel.Interval.allCases) { interval in
                Text(LocalizedStringKey(interval.rawValue))
                    .tag(interval)
            }
        }
        .onChange(of: tickerViewModel.selectedInterval) { interval in
            SoundManager.shared.playTab()
            Task {
                await tickerViewModel.fetchCandles()
                tickerViewModel.animateChart()
            }
        }
        .padding(.horizontal, -11)
        .onTapGesture {
            SoundManager.shared.playTab()
        }
    }
    
    private var addAndRemoveFromListMenu: some View {
        Menu {
            AddAndRemoveSymbolFromListMenuContent(
                marketsViewModel: marketsViewModel,
                symbolId: tickerViewModel.symbol?.symbol ?? ""
            )
        } label: {
            Image(systemName: "ellipsis")
                .font(.title2)
                .frame(width: 64, height: 24, alignment: .trailing)
        }
        .onTapGesture {
            SoundManager.shared.playTab()
        }
    }
    
    //picker between trades and order book views
    private var displayedViewPicker: some View {
        Picker("Displayed View", selection: $tickerViewModel.displayedView) {
            ForEach(TickerViewModel.DisplayedView.allCases) { view in
                Text(LocalizedStringKey(view.rawValue))
                    .tag(view)
            }
        }
        .pickerStyle(.segmented)
        .onChange(of: tickerViewModel.displayedView) { newValue in
            SoundManager.shared.playTab()
            Task {
                await tickerViewModel.refreshDisplayedView()
            }
        }
    }
    
    // MARK: - functions
    
    //helper function, because timer doesn't support async functions
    //don't know if it's neccessary, api doen't change that frequently
    private func refreshDisplayedView(timer: Timer) {
        Task {
            await tickerViewModel.refreshDisplayedView()
        }
    }
    
    //on drag
    private func onDragGesture(value: DragGesture.Value) {
        if value.translation.width < 0, let symbolId = tickerViewModel.symbol?.symbol {
            let symbol = marketsViewModel.getNextSymbol(symbolId: symbolId)
            if let symbol {
                SoundManager.shared.playTransitionRight()
                navigationPath.append(symbol)
            }
        }

        if value.translation.width > 0 {
            SoundManager.shared.playTransitionLeft()
            navigationPath.removeLast()
        }
    }
}

struct TickerDetailView_Previews: PreviewProvider {
    static var previews: some View {
        TickerDetailView(symbol: "BTC / USDT", navigationPath: .constant([]), marketsViewModel: .init())
    }
}
