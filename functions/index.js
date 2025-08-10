const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

const db = admin.firestore();

exports.sendDailyNotifications = functions.pubsub.schedule('every 24 hours').onRun(async (context) => {
  const today = new Date();
  today.setHours(0, 0, 0, 0); // Midnight

  const tomorrow = new Date(today);
  tomorrow.setDate(today.getDate() + 1);

  // Get all appointments scheduled for today
  const snapshot = await db.collection('appointments')
    .where('date', '>=', admin.firestore.Timestamp.fromDate(today))
    .where('date', '<', admin.firestore.Timestamp.fromDate(tomorrow))
    .get();

  if (snapshot.empty) {
    console.log('No appointments found for today');
    return null;
  }

  const messages = [];

  for (const doc of snapshot.docs) {
    const data = doc.data();
    const username = data.username;

    // Get user token
    const userDoc = await db.collection('users').where('username', '==', username).limit(1).get();
    if (!userDoc.empty) {
      const user = userDoc.docs[0].data();
      const token = user.fcmToken;

      if (token) {
        messages.push({
          token: token,
          notification: {
            title: 'Appointment Reminder',
            body: `Your appointment with ${data.specialistName} is scheduled for today.`,
          },
        });
      }
    }
  }

  // Send all notifications
  const responses = await admin.messaging().sendAll(messages);
  console.log('Notifications sent:', responses.successCount);
  return null;
});
