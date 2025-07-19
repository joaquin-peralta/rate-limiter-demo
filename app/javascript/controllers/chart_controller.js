import { Controller } from "@hotwired/stimulus"
import Chart from 'chart.js/auto'

// Connects to data-controller="chart"
export default class extends Controller {
  connect() {
    (async function() {
      const data = {
        datasets: [{
          label: 'Instance 1',
          data: [{
            x: 5,
            y: 200,
            r: 5
          },
        {
            x: 8,
            y: 200,
            r: 5
          },
        {
            x: 16,
            y: 429,
            r: 5
          }],
          backgroundColor: 'rgba(99, 109, 255, 1)'
        },
        {
          label: 'Instance 2',
          data: [{
            x: 5,
            y: 200,
            r: 5
          },
          {
            x: 9,
            y: 429,
            r: 5
          },
        {
            x: 20,
            y: 429,
            r: 5
          }],
          backgroundColor: 'rgba(99, 255, 177, 1)',
        }
      ]
      };

      new Chart(
        document.getElementById('bubbleChart'),
        {
            type: 'bubble',
            data: data,
            options: {}
        }
      );
    })();
  }
}
