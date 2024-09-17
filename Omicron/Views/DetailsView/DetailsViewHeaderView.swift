//
//  DetailsViewHeader.swift
//  Omicron
//
//  Created by Beni Kis on 11/08/2024.
//

import SwiftUI

struct DetailsViewHeader: View {
    @Binding var show: ShowModel
    @Binding var ratingOverlayPresented: Bool
    
    var body: some View {
        
    }
}

#Preview {
    DetailsViewHeader(show: Binding.constant(ShowModel.sample), ratingOverlayPresented: Binding.constant(false))
}
