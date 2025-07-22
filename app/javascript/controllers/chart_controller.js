import { Controller } from "@hotwired/stimulus"
import Chart from "chart.js/auto"

// Connects to data-controller="chart"
export default class extends Controller {
  connect() {
    const ctx = document.getElementById("bubbleChart").getContext("2d")

    this.chart = new Chart(ctx, {
      type: 'bubble',
      data: {
        datasets: [
          {
            label: '200 OK',
            data: [],
            backgroundColor: 'rgba(75, 192, 192, 0.6)'
          },
          {
            label: '429 Too Many',
            data: [],
            backgroundColor: 'rgba(255, 99, 132, 0.6)'
          }
        ]
      },
      options: {
        parsing: false,
        scales: {
          x: {
            type: 'linear',
            title: { display: true, text: 'Time' },
            ticks: {
              display: false
            }
          },
          y: {
            type: 'linear',
            min: 0.5,
            max: 2.5,
            title: { display: true, text: 'Status Code' },
            ticks: {
              callback: function (value) {
                if (value === 1) return '200 OK'
                if (value === 2) return '429 Too Many'
                return ''
              },
              stepSize: 1,
            }
          }
        }
      }
    })
  }

  sendRequest() {
    fetch('/trigger')
      .then(res => res.json())
      .then(data => {
        const bubble = {
          x: data.time,
          y: data.status_code === 200 ? 1 : 2,
          r: 8
        }

        if (data.status_code === 200) {
          this.chart.data.datasets[0].data.push(bubble)
        } else if (data.status_code === 429) {
          this.chart.data.datasets[1].data.push(bubble)
        } else {
          console.warn("Unexpected status code:", data.status_code)
        }

        this.chart.update()
      })
  }
}
