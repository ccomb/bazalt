// JS to delete the messages with flow="Received"
var deleteRequest = window.indexedDB.open("messagestore", 46);
deleteRequest.onsuccess = (event) => {
  db = event.target.result;
  transaction = db.transaction('messages', 'readwrite');
  const objectStore = transaction.objectStore("messages");

  objectStore.openCursor().onsuccess = (event) => {
    const cursor = event.target.result;
    if (cursor) {
      console.log(`Flow for Message ${cursor.key} is ${cursor.value.meta.flow}`);
      if (cursor.value.meta.flow == "Received") {
        transaction.objectStore("messages").delete(cursor.key);
        console.log("deleted " + cursor.key)
      }
      cursor.continue();
    } else {
      console.log("No more entries!");
    }
  };
};
deleteRequest.onerror = (event) => {
  console.log(event);
}
