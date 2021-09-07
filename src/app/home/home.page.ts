import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { IonRouterOutlet, ModalController } from '@ionic/angular';
import { Appointment } from '../interfaces/appointment';
import { AppointmentService } from '../services/appointment.service';
import { SearchModalComponent } from './search-modal/search-modal.component';
import { Plugins } from '@capacitor/core';
import { DomSanitizer, SafeResourceUrl, SafeUrl} from '@angular/platform-browser';

const { PluginShare } = Plugins;

@Component({
  selector: 'app-home',
  templateUrl: './home.page.html',
  styleUrls: ['./home.page.scss'],
})
export class HomePage implements OnInit {
  appointments: Appointment[];
  nextAppointment: Appointment;

  image1; //: string = 'http://placehold.it/500x500';
  image2;
  image3;
  listImages;

  constructor(private router: Router,
    public modalController: ModalController,
    private routerOutlet: IonRouterOutlet,
    private appointmentService: AppointmentService,
    private _sanitizer: DomSanitizer) { }

  ngOnInit() {
    this.nextAppointment = this.appointmentService.loadFirstAppointment();
    this.appointments = this.appointmentService.loadAppointments();
    window.addEventListener("sendIntentReceived", () => {
      PluginShare.checkSendIntentReceived().then((result: any) => {
        let images = result.image .split(";");
        console.log('result', images.length);
        //this.image1 = this._sanitizer.bypassSecurityTrustResourceUrl(`data:image/png;base64, ${result.image}`);
          if (result.text) {
           
          }
      });
  })
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
