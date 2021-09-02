import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';

import { IonicModule } from '@ionic/angular';

import { AppointmentPageRoutingModule } from './appointment-routing.module';

import { AppointmentPage } from './appointment.page';
import { AppointmentFooterComponent } from './appointment-footer/appointment-footer.component';
import { ClientComponent } from './client/client.component';
import { DocumentsComponent } from './documents/documents.component';
import { DossierComponent } from './dossier/dossier.component';
import { HistoryComponent } from './history/history.component';
import { InChargeComponent } from './in-charge/in-charge.component';
import { SituationComponent } from './situation/situation.component';

@NgModule({
  imports: [
    CommonModule,
    FormsModule,
    IonicModule,
    AppointmentPageRoutingModule
  ],
  declarations: [
    AppointmentPage,
    AppointmentFooterComponent,
    ClientComponent,
    DocumentsComponent,
    DossierComponent,
    HistoryComponent,
    InChargeComponent,
    SituationComponent
  ]
})
export class AppointmentPageModule { }
