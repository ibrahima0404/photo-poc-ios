import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { PhotoService } from 'src/app/services/photo.service';

@Component({
  selector: 'app-appointment-footer',
  templateUrl: './appointment-footer.component.html',
  styleUrls: ['./appointment-footer.component.scss'],
})
export class AppointmentFooterComponent implements OnInit {

  constructor(public photoService: PhotoService, private router: Router) { }

  ngOnInit() { }

  async addPhotoToGallery() {
    await this.photoService.addNewToGallery();
    this.router.navigate(['/appointment/documents']);
  }

  async addPhotoFromGallery() {
    await this.photoService.getPhotoFromGallery();
    this.router.navigate(['/appointment/documents']);
  }

}
