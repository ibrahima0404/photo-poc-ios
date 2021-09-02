import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import { ClientComponent } from './client/client.component';
import { DocumentsComponent } from './documents/documents.component';
import { DossierComponent } from './dossier/dossier.component';
import { HistoryComponent } from './history/history.component';
import { InChargeComponent } from './in-charge/in-charge.component';
import { SituationComponent } from './situation/situation.component';
import { AppointmentPage } from './appointment.page';

const routes: Routes = [
  {
    path: '',
    component: AppointmentPage,
    children: [
      {
        path: 'dossier',
        component: DossierComponent,
      },
      {
        path: 'client',
        component: ClientComponent
      },
      {
        path: 'situation',
        component: SituationComponent
      },
      {
        path: 'in-charge',
        component: InChargeComponent
      },
      {
        path: 'documents',
        component: DocumentsComponent
      },
      {
        path: 'history',
        component: HistoryComponent
      },
      {
        path: '',
        redirectTo: 'dossier',
        pathMatch: 'full'
      }
    ]
  },
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule],
})
export class AppointmentPageRoutingModule { }
