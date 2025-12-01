importScripts("https://www.gstatic.com/firebasejs/7.23.0/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/7.23.0/firebase-messaging.js");
firebase.initializeApp({
                           apiKey: "AIzaSyBnFpq7-OFEHvhb1cSrAqLcjq4ToqT-kZY",
                           authDomain: "jobportal-40127.firebaseapp.com",
                           projectId: "jobportal-40127",
                           storageBucket: "jobportal-40127.appspot.com",
                           messagingSenderId: "794203744125",
                           appId: "1:794203744125:web:7e6982e81e61c66755ce14",
                           measurementId: "G-65FVN28JL6"
                       });
const messaging = firebase.messaging();


messaging.setBackgroundMessageHandler(function (payload) {
    const promiseChain = clients
        .matchAll({
            type: "window",
            includeUncontrolled: true
        })
        .then(windowClients => {
            for (let i = 0; i < windowClients.length; i++) {
                const windowClient = windowClients[i];
                windowClient.postMessage(payload);
            }
        })
        .then(() => {
            const title = payload.notification.title;
            const options = {
                body: payload.notification.score
              };
            return registration.showNotification(title, options);
        });
    return promiseChain;
});
self.addEventListener('notificationclick', function (event) {
    console.log('notification received: ', event)
});