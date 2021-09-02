import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';

import { IonicModule } from '@ionic/angular';

import { HomePageRoutingModule } from './home-routing.module';

import { HomePage } from './home.page';
import { HomeFooterComponent } from './home-footer/home-footer.component';
import { SearchModalComponent } from './search-modal/search-modal.component';
import { SettingsComponent } from './settings/settings.component';

@NgModule({
  imports: [
    CommonModule,
    FormsModule,
    IonicModule,
    HomePageRoutingModule,
  ],
  declarations: [
    HomePage,
    HomeFooterComponent,
    SearchModalComponent,
    SettingsComponent
  ]
})
export class HomePageModule {}
