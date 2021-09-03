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
  }

  async getSharedPhotos(){
    const result = await PluginShare.getSharedPhotos()
    this.listImages = result.listImages;
    let images = this.listImages .split(";");
    let img = images[2];
    console.log('listImages', images.length);
    
    this.image1 = this._sanitizer.bypassSecurityTrustResourceUrl(`data:image/png;base64, ${images[0]}`); //result.image
    this.image2 = this._sanitizer.bypassSecurityTrustResourceUrl(`data:image/png;base64, ${images[1]}`);
    this.image3 = this._sanitizer.bypassSecurityTrustResourceUrl(`data:image/png;base64, ${images[2]}`);
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
