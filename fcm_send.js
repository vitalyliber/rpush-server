const args = process.argv

// const message = {
//   token:
//     'dJvrnRox8U17mlQYivrh4l:APA91bHr7gHs_hAmHwVPsEitWaCygQ06xAU4gBGif3BpoozKLtcRIzqU4Y_UW5pWWfBYUwFC-ZcWwQAECthI8G1tTMyHAJKcvdnDg9Pi_O3u9SOEYvapbzV6p3ilA1CNBFRIKu_mI6HN',
//   // tokens:,
//   notification: {
//     title: 'title',
//     body: 'body',
//   },
//   android: {
//     priority: 'high',
//   },
// }

const message = JSON.parse(args[2])
const serviceAccount = JSON.parse(args[3])

const admin = require('firebase-admin')

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
})

async function sendPushNotification(deviceToken, title, body) {
  try {
    const response = await admin.messaging().send(message)
    console.log('Message sent successfully:', response)
  } catch (error) {
    console.error('Error sending message:', error.message)
  }
}

sendPushNotification()
