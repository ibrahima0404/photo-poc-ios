import { Component, NgZone } from '@angular/core';
import { Router } from '@angular/router';
import { Plugins } from '@capacitor/core';
const { PluginShare } = Plugins;

@Component({
  selector: 'app-root',
  templateUrl: 'app.component.html',
  styleUrls: ['app.component.scss'],
})
export class AppComponent {

  constructor(private ngZone: NgZone, private router: Router) { 
    window.addEventListener("sendIntentReceived", () => {
      PluginShare.checkSendIntentReceived().then((result: any) => {
        let images = result.image.split(";");
        console.log('file', result.file);
        console.log('images', images.length);
        console.log('audio', result.audio);
        this.ngZone.run(()=> this.router.navigate(['/appointment']))
      });
  })
  }

}
