var firebaseConfig = {
     apiKey: "AIzaSyBnFpq7-OFEHvhb1cSrAqLcjq4ToqT-kZY",
     authDomain: "jobportal-40127.firebaseapp.com",
     projectId: "jobportal-40127",
     storageBucket: "jobportal-40127.appspot.com",
     messagingSenderId: "794203744125",
     appId: "1:794203744125:web:7e6982e81e61c66755ce14",
     measurementId: "G-65FVN28JL6"
};

firebase.initializeApp(firebaseConfig);
firebase.analytics();

var messaging = firebase.messaging()

messaging.usePublicVapidKey('BB1VYQu9mOB-ieSBuukVs-Zr7ELKeYPrs-ZANnCypnbiDKCgm_HXAaZmm9h67SY0kQLHrZR--dFuubuTVJ91lOg');

messaging.getToken().then((currentToken) => {
    console.log(currentToken)
})