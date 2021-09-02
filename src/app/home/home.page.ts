import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { IonRouterOutlet, ModalController } from '@ionic/angular';
import { Appointment } from '../interfaces/appointment';
import { AppointmentService } from '../services/appointment.service';
import { SearchModalComponent } from './search-modal/search-modal.component';

@Component({
  selector: 'app-home',
  templateUrl: './home.page.html',
  styleUrls: ['./home.page.scss'],
})
export class HomePage implements OnInit {
  appointments: Appointment[];
  nextAppointment: Appointment;

  constructor(private router: Router,
    public modalController: ModalController,
    private routerOutlet: IonRouterOutlet,
    private appointmentService: AppointmentService) { }

  ngOnInit() {
    this.nextAppointment = this.appointmentService.loadFirstAppointment();
    this.appointments = this.appointmentService.loadAppointments();
  }

  async openSearchModal() {
    const modal = await this.modalController.create({
      component: SearchModalComponent,
      swipeToClose: true,
      presentingElement: this.routerOutlet.nativeEl
    });
    return await modal.present();
  }

  appointmentDetails() {
    this.router.navigateByUrl('/appointment');
  }

}
