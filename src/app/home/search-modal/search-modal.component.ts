import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { ModalController } from '@ionic/angular';

@Component({
  selector: 'app-search-modal',
  templateUrl: './search-modal.component.html',
  styleUrls: ['./search-modal.component.scss'],
})
export class SearchModalComponent implements OnInit {
  missions: string[];
  missionsToShow: string[];

  constructor(private modalController: ModalController, private router: Router) { }

  ngOnInit() {
    this.missions = ['236 2089 GBD 75 D', '236 3716 GBD 12 D', '148 9513 GBD 75 D', '149 0722 GBD 06 C', '149 1501 GBD 94 E'];
    this.missionsToShow = this.missions;
   }

  dismiss() {
    this.modalController.dismiss();
  }

  searchMission(event: any) {
    this.missionsToShow = this.missions.filter(x => x.includes(event.detail.value));
  }

  appointmentDetails() {
    this.modalController.dismiss();
    this.router.navigateByUrl('/appointment');
  }

}
