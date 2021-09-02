import { Injectable } from '@angular/core';
import { Appointment } from '../interfaces/appointment';

@Injectable({
  providedIn: 'root'
})
export class AppointmentService {

  constructor() { }

  public loadFirstAppointment(): Appointment {
    return {
      address: '9-11 Rue Georges Enesco',
      caseName: 'TEST NOA SIMPLIFIE ALLIANZ 1',
      city: 'Créteil',
      date: new Date(2021, 7, 23, 14, 20, 0),
      missionId: 2366625,
      missionNumber: '236 6625 AFA 94 C',
      missionType: 'DO',
      postalCode: '94000'
    };
  }

  public loadAppointments(): Appointment[] {
    return [
      {
        address: '1 Rue de Gascogne',
        caseName: 'TEST METRES BOND*',
        city: 'Sarcelles',
        date: new Date(2021, 7, 30, 13, 37, 0),
        missionId: 2368633,
        missionNumber: '236 8633 IMV 95 D',
        missionType: 'DDE',
        postalCode: '95200'
      },
      {
        address: '1 Rue de Gascogne',
        caseName: 'TEST METRES BOND*',
        city: 'Sarcelles',
        date: new Date(2021, 7, 30, 13, 37, 0),
        missionId: 2368633,
        missionNumber: '236 8633 IMV 95 D',
        missionType: 'DDE',
        postalCode: '95200'
      },
      {
        address: '1 Rue de Gascogne',
        caseName: 'TEST METRES BOND*',
        city: 'Sarcelles',
        date: new Date(2021, 7, 30, 13, 37, 0),
        missionId: 2368633,
        missionNumber: '236 8633 IMV 95 D',
        missionType: 'DDE',
        postalCode: '95200'
      },
      {
        address: '1 Rue de Gascogne',
        caseName: 'TEST METRES BOND*',
        city: 'Sarcelles',
        date: new Date(2021, 7, 30, 13, 37, 0),
        missionId: 2368633,
        missionNumber: '236 8633 IMV 95 D',
        missionType: 'DDE',
        postalCode: '95200'
      }
    ];
  }
}
